function [ground_truth_timestamps] = get_corresponding_timestamp_for_each_unit_with_delta(timestamps,ground_truth,time_delta)

ground_truth_timestamps = cell(1,size(ground_truth,2));
number_of_data_points_infront_and_behind = time_delta / (timestamps(2) - timestamps(1));

if time_delta==0
    for i=1:size(ground_truth,2)
        ground_truth_timestamps{i} = timestamps(ground_truth{i});
    end
    return
end
for i=1:size(ground_truth,2)
    current_unit_timestamps = nan(100000000,1);
    current_unit_exact_ts = ground_truth{i};
    idx_of_first_nan = 1;
    for j=1:length(current_unit_exact_ts)
        % disp([i,j])


        current_spike_index = current_unit_exact_ts(j);
        time_delta_before = current_spike_index - ceil(number_of_data_points_infront_and_behind);
        time_delta_after = current_spike_index + ceil(number_of_data_points_infront_and_behind);
        if time_delta_before < 0
            time_delta_before =1;
        end
        if time_delta_after > length(timestamps)
            time_delta_after = length(timestamps);
        end
        timestamps_of_begin_to_end_of_time_delta = timestamps(time_delta_before:1:time_delta_after);
        current_unit_timestamps(idx_of_first_nan:idx_of_first_nan+length(timestamps_of_begin_to_end_of_time_delta)-1) = timestamps_of_begin_to_end_of_time_delta;
        idx_of_first_nan = idx_of_first_nan + length(timestamps_of_begin_to_end_of_time_delta);
    end
    current_unit_timestamps(isnan(current_unit_timestamps)) = [];
    ground_truth_timestamps{i} = current_unit_timestamps;
end
end