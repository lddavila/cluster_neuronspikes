function [table_of_other_appearences] = check_timestamp_overlap_between_clusters_hpc(table_of_neurons,timestamps_cluster_data,min_overlap_percentage,time_delta)
%this function uses timestamps of clusters across various configurations
%(ie different tetrodes with the same/different z_scores as we all the same
%tetrode with different z_score, it helps to think of this as vertical and
%horizontal checking
%table_of_neurons is a table of clusters which have been id'd as neurons by
%previous step
%now we can check which of the neurons are identified are repeitions of
%each other
%allows time delta


% check_timestamp_overlap_between_clusters_ver_3
table_of_other_appearences = table(nan(size(table_of_neurons,1),1),nan(size(table_of_neurons,1),1),repelem("",size(table_of_neurons,1),1),repelem("",size(table_of_neurons,1),1),repelem("",size(table_of_neurons,1),1),'VariableNames',["Z Score","Cluster #","Overlap %","Other Appearences","Tetrode"]);

number_of_rows_in_table_of_neurons = size(table_of_neurons,1);
cell_array_of_z_scores = cell(1,number_of_rows_in_table_of_neurons);
cell_array_of_cluster_number = cell(1,number_of_rows_in_table_of_neurons);
cell_array_of_overlap_percentage = cell(1,number_of_rows_in_table_of_neurons);
cell_array_of_other_appearences = cell(1,number_of_rows_in_table_of_neurons);
cell_array_of_other_tetrodes = cell(1,number_of_rows_in_table_of_neurons);

%slice the table of neurons to avoid overhead in parallelization
cell_array_of_table_of_neurons = cell(1,number_of_rows_in_table_of_neurons);
for i=1:length(cell_array_of_table_of_neurons)
    cell_array_of_table_of_neurons{i} = table_of_neurons(i,:);
end


parfor current_neuron_counter=1:number_of_rows_in_table_of_neurons
    current_data = cell_array_of_table_of_neurons{current_neuron_counter};
    current_neuron_tetrode = current_data{1,"Tetrode"};
    current_neuron_tetrode_number = str2double(strrep(current_neuron_tetrode,"t",""));
    current_neuron_z_score = current_data{1,"Z Score"};
    current_neuron_ts = timestamps_cluster_data{current_neuron_counter};
    current_neuron_cluster_number = current_data{1,"Cluster"};

    other_appearences_of_this_cluster = "";
    overlap_percentages_of_this_cluster = "";
    other_tetrodes_where_cluster_appears = "";

    for compare_neuron_counter=1:size(table_of_neurons,1)
        if current_neuron_counter == compare_neuron_counter
            % iter_count = iter_count+1;
            continue
        end
        compare_data = cell_array_of_table_of_neurons{compare_neuron_counter};
        compare_neuron_tetrode = compare_data{1,"Tetrode"};
        compare_neuron_tetrode_number = str2double(strrep(compare_neuron_tetrode,"t",""));
        compare_neuron_z_score = compare_data{1,"Z Score"};
        compare_neuron_ts = timestamps_cluster_data{compare_neuron_counter};
        compare_neuron_cluster = compare_data{1,"Cluster"};

        %to avoid excess calculations we will skip any tetrodes that
        %are unlikely to produce a viable comparison (i.e. there's no
        %reason to compare a cluster found on t1 to a cluster found on t50
        %cause they're so distant, I'll set the range to 15 before and
        %after the current tetrode number but even this might be excessive
        if abs(compare_neuron_tetrode_number -current_neuron_tetrode_number) > 10
            % iter_count = iter_count+1;
            continue;
        end

        larger_cluster_size = max(length(compare_neuron_ts),length(current_neuron_ts));


        number_of_timestamps_in_common = find_number_of_true_positives_given_a_time_delta_hpc(current_neuron_ts,compare_neuron_ts,time_delta);

        actual_overlap_percentage = (number_of_timestamps_in_common / larger_cluster_size) * 100;

        if actual_overlap_percentage > min_overlap_percentage
            other_appearences_of_this_cluster =other_appearences_of_this_cluster+"|Z_Score:"+string(compare_neuron_z_score)+" Cluster "+string(compare_neuron_cluster);
            overlap_percentages_of_this_cluster = overlap_percentages_of_this_cluster+"|"+actual_overlap_percentage+"%";
            other_tetrodes_where_cluster_appears = other_tetrodes_where_cluster_appears +"|"+ compare_neuron_tetrode;
        end
    end
    % remove the leading | from each of the strings 
    other_appearences_of_this_cluster = regexprep(other_appearences_of_this_cluster,'^|','');
    overlap_percentages_of_this_cluster = regexprep(overlap_percentages_of_this_cluster,"^|",'');
    other_tetrodes_where_cluster_appears = regexprep(other_tetrodes_where_cluster_appears,"^|",'');
    %,'VariableNames',["Z Score","Cluster #","Overlap %","Other Appearences","Tetrode"]);
    cell_array_of_z_scores{current_neuron_counter} = current_neuron_z_score;
    cell_array_of_cluster_number{current_neuron_counter} = current_neuron_cluster_number;
    cell_array_of_overlap_percentage{current_neuron_counter} = overlap_percentages_of_this_cluster;
    cell_array_of_other_appearences{current_neuron_counter} = other_appearences_of_this_cluster ;
    cell_array_of_other_tetrodes{current_neuron_counter} = other_tetrodes_where_cluster_appears ;

    disp("check_timestamp_overlap_between_clusters_hpc.m Finished Neuron "+string(current_neuron_counter)+"/"+string(number_of_rows_in_table_of_neurons))

end


for current_neuron_counter=1:number_of_rows_in_table_of_neurons
    table_of_other_appearences{current_neuron_counter,1} =cell_array_of_z_scores{current_neuron_counter};
    table_of_other_appearences{current_neuron_counter,2} = cell_array_of_cluster_number{current_neuron_counter};
    table_of_other_appearences{current_neuron_counter,3} = cell_array_of_overlap_percentage{current_neuron_counter};
    table_of_other_appearences{current_neuron_counter,4} = cell_array_of_other_appearences{current_neuron_counter} ;
    table_of_other_appearences{current_neuron_counter,5} = cell_array_of_other_tetrodes{current_neuron_counter} ;
end
end

