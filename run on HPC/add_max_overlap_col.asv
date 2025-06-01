function [table_of_all_clusters_with_max_overlap_cols] = add_max_overlap_col(base_table_of_all_clusters,config)
%add_idx_col
%this function requires a table in the form of base_table_of_all_clusters
%as created in get_table_of_all_clusters_from_blind_pass.m
%this function will only ever work for simulated data as it requires ground truth which is not available for non-simulated data

    function [max_overlap_per_cluster,indexes_of_max_overlap_per_cluster,array_of_overlap_percentages] = get_max_overlap_per_cluster(current_data,cluster_ts,ground_truth,timestamps,time_delta,config)
        array_of_overlap_percentages = cell(size(current_data,1),1);
        max_overlap_per_cluster = zeros(size(current_data,1),1);
        indexes_of_max_overlap_per_cluster = zeros(size(current_data,1),1);
        for j=1:size(current_data,1)
            array_of_overlap_percentages{j} = get_overlap_between_cluster_and_unit_as_percentage(cluster_ts{j},ground_truth,timestamps,time_delta,config);
            [max_overlap_per_cluster(j),indexes_of_max_overlap_per_cluster(j)] = max(array_of_overlap_percentages{j});
        end
    end

    function [max_overlap_per_cluster,indexes_of_max_overlap_per_cluster,array_of_overlap_percentages] = get_max_overlap_per_cluster_in_parallel(current_data,cluster_ts,ground_truth,timestamps,time_delta,config)
        array_of_overlap_percentages = cell(size(current_data,1),1);
        max_overlap_per_cluster = zeros(size(current_data,1),1);
        indexes_of_max_overlap_per_cluster = zeros(size(current_data,1),1);
        parfor j=1:size(current_data,1)
            array_of_overlap_percentages{j} = get_overlap_between_cluster_and_unit_as_percentage(cluster_ts{j},ground_truth,timestamps,time_delta,config);
            [max_overlap_per_cluster(j),indexes_of_max_overlap_per_cluster(j)] = max(array_of_overlap_percentages{j});
        end

    end


errorStruct = struct;
%table_of_all_clusters_with_max_overlap_cols = [];
required_cols = ["Z Score","Tetrode","Cluster","grades","dir_to_output","dir_to_aligned","dir_to_ts","dir_to_grades","dir_to_r_tvals"];
list_of_cols = base_table_of_all_clusters.Properties.VariableNames;


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

table_of_all_clusters_with_max_overlap_cols = [];
has_required_cols = check_for_required_cols(base_table_of_all_clusters,required_cols,"add_max_overlap_col.m","ensure get_table_of_all_clusters_from_blind_pass.m was run",0);
if ~has_required_cols
    return;
end

%slice the data for parallel processing
sliced_data = slice_table_for_parallel_processing(base_table_of_all_clusters,["Z Score","Tetrode"]);

cell_array_of_new_table = cell(size(sliced_data,1),1);
number_of_iterations = size(cell_array_of_new_table,1);

for i=1:size(sliced_data,1)
    current_data = sliced_data{i};
    have_ts = check_for_required_cols(current_data,["timestamps"],"add_max_overlap_col.m","",1); %check to see if the cluster already has spike timestamps added
    if ~have_ts
        reg_timestamps_of_the_spikes = importdata(current_data{1,"dir_to_ts"}); %if it doesn't have them then import them
        have_idx = check_for_required_cols(current_data,["cluster_idx"],"add_max_overlap_col.m","",1); %check to see if the cluster_idx for each cluster is already in the table
        if ~have_idx
            output = importdata(current_data{1,"dir_to_output"}); %if it doesn't have the cluster_idx then get them
            idx = extract_clusters_from_output(output(:,1),output);
        else
            idx = current_data{:,"cluster_idx"};
        end
        if size(current_data,1) ~= size(idx,1)
            error("add_max_overlap_col threw an error.\n current_data rows don't match number of clusters expected according to extract_clusters_from_output.m")
        end
        cluster_ts = cellfun(@(idx) reg_timestamps_of_the_spikes(idx,:),idx,'UniformOutput',false);
    else
        cluster_ts = current_data{:,"timestamps"};
    end






    if config.USE_PARALLEL && config.IS_PARALLEL_AVAILABLE
        [max_overlap_per_cluster,indexes_of_max_overlap_per_cluster,array_of_overlap_percentages] = get_max_overlap_per_cluster_in_parallel(current_data,cluster_ts,ground_truth,timestamps,time_delta,config);
    else
        [max_overlap_per_cluster,indexes_of_max_overlap_per_cluster,array_of_overlap_percentages] = get_max_overlap_per_cluster(current_data,cluster_ts,ground_truth,timestamps,time_delta,config);
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