function [table_of_all_clusters_with_max_overlap_cols] = add_max_overlap_col(table_of_all_clusters,config)
errorStruct = struct;
table_of_all_clusters_with_max_overlap_cols = [];
required_cols = ["Z Score","Tetrode","Cluster","grades","dir_to_output","dir_to_aligned","dir_to_ts","dir_to_grades","dir_to_r_tvals"];
list_of_cols = table_of_all_clusters.Properties.VariableNames;

if config.ON_HPC
    ground_truth = importdata(config.FP_TO_GT_FOR_RECORDING_ON_HPC);
    timestamps = importdata(config.TIMESTAMP_FP_ON_HPC);
else
    ground_truth = importdata(config.GT_FP);
    timestamps = importdata(config.TIMESTAMP_FP);
end

time_delta = config.TIME_DELTA;

if ~config.SIMULATED
    errStruct = struct( ...
        'identifier', 'adding_max_overlap:not_simulated', ...
        'message', 'Cannot add overlap columns on non-simulated (real) data.', ...
        'cause', 'Your config file has the config.SIMULATED field set to false. If your recording is simulated ensure that your config file reflects this.');
    error(errStruct); % Throw custom error
    error(errorStruct);
end
for i=1:size(required_cols,1)
    if ~ismember(required_cols(i),list_of_cols)
        error("input table is missing "+required_cols(i)+". Please use get_table_of_all_clusters_from_blind_pass.m to add them.");
    end

end

%slice the data for parallel processing
tetrode_and_z_score_groups = groupcounts(table_of_all_clusters,["Z Score","Tetrode"]);
sliced_data = cell(size(tetrode_and_z_score_groups,1),1);
for i=1:size(sliced_data,1)
    c_1 = table_of_all_clusters{:,"Z Score"} == tetrode_and_z_score_groups{i,"Z Score"};
    c_2 = table_of_all_clusters{:,"Tetrode"} == tetrode_and_z_score_groups{i,"Tetrode"};
    sliced_data{i} = table_of_all_clusters(c_1 & c_2,:);
end
cell_array_of_new_table = cell(size(sliced_data,1),1);
number_of_iterations = size(cell_array_of_new_table,1);
for i=1:size(sliced_data,1)
    current_data = sliced_data{i};
    output = importdata(current_data{1,"dir_to_output"});
    % aligned = importdata(current_data{1,"dir_to_aligned"});
    reg_timestamps_of_the_spikes = importdata(current_data{1,"dir_to_ts"});
    idx = extract_clusters_from_output(output(:,1),output);

    if size(current_data,1) ~= size(idx,1)
        error("add_max_overlap_col threw an error.\n current_data rows don't match number of clusters expected according to extract_clusters_from_output.m")
    end
    array_of_overlap_percentages = cell(size(current_data,1),1);
    max_overlap_per_cluster = zeros(size(current_data,1),1);
    indexes_of_max_overlap_per_cluster = zeros(size(current_data,1),1);
    for j=1:size(current_data,1)
        array_of_overlap_percentages{j} = get_overlap_between_cluster_and_unit_as_percentage(reg_timestamps_of_the_spikes(idx{j}),ground_truth,timestamps,time_delta,config);
        [max_overlap_per_cluster(j),indexes_of_max_overlap_per_cluster(j)] = max(array_of_overlap_percentages{j});
    end

    current_data.("Max Overlap % With Unit") = max_overlap_per_cluster;
    current_data.("Max Overlap Unit") = indexes_of_max_overlap_per_cluster;
    current_data.("overlap % with all units") = array_of_overlap_percentages;
    disp("add_max_overlap_col.m Finished "+string(i)+"/"+string(number_of_iterations));
    cell_array_of_new_table{i} = current_data;
end

table_of_all_clusters_with_max_overlap_cols = vertcat(cell_array_of_new_table{:}) ;

% import_data_hpc
end