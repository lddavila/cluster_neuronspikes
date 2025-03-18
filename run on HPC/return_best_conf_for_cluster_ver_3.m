function [table_of_best_representation,unit_appearences] = return_best_conf_for_cluster_ver_3(table_of_overlapping_clusters,timestamp_array,min_overlap_percentage,min_unit_appearence_threshold)
    function [table_of_other_appearences] = get_other_appearences_in_table_format(other_appearences_dict,table_of_overlapping_clusters,current_z_score,current_cluster_class,current_cluster_num,current_tetrode)
        % oth_app_overlap_perc = ["100%",other_appearences_dict("overlap percentages of other appearences")].';
        % oth_app_class = [current_cluster_class,other_appearences_dict("classification of other appearences")].';
        oth_app_clust_num = str2double([current_cluster_num,other_appearences_dict("cluster number of other appearences")].');
        oth_app_tetr = [current_tetrode,other_appearences_dict("tetrodes of other appearences")].';
        oth_app_z_sc = str2double([current_z_score, other_appearences_dict("Z score of other appearences")].');

        oth_app_clust_num(isnan(oth_app_clust_num)) = [];
        oth_app_z_sc(isnan(oth_app_z_sc)) = [];
        

        only_grades_col = table_of_overlapping_clusters(:,["Z Score","Tetrode","Cluster","grades","idx of its location in arrays"]);
        only_idx_col = table_of_overlapping_clusters(:,["Z Score","Tetrode","Cluster","idx of its location in arrays"]);

        %join the grades of all current appearences
        table_of_other_appearences = table(oth_app_z_sc,oth_app_tetr,oth_app_clust_num,'VariableNames',["Z Score","Tetrode","Cluster"]);

        table_of_other_appearences_grades = join(table_of_other_appearences,only_grades_col,"Keys",["Z Score","Tetrode","Cluster"]);
        table_of_other_appearence_idxs = join(table_of_other_appearences,only_idx_col,"Keys",["Z Score","Tetrode","Cluster"]);
        grades_array = cell2mat(table_of_other_appearences_grades{:,"grades"});
        snr = grades_array(:,40);
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


table_of_best_representation = table(nan(10000,1),repelem("",10000,1),nan(10000,1),nan(10000,1),nan(10000,1),'VariableNames',["Z Score","Tetrode","Cluster","SNR","idx of its location in arrays"]);
already_appeared = [];
for i=1:size(table_of_overlapping_clusters,1)
    current_z_score = table_of_overlapping_clusters{i,"Z Score"};
    current_cluster_num = table_of_overlapping_clusters{i,"Cluster"};
    current_tetrode = table_of_overlapping_clusters{i,"Tetrode"};
    current_cluster_class = table_of_overlapping_clusters{i,"Classification"};

    other_appearences_dict = table_of_overlapping_clusters{i,"Other Appearence Info"}{1};

    table_of_other_appearences = get_other_appearences_in_table_format(other_appearences_dict,table_of_overlapping_clusters,current_z_score,current_cluster_class,current_cluster_num,current_tetrode);


    %there are special cases where the current neuron might not have any
    %other appearences
    [already_appeared,table_of_best_representation,was_added] = check_for_previous_appearence(table_of_other_appearences,already_appeared,table_of_best_representation,i,table_of_overlapping_clusters);
    if was_added
        continue;
    end

    

    %pick the row with the best(highest) signal to noise ratio (AKA grade 40)
    %row_with_higest_snr = find(max(:))

    [best_rep,~] = find(table_of_other_appearences.SNR ==max(table_of_other_appearences.SNR));

    %if there are multiple rows with the same highest SNR then you simply
    %choose the first
    if size(best_rep,1) > 1
        best_rep = best_rep(1);
    end

    %ensure that no other clusters that this cluster overlaps with has
    %already been represented elsewhere, if so it cannot be added again
    %this should remove the repeat of clusters in the case of auxilary
    %clusters
    % if (table_of_other_appearences{best_rep,"Tetrode"} == "t107" && table_of_other_appearences{best_rep,"Z Score"}==9 && table_of_other_appearences{best_rep,"Cluster"}==3) || (table_of_other_appearences{best_rep,"Tetrode"} == "t104" && table_of_other_appearences{best_rep,"Z Score"}==9 && table_of_other_appearences{best_rep,"Cluster"}==3)
    %     disp("something")
    % end
    if i==1
        already_appeared = table_of_other_appearences{:,"Tetrode"}+" "+table_of_other_appearences{:,"Z Score"}+" "+table_of_other_appearences{:,"Cluster"};
        table_of_best_representation{i,:} = table_of_other_appearences{best_rep,:};
    else
        %check to ensure that this cluster hasn't already appeared on
        %another cluster's best appearences list
        %this ensures that there's no duplicates (multiple clusters
        %representing the same unit
        to_be_added = table_of_other_appearences{best_rep,"Tetrode"}+" "+table_of_other_appearences{best_rep,"Z Score"}+" "+table_of_other_appearences{best_rep,"Cluster"};
        if ismember(to_be_added,already_appeared)
            %if to_be_added is already a member of the
            %already_appeared_list then we take all of its other
            %appearences and union that with the already_appeared list
            %this ensures the elimination of auxilary clusters
            already_appeared = union(already_appeared,table_of_other_appearences{:,"Tetrode"}+" "+table_of_other_appearences{:,"Z Score"}+" "+table_of_other_appearences{:,"Cluster"});
            disp("Finished "+string(i)+"/"+string(size(table_of_overlapping_clusters,1)));
            continue;
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
            already_appeared = union(already_appeared,table_of_other_appearences{:,"Tetrode"}+" "+table_of_other_appearences{:,"Z Score"}+" "+table_of_other_appearences{:,"Cluster"});
        end

    end



    disp("Finished "+string(i)+"/"+string(size(table_of_overlapping_clusters,1)));

end

table_of_best_representation(isnan(table_of_best_representation{:,"Cluster"}),:) = [];
%now only return the unique versions
table_of_best_representation = unique(table_of_best_representation,"stable",'rows');



%remove any rows that have a negative snr
% table_of_best_representation(table_of_best_representation{:,"SNR"}<=0,:) = [];

%perform a final combination pass in an effort to reduce number of
%repititons
% for i=1:size(table_of_best_representation,1)
%     current_ts = timestamp_array{table_of_best_representation{i,"idx of its location in arrays"}};
%     for j=1:size(table_of_best_representation,1)
%         if i==j
%             continue;
%         end
%         compare_ts = timestamp_array{table_of_best_representation{j,"idx of its location in arrays"}};
%         if length(compare_ts) < length(current_ts)
%             num_tp = get_tp_count_given_a_tdelta_hpc(compare_ts,current_ts,0.004);
%             overlap_perc = num_tp / length(compare_ts);
%         elseif length(compare_ts) > length(current_ts)
%             num_tp = get_tp_count_given_a_tdelta_hpc(current_ts,compare_ts,0.0004);
%             overlap_perc = num_tp / length(current_ts);
%         else
%             num_tp = get_tp_count_given_a_tdelta_hpc(compare_ts,current_ts,0.004);
%             overlap_perc = num_tp / length(current_ts);
%         end
%         if overlap_perc > min_overlap_percentage
%             snr_of_compare = table_of_best_representation{j,"SNR"};
%             snr_of_current = table_of_best_representation{i,"SNR"};
%             if snr_of_compare > snr_of_current
%                 table_of_best_representation(i,:) = [];
%             elseif snr_of_compare < snr_of_current
%                 table_of_best_representation(j,:) = [];
%             else
%                 table_of_best_representation(j,:) = [];
%             end
%         end
%     end
%     disp("Finished"+string(i)+"/"+string(size(table_of_best_representation,1)));
% end

table_of_best_representation = join(table_of_best_representation,table_of_overlapping_clusters,"Keys",["Tetrode","Z Score","Cluster"]);

unit_appearences = groupcounts(table_of_best_representation(table_of_best_representation{:,"Max Overlap % With Unit"} >=min_unit_appearence_threshold,:),"Max Overlap Unit");
% units_not_identified = unit_appearences(unit_appearences{:,"GroupCount"}==0,"Max Overlap Unit");
% disp("Number of FN:")

end