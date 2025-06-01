function [array_of_overlap_with_unit] = get_overlap_between_cluster_and_unit_as_percentage(timestamps_of_cluster,ground_truth,timestamps,time_delta,config)
array_of_overlap_with_unit = zeros(1,length(ground_truth));
for i=1:length(ground_truth)
    current_unit_ts_locs = ground_truth{i};
    number_of_times_current_unit_spikes = size(current_unit_ts_locs,2);
    current_unit_ts = timestamps(current_unit_ts_locs);
    if config.IS_GPU_AVAILABLE && config.USE_GPU
        current_unit_ts = gpuArray(current_unit_ts);
        timestamps_of_cluster = gpuArray(timestamps_of_cluster);
    end
    number_of_ts_in_common = 0;
    for j=1:number_of_times_current_unit_spikes
        number_of_ts_in_common = number_of_ts_in_common + run_check(current_unit_ts,j,timestamps_of_cluster,time_delta);
    end
    array_of_overlap_with_unit(i) = (number_of_ts_in_common / number_of_times_current_unit_spikes) * 100;
end
end