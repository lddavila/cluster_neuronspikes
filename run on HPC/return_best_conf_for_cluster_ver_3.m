function [table_of_best_representation] = return_best_conf_for_cluster_ver_3(table_of_overlapping_clusters,timestamp_array,min_overlap_percentage,config)
    function [table_of_other_appearences] = get_other_appearences_in_table_format(other_appearences_dict,table_of_overlapping_clusters,current_z_score,current_cluster_num,current_tetrode)
        % oth_app_overlap_perc = ["100%",other_appearences_dict("overlap percentages of other appearences")].';
        % oth_app_class = [current_cluster_class,other_appearences_dict("classification of other appearences")].';
        oth_app_clust_num = str2double([current_cluster_num,other_appearences_dict("cluster number of other appearences")].');
        oth_app_tetr = [current_tetrode,other_appearences_dict("tetrodes of other appearences")].';
        oth_app_z_sc = str2double([current_z_score, other_appearences_dict("Z score of other appearences")].');

        oth_app_clust_num(isnan(oth_app_clust_num)) = [];
        oth_app_z_sc(isnan(oth_app_z_sc)) = [];
        

        if ismissing(oth_app_tetr)
            print("something's wrong")
        end

        % if ismissing(oth)
        % elseif ismissing()
        % elseif ismissing()
        % end
        only_grades_col = table_of_overlapping_clusters(:,["Z Score","Tetrode","Cluster","grades","idx of its location in arrays"]);
        only_idx_col = table_of_overlapping_clusters(:,["Z Score","Tetrode","Cluster","idx of its location in arrays"]);

        %join the grades of all current appearences
        table_of_other_appearences = table(oth_app_z_sc,oth_app_tetr,oth_app_clust_num,'VariableNames',["Z Score","Tetrode","Cluster"]);

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
                    table_of_best_representation{i,:} = table_of_other_appearences{1,:};
                    was_added=true;
                end
            else %if the already appeared list is empty then we can automatically add this cluster to the already appeared list as it is the first and best appearence of this particular cluster
                disp("Finished "+string(i)+"/"+string(size(table_of_overlapping_clusters,1)));
                table_of_best_representation{i,:} = table_of_other_appearences{1,:};
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
                table_of_best_representation{i,:} = table_of_other_appearences{best_rep,:};
            end
            %indexes_of_to_be_added_to_add = run_tests_for_to_be_added(timestamp_array,config,table_of_overlapping_clusters,table_of_best_representation,table_of_other_appearences);
            already_appeared = union(already_appeared,to_be_added);
        end
    end

    function [best_rep] = find_best_rep(table_of_other_appearences,config)
        best_rep = NaN;
        %to find best rep we must select the lowest possible z score where
        %the minimum improvement threshold is met using SNR
        % for example if a cluster appears with z-score [1,2,3,4,5]
        %and if each of these clusters appear with SNR [0.3 0.5 0.7 0.71 0.72]
        %then we will see that the minimum improvement threshold is met
        %when the z score is 3 (ie SNR is 0.7)
        %this is because the SNR is not improving enough to justify
        %increasing the z score
        %We always the lowest possible z-score because it will preserve the
        %most spikes
        %obviously a higher z-score produces higher quality clusters, but
        %you also risk losing spikes

        %the first thing we must do is organize the
        %table_of_other_appearences by their SNR
        sorted_table_of_other_appearences = sortrows(table_of_other_appearences,["Z Score","SNR"],"ascend");

        same_z_score_different_tetr = false;
        %now we will find the first minimum improvement threshold
        current_row_counter = 1;
        while current_row_counter <=size(sorted_table_of_other_appearences,1)-1
            curr_z_sc = sorted_table_of_other_appearences{current_row_counter,"Z Score"};
            next_row_z_score = sorted_table_of_other_appearences{current_row_counter+1,"Z Score"};

            if curr_z_sc==next_row_z_score %if z scores are the same between rows then keep the max SNR between them
                same_z_score_different_tetr = true;
                current_SNR = max(sorted_table_of_other_appearences{current_row_counter,"SNR"},sorted_table_of_other_appearences{current_row_counter+1,"SNR"});
                current_row_counter = current_row_counter+1;
                continue;
            end

            if same_z_score_different_tetr %if this flag has been set then we need to check if the next row is still the same z score 
                if curr_z_sc == next_row_z_score %if the next row STILL has the same z score then we take the max SNR between the last found max SNR and the next SNR
                    same_z_score_different_tetr = true;
                    current_SNR = max(current_SNR,sorted_table_of_other_appearences{current_row_counter+1,"SNR"});
                    current_row_counter = current_row_counter+1;
                    continue;
                else %when the next row is not the same z score then we proceed as we normally do
                    next_row_SNR = sorted_table_of_other_appearences{current_row_counter+1,"SNR"};
                    diff_in_SNR = next_row_SNR-current_SNR; % we do abs in the case of slight flunctuations
                    same_z_score_different_tetr = false;
                end
            else
                current_SNR = sorted_table_of_other_appearences{current_row_counter,"SNR"};
                next_row_SNR = sorted_table_of_other_appearences{current_row_counter+1,"SNR"};
                diff_in_SNR = next_row_SNR-current_SNR; % we do abs in the case of slight flunctuations
            end
            %in the case of different tetrodes with the same z score we
            %will simply choose whichever configuration has the highest SNR
            % and compare its snr to the next highest z score
            %for example if we have
            % Tetrodes: [t1 t2 t3 t4]
            % Z Score:  [1 1 1 3]
            % SNR:      [0.1 0.2 0.3 0.8]
            %then we will only compare 0.3 to 0.8 not 0.1 to 0.2 or 0.2 to 0.3
            
            if diff_in_SNR < config.MIN_IMPROV_THRESH && diff_in_SNR >0 %we add the greater than 0 condition to ensure that drops are not counted
                row_with_best = sorted_table_of_other_appearences(current_row_counter,:);
                c1 = row_with_best{:,"SNR"} == table_of_other_appearences{:,"SNR"};
                c2 = row_with_best{:,"Tetrode"} == table_of_other_appearences{:,"Tetrode"};
                c3 = row_with_best{:,"Z Score"}== table_of_other_appearences{:,"Z Score"};
                c4 = row_with_best{:,"Cluster"} == table_of_other_appearences{:,"Cluster"};
                best_rep = find(c1 & c2 & c3 & c4);
                break;
            end
            current_row_counter = current_row_counter+1;
        end

        %if it never meets the min improvement threshold then we will just
        %take the highest one by default
        
        if isnan(best_rep)
            best_rep = find(table_of_other_appearences{:,"SNR"}==max(table_of_other_appearences{:,"SNR"}));
        end


    end
table_of_best_representation = table(nan(10000,1),repelem("",10000,1),nan(10000,1),nan(10000,1),nan(10000,1),'VariableNames',["Z Score","Tetrode","Cluster","SNR","idx of its location in arrays"]);
already_appeared = [];
for i=1:size(table_of_overlapping_clusters,1)
    current_z_score = table_of_overlapping_clusters{i,"Z Score"};
    current_cluster_num = table_of_overlapping_clusters{i,"Cluster"};
    current_tetrode = table_of_overlapping_clusters{i,"Tetrode"};

    other_appearences_dict = table_of_overlapping_clusters{i,"Other Appearence Info"}{1};

    table_of_other_appearences = get_other_appearences_in_table_format(other_appearences_dict,table_of_overlapping_clusters,current_z_score,current_cluster_num,current_tetrode);


    %there are special cases where the current neuron might not have any
    %other appearences
    [already_appeared,table_of_best_representation,was_added] = check_for_previous_appearence(table_of_other_appearences,already_appeared,table_of_best_representation,i,table_of_overlapping_clusters);
    if was_added
        continue;
    end

    

    %pick the row with the best(highest) signal to noise ratio (AKA grade 40)
    %row_with_higest_snr = find(max(:))

    % [best_rep,~] = find(table_of_other_appearences.SNR ==max(table_of_other_appearences.SNR));

    best_rep = find_best_rep(table_of_other_appearences,config);

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
        table_of_best_representation{i,:} = table_of_other_appearences{best_rep,:};
    else
       [already_appeared,run_continue,table_of_best_representation] =add_to_table_of_best_representation(already_appeared,table_of_other_appearences,timestamp_array,best_rep,min_overlap_percentage,table_of_best_representation,i,table_of_overlapping_clusters,config);

       if run_continue
           continue;
       end
    end



    disp("Finished "+string(i)+"/"+string(size(table_of_overlapping_clusters,1)));

end

table_of_best_representation(isnan(table_of_best_representation{:,"Cluster"}),:) = [];
%now only return the unique versions
table_of_best_representation = unique(table_of_best_representation,"stable",'rows');



%remove any rows that have a negative snr
% table_of_best_representation(table_of_best_representation{:,"SNR"}<=0,:) = [];

table_of_best_representation = join(table_of_best_representation,table_of_overlapping_clusters,"Keys",["Tetrode","Z Score","Cluster"]);

% unit_appearences = groupcounts(table_of_best_representation(table_of_best_representation{:,"Max Overlap % With Unit"} >=min_unit_appearence_threshold,:),"Max Overlap Unit");
% units_not_identified = unit_appearences(unit_appearences{:,"GroupCount"}==0,"Max Overlap Unit");
% disp("Number of FN:")

end