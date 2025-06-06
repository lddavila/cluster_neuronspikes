function [table_of_best_representation] = return_best_conf_for_cluster_ver_5_using_nn(table_of_overlapping_clusters,timestamp_array,min_overlap_percentage,config)
    function [table_of_other_appearences] = recursively_identify_chains_of_overlap(cell_array_of_dicts,table_of_overlapping_clusters,already_appeared)
        head_of_cell_array_of_dicts = cell_array_of_dicts{1};
        other_tetrode_list = head_of_cell_array_of_dicts("tetrodes of other appearences").';
        other_z_score_list = str2double(head_of_cell_array_of_dicts("Z score of other appearences")).';
        other_cluster_list = str2double(head_of_cell_array_of_dicts("cluster number of other appearences")).';
        other_cluster_list(isnan(other_cluster_list)) = [];
        other_z_score_list(isnan(other_z_score_list)) = [];

        if isempty(other_tetrode_list) &&isempty(other_cluster_list) &&isempty(other_z_score_list)
            table_of_other_appearences = [];
            return;
        end


        table_of_already_appeared = table(other_z_score_list,other_tetrode_list,other_cluster_list,'VariableNames',["Z Score","Tetrode","Cluster"]);
        if isempty(table_of_already_appeared)
            table_of_other_appearences = [];
        else
            c1 = table_of_overlapping_clusters{:,"Tetrode"}==table_of_already_appeared{:,"Tetrode"}.';
            c2 = table_of_overlapping_clusters{:,"Z Score"}==table_of_already_appeared{:,"Z Score"}.';
            c3 = table_of_overlapping_clusters{:,"Cluster"}==table_of_already_appeared{:,"Cluster"}.';
            [rows_with_dicts_of_other_appearences,~] = find(c1 & c2 & c3);

            dictionaries_of_other_appearences_other_appearences = table_of_overlapping_clusters{rows_with_dicts_of_other_appearences,"Other Appearence Info"};
            if ~isempty(already_appeared)
                [not_already_appeared,indexes_of_not_appeared] = setdiff(table_of_already_appeared,already_appeared);
            else
                indexes_of_not_appeared = 1:size(table_of_already_appeared,1);
                not_already_appeared = table_of_already_appeared;
            end

            if ~isempty(indexes_of_not_appeared)
                new_cell_array_of_dicts = [cell_array_of_dicts,dictionaries_of_other_appearences_other_appearences(indexes_of_not_appeared).'];
            else
                new_cell_array_of_dicts = cell_array_of_dicts;
            end

            if ismissing(other_tetrode_list)
                print("something's wrong")
            end
            if isempty(not_already_appeared)
                table_of_other_appearences = table_of_already_appeared ;
            else
                table_of_other_appearences = [already_appeared;recursively_identify_chains_of_overlap(new_cell_array_of_dicts(2:end),table_of_overlapping_clusters,[already_appeared;table_of_already_appeared])];
            end
        end
    end
    function [table_of_other_appearences] = get_other_appearences_in_table_format(other_appearences_dict,table_of_overlapping_clusters,current_z_score,current_cluster_num,current_tetrode)

        %recursively identify all the clusters that the current cluster has overlap with and all the clusters that have overlap with those other clusters
        table_of_other_appearences =[table(current_z_score,current_tetrode,current_cluster_num,'VariableNames',["Z Score","Tetrode","Cluster"]);recursively_identify_chains_of_overlap({other_appearences_dict},table_of_overlapping_clusters,[])];


        only_grades_col = table_of_overlapping_clusters(:,["Z Score","Tetrode","Cluster","grades","idx of its location in arrays"]);
        only_idx_col = table_of_overlapping_clusters(:,["Z Score","Tetrode","Cluster","idx of its location in arrays"]);
        % 
        % %join the grades of all current appearences
        table_of_other_appearences_grades = join(table_of_other_appearences,only_grades_col,"Keys",["Z Score","Tetrode","Cluster"]);
        table_of_other_appearence_idxs = join(table_of_other_appearences,only_idx_col,"Keys",["Z Score","Tetrode","Cluster"]);
        grades_array = table_of_other_appearences_grades(:,"grades");
        snr = nan(size(table_of_other_appearences_grades,1),1);
        for q=1:size(snr,1)
            current_grades = grades_array{q,"grades"}{1};
            snr(q) = current_grades{40};
        end
        % snr = grades_array(:,40);
        table_of_other_appearences.SNR = snr;
        table_of_other_appearences.("idx of its location in arrays") = table_of_other_appearence_idxs{:,"idx of its location in arrays"};
        table_of_other_appearences.("grades") = table_of_other_appearences_grades{:,"grades"};
        table_of_other_appearences.("absorbed_cases") = cell(size(table_of_other_appearences_grades,1),1);
        table_of_other_appearences.("Mean Waveform") = table_of_overlapping_clusters{table_of_other_appearences{:,"idx of its location in arrays"},"Mean Waveform"};

    end
    function [already_appeared,table_of_best_representation,was_added] = check_for_previous_appearence(table_of_other_appearences,already_appeared,table_of_best_representation,i,table_of_overlapping_clusters)
        was_added=false;
        %please note that I run the nested check because ismember fails in
        %the case of already_appeared being empty
        if size(table_of_other_appearences,1)==1
            %first ensure that this cluster/neuron hasn't already been
            %accounted for by some other cluster/neuron
            to_be_added =table_of_other_appearences{1,"Tetrode"}+" "+string(table_of_other_appearences{1,"Z Score"})+" "+string(table_of_other_appearences{1,"Cluster"}) ;
            if  ~isempty(already_appeared) % check to ensure that there are no other clusters have been added to already_appeared
                if ~ismember(to_be_added,already_appeared) %checks to ensure that this cluster hasn't already been added to the table of best appearences via some other configuration
                    disp("Finished "+string(i)+"/"+string(size(table_of_overlapping_clusters,1)));
                    table_of_best_representation(i,:) = table_of_other_appearences(1,:);
                    was_added=true;
                end
            else %if the already appeared list is empty then we can automatically add this cluster to the already appeared list as it is the first and best appearence of this particular cluster
                disp("Finished "+string(i)+"/"+string(size(table_of_overlapping_clusters,1)));
                table_of_best_representation(i,:) = table_of_other_appearences(1,:);
                already_appeared = [already_appeared,to_be_added];
                was_added=true;
            end
            %continue;
        end
    end

    function [already_appeared,run_continue,table_of_best_representation] =add_to_table_of_best_representation(already_appeared,table_of_other_appearences,timestamp_array,best_rep,min_overlap_percentage,table_of_best_representation,i,table_of_overlapping_clusters,config)
        run_continue = false;
        %check to ensure that this cluster hasn't already appeared on
        %another cluster's best appearences list
        %this ensures that there's no duplicates (multiple clusters
        %representing the same unit
        to_be_added = table_of_other_appearences{:,"Tetrode"}+" "+table_of_other_appearences{:,"Z Score"}+" "+table_of_other_appearences{:,"Cluster"};
        if any(ismember(to_be_added,already_appeared))
            %if to_be_added is already a member of the
            %already_appeared_list then we take all of its other
            %appearences and union that with the already_appeared list
            %this ensures the elimination of auxilary clusters
            % already_appeared = union(already_appeared,to_be_added);
            disp("Finished "+string(i)+"/"+string(size(table_of_overlapping_clusters,1)));
            run_continue = true;
        else
            best_appearences = table_of_best_representation(~isnan(table_of_best_representation{:,"Cluster"}),:);
            %before adding the cluster to the table of best representations
            %ensure it doesn't have a significant amount of overlap with
            %another cluster that's already on the table
            %this ensures that we are not oversplitting the cluster
            is_already_represented=false;
            for best_appearences_row_counter=1:size(best_appearences,1)
                timestamps_of_current_best_appearences = timestamp_array{table_of_other_appearences{best_rep,"idx of its location in arrays"}};
                timestamps_of_previously_found_best_appearences = timestamp_array{best_appearences{best_appearences_row_counter,"idx of its location in arrays"}};
                size_of_smaller_cluster = min(length(timestamps_of_current_best_appearences),length(timestamps_of_previously_found_best_appearences)) ;
                if length(timestamps_of_current_best_appearences) > length(timestamps_of_previously_found_best_appearences)
                    num_tp = get_tp_count_given_a_tdelta_hpc(timestamps_of_previously_found_best_appearences,timestamps_of_current_best_appearences,0.004);
                elseif length(timestamps_of_previously_found_best_appearences) > length(timestamps_of_current_best_appearences)
                    num_tp = get_tp_count_given_a_tdelta_hpc(timestamps_of_current_best_appearences,timestamps_of_previously_found_best_appearences,0.004);
                else
                    num_tp = get_tp_count_given_a_tdelta_hpc(timestamps_of_current_best_appearences,timestamps_of_previously_found_best_appearences,0.004);
                end

                true_overlap_percentage = num_tp/size_of_smaller_cluster;
                if true_overlap_percentage > min_overlap_percentage
                    is_already_represented = true;
                end
            end
            if ~is_already_represented
                table_of_best_representation(i,:) = table_of_other_appearences(best_rep,:);
                table_of_best_representation{i,"absorbed_cases"} = {table_of_other_appearences};
            end
            %indexes_of_to_be_added_to_add = run_tests_for_to_be_added(timestamp_array,config,table_of_overlapping_clusters,table_of_best_representation,table_of_other_appearences);
            already_appeared = union(already_appeared,to_be_added);
        end
    end

    function [best_rep] = find_best_rep(table_of_other_appearences,config,choose_better_net)
        best_rep = NaN;

        % to get the best rep we must compare the 2 mean waveforms using a pre-trained nn
        % and then essentially bubble sort them
        % we then perform the choose best among all best
       

        %compare every permutation to see which one chooses better
        unsorted_table_of_other_appearences = table_of_other_appearences;

        %now run the buble sort
        % disp("Before Sort")
        % disp(table_of_other_appearences)
        for counter=1:size(table_of_other_appearences,1)
            swapped=0;
            for current_wave_ind =1:size(table_of_other_appearences,1)-counter
                wave_1 = table_of_other_appearences{current_wave_ind,"Mean Waveform"}{1};
                wave_2 = table_of_other_appearences{current_wave_ind+1,"Mean Waveform"}{1};

                is_wave_1_better_probabilities = predict(choose_better_net,[wave_1,wave_2]);
                [~,max_index] = max(is_wave_1_better_probabilities);
                is_wave_1_better = max_index-1;
                if is_wave_1_better
                    temp_row = table_of_other_appearences(current_wave_ind,:);
                    table_of_other_appearences(current_wave_ind,:) = table_of_other_appearences(current_wave_ind+1,:);
                    table_of_other_appearences(current_wave_ind+1,:) = temp_row;  
                    swapped=true;
                end
            end
            if ~swapped
                break;
            end
        end
        % disp("After Sort")
        % disp(table_of_other_appearences);

        z_score_cond = unsorted_table_of_other_appearences{:,"Z Score"} ==table_of_other_appearences{end,"Z Score"};
        tetr_cond = unsorted_table_of_other_appearences{:,"Tetrode"} == table_of_other_appearences{end,"Tetrode"};
        cluster_cond = unsorted_table_of_other_appearences{:,"Cluster"} ==table_of_other_appearences{end,"Cluster"};

        best_rep = find(z_score_cond & cluster_cond & tetr_cond);
    end

%table which will contain the best representation of every cluster identified as a neuron
table_of_best_representation = table(nan(10000,1),repelem("",10000,1),nan(10000,1),nan(10000,1),nan(10000,1),cell(10000,1),cell(10000,1),cell(10000,1),'VariableNames',["Z Score","Tetrode","Cluster","SNR","idx of its location in arrays","grades","absorbed_cases","Mean Waveform"]);
already_appeared = [];
idxs_that_are_already_checked = [];

if config.ON_HPC
    nn_struct = importdata(config.FP_TO_CHOOSE_BETTER_NN_ON_HPC);
else
    nn_struct = importdata(config.FP_TO_CHOOSE_BETTER_NN);
end
choose_better_nn = nn_struct.net;
for i=1:size(table_of_overlapping_clusters,1)
    current_z_score = table_of_overlapping_clusters{i,"Z Score"};
    current_cluster_num = table_of_overlapping_clusters{i,"Cluster"};
    current_tetrode = table_of_overlapping_clusters{i,"Tetrode"};

    other_appearences_dict = table_of_overlapping_clusters{i,"Other Appearence Info"}{1};

    if ismember(table_of_overlapping_clusters{i,"idx of its location in arrays"},idxs_that_are_already_checked)
        continue;
    end
    table_of_other_appearences = get_other_appearences_in_table_format(other_appearences_dict,table_of_overlapping_clusters,current_z_score,current_cluster_num,current_tetrode);


    %there are special cases where the current neuron might not have any
    %other appearences
    [already_appeared,table_of_best_representation,was_added] = check_for_previous_appearence(table_of_other_appearences,already_appeared,table_of_best_representation,i,table_of_overlapping_clusters);
    if was_added
        continue;
    end


    best_rep = find_best_rep(table_of_other_appearences,config,choose_better_nn);

    %if there are multiple rows with the same highest SNR then you simply
    %choose the first
    if size(best_rep,1) > 1
        best_rep = best_rep(1);
    end

    %ensure that no other clusters that this cluster overlaps with has
    %already been represented elsewhere, if so it cannot be added again
    %this should remove the repeat of clusters in the case of auxilary
    %clusters
    if i==1
        already_appeared = table_of_other_appearences{:,"Tetrode"}+" "+table_of_other_appearences{:,"Z Score"}+" "+table_of_other_appearences{:,"Cluster"};
        table_of_best_representation(i,:) = table_of_other_appearences(best_rep,:);
        table_of_best_representation{i,"absorbed_cases"} = {table_of_other_appearences};
    else
       [already_appeared,run_continue,table_of_best_representation] =add_to_table_of_best_representation(already_appeared,table_of_other_appearences,timestamp_array,best_rep,min_overlap_percentage,table_of_best_representation,i,table_of_overlapping_clusters,config);

       if run_continue
           continue;
       end
    end

    absorbed_cases_table = table_of_best_representation{i,"absorbed_cases"}{1};
    og_index_of_absorbed_table = absorbed_cases_table{:,"idx of its location in arrays"};
    idxs_that_are_already_checked = [idxs_that_are_already_checked;table_of_best_representation{i,"idx of its location in arrays"};og_index_of_absorbed_table];


    disp("Finished "+string(i)+"/"+string(size(table_of_overlapping_clusters,1)));

end

table_of_best_representation(isnan(table_of_best_representation{:,"Cluster"}),:) = [];
%now only return the unique versions
% table_of_best_representation = unique(table_of_best_representation,"stable",'rows');




table_of_best_representation = join(table_of_best_representation,table_of_overlapping_clusters,"Keys",["Tetrode","Z Score","Cluster","idx of its location in arrays"],"LeftVariables",setdiff(table_of_best_representation.Properties.VariableNames,"grades",'stable'));



end