function  [grades_array,outputs_array,aligned_array,timestamp_array,idx_array] = get_data_of_neurons_identified_as_clusters(table_of_only_neurons,generic_dir_with_grades,generic_dir_with_outputs,refined_pass)
grades_array = cell(1,size(table_of_only_neurons,1));
outputs_array = cell(1,size(table_of_only_neurons,1));
aligned_array = cell(1,size(table_of_only_neurons,1));
timestamp_array = cell(1,size(table_of_only_neurons,1));
idx_array = cell(1,size(table_of_only_neurons,1));
disp("Beginning get_data_of_neurons_identified_as_clusters")
for i=1:size(table_of_only_neurons,1)
    current_tetrode = table_of_only_neurons{i,2};
    current_z_score = table_of_only_neurons{i,4};
    current_cluster = table_of_only_neurons{i,3};
    
    if refined_pass
        dir_with_outputs = generic_dir_with_outputs;
        dir_with_grades = generic_dir_with_grades;
    else
        dir_with_grades = generic_dir_with_grades + " "+string(current_z_score) + " grades";
        dir_with_outputs = generic_dir_with_outputs +string(current_z_score);
    end
    [grades_data,outputs_data,aligned_data,timestamp_data,idx_data] = import_data(dir_with_grades,dir_with_outputs,current_tetrode);
    grades_array{i}=grades_data(current_cluster,:);
    idx_array{i} = idx_data{current_cluster};
    outputs_array{i}= outputs_data(idx_array{i});
    aligned_array{i} = aligned_data(:,idx_array{i},:);
    timestamp_array{i} = timestamp_data(idx_array{i});
    
    
end
disp("Finished get_data_of_neurons_identified_as_clusters Finished");
end