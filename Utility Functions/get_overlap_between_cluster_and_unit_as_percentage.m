function [array_of_overlap_with_unit] = get_overlap_between_cluster_and_unit_as_percentage(timestamps_of_cluster,ground_truth,timestamps,time_delta)
array_of_overlap_with_unit = zeros(1,length(ground_truth));

for i=1:length(ground_truth)
    current_unit_ts_locs = ground_truth{i};
    number_of_times_current_unit_spikes = size(current_unit_ts_locs,2);
    current_unit_ts = timestamps(current_unit_ts_locs);
    number_of_ts_in_common = 0;
    for j=1:number_of_times_current_unit_spikes
        diffs_between_unit_ts_and_cluster_ts = current_unit_ts(j) - timestamps_of_cluster;
        if any(abs(diffs_between_unit_ts_and_cluster_ts) < time_delta)
            number_of_ts_in_common = number_of_ts_in_common +1;
        end

    end
    array_of_overlap_with_unit(i) = (number_of_ts_in_common / number_of_times_current_unit_spikes) * 100;
end
end