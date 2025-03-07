function [table_of_other_appearences] = check_timestamp_overlap_between_clusters_hpc_ver_3(table_of_all_clusters,timestamps_cluster_data,min_overlap_percentage,time_delta)
tic
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


number_of_rows_in_table_of_neurons = size(table_of_all_clusters,1);
table_of_other_appearences = table(nan(number_of_rows_in_table_of_neurons,1),nan(number_of_rows_in_table_of_neurons,1),cell(number_of_rows_in_table_of_neurons,1),cell(number_of_rows_in_table_of_neurons,1),cell(number_of_rows_in_table_of_neurons,1),'VariableNames',["Tetrode","Cluster #","Z Score","Other Appearence Info","Classification"]);
% cell_array_of_z_scores = cell(1,number_of_rows_in_table_of_neurons);
% cell_array_of_cluster_number = cell(1,number_of_rows_in_table_of_neurons);
% cell_array_of_overlap_percentage = cell(1,number_of_rows_in_table_of_neurons);
% cell_array_of_other_appearences = cell(1,number_of_rows_in_table_of_neurons);
% cell_array_of_other_tetrodes = cell(1,number_of_rows_in_table_of_neurons);

%slice the table of neurons to avoid overhead in parallelization
cell_array_of_table_of_neurons = cell(1,number_of_rows_in_table_of_neurons);
for i=1:length(cell_array_of_table_of_neurons)
    cell_array_of_table_of_neurons{i} = table_of_all_clusters(i,:);
end



for current_neuron_counter=1:number_of_rows_in_table_of_neurons
    current_data = cell_array_of_table_of_neurons{current_neuron_counter};
    current_neuron_tetrode = current_data{1,"Tetrode"};
    current_neuron_tetrode_number = str2double(strrep(current_neuron_tetrode,"t",""));
    current_neuron_z_score = current_data{1,"Z Score"};
    current_neuron_ts = timestamps_cluster_data{current_neuron_counter};
    current_neuron_cluster_number = current_data{1,"Cluster"};
    current_neuron_classification = current_data{1,"Classification"};

    % other_appearences_of_this_cluster = repelem("",1,number_of_rows_in_table_of_neurons);
    overlap_percentages_of_this_cluster = repelem("",1,number_of_rows_in_table_of_neurons);
    other_tetrodes_where_cluster_appears = repelem("",1,number_of_rows_in_table_of_neurons);
    other_z_scores_of_this_cluster = repelem("",1,number_of_rows_in_table_of_neurons);
    other_cluster_numbers_of_this_cluster= repelem("",1,number_of_rows_in_table_of_neurons);
    classification_of_other_appearences = repelem("",1,number_of_rows_in_table_of_neurons);

    for compare_neuron_counter=1:number_of_rows_in_table_of_neurons
        %disp(string(current_neuron_counter)+" "+string(compare_neuron_counter))
        if current_neuron_counter == compare_neuron_counter
            % iter_count = iter_count+1;
            continue
        end
        compare_data = cell_array_of_table_of_neurons{compare_neuron_counter};
        compare_neuron_tetrode = compare_data{1,"Tetrode"};
        compare_neuron_tetrode_number = str2double(strrep(compare_neuron_tetrode,"t",""));
        compare_neuron_z_score = compare_data{1,"Z Score"};
        current_compare_neuron_ts = timestamps_cluster_data{compare_neuron_counter};
        compare_neuron_cluster = compare_data{1,"Cluster"};
        compare_neuron_classification = compare_data{1,"Classification"};

        %to avoid excess calculations we will skip any tetrodes that
        %are unlikely to produce a viable comparison (i.e. there's no
        %reason to compare a cluster found on t1 to a cluster found on t50
        %cause they're so distant, I'll set the range to 10 before and
        %after the current tetrode number but even this might be excessive
        if abs(compare_neuron_tetrode_number -current_neuron_tetrode_number) > 6
            % iter_count = iter_count+1;
            continue;
        end


        [~,index_of_larger ]= max([length(current_compare_neuron_ts),length(current_neuron_ts)]);
        [smaller_cluster_size,~ ]= min([length(current_compare_neuron_ts),length(current_neuron_ts)]);
        if index_of_larger==1
            %if the larger cluster is the compare neuron then we use the ts
            %of the current neuron as our compare
            number_of_timestamps_in_common = find_number_of_true_positives_given_a_time_delta_hpc(current_neuron_ts,current_compare_neuron_ts,time_delta);
        elseif index_of_larger==2
            %if the larger cluster is the current_neuron then we use the ts
            %of the compare neuron as our compare
            %the logic behind this is that the first set of ts that are put
            %into the function will never be over counted 
            number_of_timestamps_in_common = find_number_of_true_positives_given_a_time_delta_hpc(current_compare_neuron_ts,current_neuron_ts,time_delta);
        else
            number_of_timestamps_in_common=0;
        end

        

        actual_overlap_percentage = (number_of_timestamps_in_common / smaller_cluster_size) * 100;
        % disp(actual_overlap_percentage)
        if actual_overlap_percentage > min_overlap_percentage
            other_z_scores_of_this_cluster(compare_neuron_counter) = string(compare_neuron_z_score);
            other_cluster_numbers_of_this_cluster(compare_neuron_counter) = string(compare_neuron_cluster);
            % other_appearences_of_this_cluster(compare_neuron_counter) ="Z_Score:"+string(compare_neuron_z_score)+" Cluster "+string(compare_neuron_cluster);
            overlap_percentages_of_this_cluster(compare_neuron_counter) = string(actual_overlap_percentage)+"%";
            other_tetrodes_where_cluster_appears(compare_neuron_counter) = compare_neuron_tetrode;
            classification_of_other_appearences(compare_neuron_counter) = compare_neuron_classification;
        end
    end

    % other_appearences_of_this_cluster(other_appearences_of_this_cluster =="") = [];
    overlap_percentages_of_this_cluster(overlap_percentages_of_this_cluster=="") = [];
    other_tetrodes_where_cluster_appears(other_tetrodes_where_cluster_appears=="") = [];
    
    other_appearences_dict = containers.Map("KeyType",'char','ValueType','any');
    other_appearences_dict("cluster number of other appearences") = other_cluster_numbers_of_this_cluster;
    other_appearences_dict("tetrodes of other appearences") = other_tetrodes_where_cluster_appears;
    other_appearences_dict("overlap percentages of other appearences") = overlap_percentages_of_this_cluster;
    other_appearences_dict("Z score of other appearences") = other_z_scores_of_this_cluster;
    other_appearences_dict("classification of other appearences") = classification_of_other_appearences;

    current_row = table(current_neuron_tetrode,current_neuron_cluster_number,current_neuron_z_score,other_appearences_dict,current_neuron_classification,'VariableNames',["Tetrode","Cluster #","Z Score","Other Appearence Info","Classification"]);
    % current_row =  table(current_neuron_z_score,current_neuron_cluster_number,{overlap_percentages_of_this_cluster},{other_appearences_of_this_cluster},{other_tetrodes_where_cluster_appears},'VariableNames',["Z Score","Cluster #","Overlap %","Other Appearences","Tetrode"]);

    table_of_other_appearences(current_neuron_counter,:) = current_row;
    disp("check_timestamp_overlap_between_clusters_hpc_ver_3.m Finished Neuron "+string(current_neuron_counter)+"/"+string(number_of_rows_in_table_of_neurons))

end
toc
end
