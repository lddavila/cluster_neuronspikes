function  [grades_array,outputs_array,aligned_array,timestamp_array,idx_array] = get_data_of_neurons_identified_as_clusters_hpc(table_of_only_neurons,generic_dir_with_grades,generic_dir_with_outputs,refined_pass)
grades_array = cell(1,size(table_of_only_neurons,1));
outputs_array = cell(1,size(table_of_only_neurons,1));
aligned_array = cell(1,size(table_of_only_neurons,1));
timestamp_array = cell(1,size(table_of_only_neurons,1));
idx_array = cell(1,size(table_of_only_neurons,1));
disp("Beginning get_data_of_neurons_identified_as_clusters")

%slice the table
table_of_only_neurons_in_cell_format = cell(1,size(table_of_only_neurons,1));
for i=1:size(table_of_only_neurons,1)
    table_of_only_neurons_in_cell_format{i} = table_of_only_neurons(i,:);
end
% parpool("Threads",6)
number_of_data_to_load = length(table_of_only_neurons_in_cell_format);
parfor i=1:size(table_of_only_neurons,1)
    current_data = table_of_only_neurons_in_cell_format{i};
    current_tetrode = current_data{1,"Tetrode"};
    current_z_score = current_data{1,"Z Score"};
    current_cluster = current_data{1,"Cluster"};

    if refined_pass
        dir_with_outputs = generic_dir_with_outputs;
        dir_with_grades = generic_dir_with_grades;
    else
        dir_with_grades = generic_dir_with_grades + " "+string(current_z_score) + " grades";
        dir_with_outputs = generic_dir_with_outputs +string(current_z_score);
    end
    [grades_data,outputs_data,aligned_data,timestamp_data,idx_data] = import_data_hpc(dir_with_grades,dir_with_outputs,current_tetrode,refined_pass);
    if isnan(grades_data)
        grades_array{i}=nan;
        idx_array{i} = nan;
        outputs_array{i}= nan;
        aligned_array{i} = nan;
        timestamp_array{i} = nan;
    end
    grades_array{i}=grades_data(current_cluster,:);
    idx_array{i} = idx_data{current_cluster};
    outputs_array{i}= outputs_data(idx_array{i});
    aligned_array{i} = aligned_data(:,idx_array{i},:);
    timestamp_array{i} = timestamp_data(idx_array{i});

    disp("get_data_of_neurons_identified_as_clusters_hpc.m "+string(i) + "/"+string(number_of_data_to_load))
end


disp("Finished get_data_of_neurons_identified_as_clusters Finished");
end