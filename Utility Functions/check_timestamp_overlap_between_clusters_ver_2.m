function [table_of_other_appearences] = check_timestamp_overlap_between_clusters_ver_2(table_of_neurons,timestamps_cluster_data,min_overlap_percentage)
%this function uses timestamps of clusters across various configurations
%(ie different tetrodes with the same/different z_scores as we all the same
%tetrode with different z_score, it helps to think of this as vertical and
%horizontal checking
%table_of_neurons is a table of clusters which have been id'd as neurons by
%previous step
%now we can check which of the neurons are identified are repeitions of
%each other



table_of_other_appearences = table(nan(size(table_of_neurons,1),1),nan(size(table_of_neurons,1),1),repelem("",size(table_of_neurons,1),1),repelem("",size(table_of_neurons,1),1),repelem("",size(table_of_neurons,1),1),'VariableNames',["Z Score","Cluster #","Overlap %","Other Appearences","Tetrode"]);
iter_count = 1;
for current_neuron_counter=1:size(table_of_neurons,1)
    current_neuron_tetrode = table_of_neurons{current_neuron_counter,2};
    current_neuron_tetrode_number = str2double(strrep(current_neuron_tetrode,"t",""));
    current_neuron_z_score = table_of_neurons{current_neuron_counter,4};
    %current_neuron_idx =  idx_cluster_data{current_neuron_counter};
    current_neuron_ts = timestamps_cluster_data{current_neuron_counter};
    %current_neuron_grades = grades_cluster_data{current_neuron_counter};
    current_neuron_cluster_number = table_of_neurons{current_neuron_counter,3};

    other_appearences_of_this_cluster = "";
    overlap_percentages_of_this_cluster = "";
    other_tetrodes_where_cluster_appears = "";

    for compare_neuron_counter=1:size(table_of_neurons,1)
        if current_neuron_counter == compare_neuron_counter
            iter_count = iter_count+1;
            continue
            
        end
        compare_neuron_tetrode = table_of_neurons{compare_neuron_counter,2};
        compare_neuron_tetrode_number = str2double(strrep(compare_neuron_tetrode,"t",""));
        compare_neuron_z_score = table_of_neurons{compare_neuron_counter,4};
        %compare_neuron_idx =  idx_cluster_data{compare_neuron_counter};
        compare_neuron_ts = timestamps_cluster_data{compare_neuron_counter};
        %compare_neuron_grades = grades_cluster_data{compare_neuron_counter};
        compare_neuron_cluster = table_of_neurons{compare_neuron_counter,3};

        %to avoid excess calculations we will skip any tetrodes that
        %are unlikely to produce a viable comparison (i.e. there's no
        %reason to compare a cluster found on t1 to a cluster found on t50
        %cause they're so distant, I'll set the range to 15 before and
        %after the current tetrode number but even this might be excessive
        if abs(compare_neuron_tetrode_number -current_neuron_tetrode_number) > 15
            iter_count = iter_count+1;
            continue;
        end

        smaller_cluster_size = min(length(compare_neuron_ts),length(current_neuron_ts));
        number_of_timestamps_in_common = length(intersect(current_neuron_ts,compare_neuron_ts));

        actual_overlap_percentage = (number_of_timestamps_in_common / smaller_cluster_size) * 100;

        if actual_overlap_percentage > min_overlap_percentage
            if other_appearences_of_this_cluster==""
                other_appearences_of_this_cluster =other_appearences_of_this_cluster+"Z_Score:"+string(compare_neuron_z_score)+" Cluster "+string(compare_neuron_cluster);
                overlap_percentages_of_this_cluster = overlap_percentages_of_this_cluster+actual_overlap_percentage+"%";
                other_tetrodes_where_cluster_appears = other_tetrodes_where_cluster_appears +compare_neuron_tetrode;
            else
                other_appearences_of_this_cluster =other_appearences_of_this_cluster+"|Z_Score:"+string(compare_neuron_z_score)+" Cluster "+string(compare_neuron_cluster);
                overlap_percentages_of_this_cluster = overlap_percentages_of_this_cluster+"|"+actual_overlap_percentage+"%";
                other_tetrodes_where_cluster_appears = other_tetrodes_where_cluster_appears +"|"+ compare_neuron_tetrode;
            end
        end
        disp(string(current_neuron_counter)+" Finished "+string(iter_count)+"/"+string(size(table_of_neurons,1)*size(table_of_neurons,1)))
        iter_count = iter_count+1;
    end
    %,'VariableNames',["Z Score","Cluster #","Overlap %","Other Appearences","Tetrode"]);
    table_of_other_appearences{current_neuron_counter,1} = current_neuron_z_score;
    table_of_other_appearences{current_neuron_counter,2} = current_neuron_cluster_number;
    table_of_other_appearences{current_neuron_counter,3} = overlap_percentages_of_this_cluster;
    table_of_other_appearences{current_neuron_counter,4} = other_appearences_of_this_cluster ;
    table_of_other_appearences{current_neuron_counter,5} = other_tetrodes_where_cluster_appears ;
    
    
end


end

