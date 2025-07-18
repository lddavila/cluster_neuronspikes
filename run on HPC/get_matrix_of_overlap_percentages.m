function [] = get_matrix_of_overlap_percentages()
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
config = spikesort_config();
if config.ON_HPC
    blind_pass_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
    parent_save_dir = config.parent_save_dir_ON_HPC;
else
    blind_pass_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
    parent_save_dir = config.parent_save_dir;
end
disp("Finished importing data")
dir_to_save_results_to = fullfile(parent_save_dir,config.DIR_TO_SAVE_RESULTS_TO);
if ~exist(dir_to_save_results_to,"dir")
    dir_to_save_results_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_results_to);
end
row_names = strcat("Z Score:",string(blind_pass_table{:,"Z Score"})," ",blind_pass_table{:,"Tetrode"}," ",string(blind_pass_table{:,"Cluster"}));
col_names = row_names;
matrix_of_overlap_percentages =nan(size(blind_pass_table,1),size(blind_pass_table,1)) ;

[row, col] = find(tril(true(size(matrix_of_overlap_percentages)), -1));

lower_triangular_indexes = slice_table_for_parallel_processing([row,col],[]);
array_of_lower_triangular_overlap_percentages = cell(size(lower_triangular_indexes,1),1);


%slice the table of neurons in a way that the 2 being compared are in a single location of the cell array
sliced_table = cell(size(row,1),1);
for i=1:size(row,1)
    current_row_and_col = lower_triangular_indexes{i};
    current_row = current_row_and_col(1);
    current_col = current_row_and_col(2);
    sliced_table{i} = [blind_pass_table(current_row,:);blind_pass_table(current_col,:)];
    print_status_iter_message("get_matrix_of_overlap_percentages.m: slicing table",i,size(row,1));

end
cd(dir_to_save_results_to);
num_iters = size(lower_triangular_indexes,1);
parfor i=1:size(lower_triangular_indexes,1)
    current_data = sliced_table{i};
    current_neuron_ts = current_data{1,"timestamps"}{1};
    current_compare_neuron_ts = current_data{2,"timestamps"}{1};

    [~,index_of_larger ]= max([length(current_compare_neuron_ts),length(current_neuron_ts)]);
    [smaller_cluster_size,~ ]= min([length(current_compare_neuron_ts),length(current_neuron_ts)]);
    if index_of_larger==1
        %if the larger cluster is the compare neuron then we use the ts
        %of the current neuron as our compare
        number_of_timestamps_in_common = find_number_of_true_positives_given_a_time_delta_hpc(current_neuron_ts,current_compare_neuron_ts,config.TIME_DELTA);
    elseif index_of_larger==2
        %if the larger cluster is the current_neuron then we use the ts
        %of the compare neuron as our compare
        %the logic behind this is that the first set of ts that are put
        %into the function will never be over counted
        number_of_timestamps_in_common = find_number_of_true_positives_given_a_time_delta_hpc(current_compare_neuron_ts,current_neuron_ts,config.TIME_DELTA);
    else
        number_of_timestamps_in_common=0;
    end
    array_of_lower_triangular_overlap_percentages{i} = (number_of_timestamps_in_common / smaller_cluster_size) * 100;
    print_status_iter_message("get_matrix_of_overlap_percentages.m",i,num_iters)
end

% populate the matrix of overlap percentages
for i=1:size(array_of_lower_triangular_overlap_percentages)
    current_rows_and_col = lower_triangular_indexes;
    current_row = current_rows_and_col(1);
    current_col = current_rows_and_col(2);
    current_overlap_percentage = array_of_lower_triangular_overlap_percentages{i};
    matrix_of_overlap_percentages(current_row,current_col) = current_overlap_percentage;
    matrix_of_overlap_percentages(current_col,current_row) = current_overlap_percentage;
    print_status_iter_message("get_matrix_of_overlap_percentages.m: populate matrix",i,size(array_of_lower_triangular_overlap_percentages))

end


table_of_overlap_percentages = array2table(matrix_of_overlap_percentages,'RowNames',row_names,'VariableNames',col_names);
save("table_of_overlap_percentages.mat","table_of_overlap_percentages");
cd(home_dir);
end