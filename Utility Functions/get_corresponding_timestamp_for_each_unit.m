function [ground_truth_timestamps] = get_corresponding_timestamp_for_each_unit(timestamps,ground_truth)
ground_truth_timestamps = cell(1,size(ground_truth,2));
for i=1:size(ground_truth,2)
    ground_truth_timestamps{i} = timestamps(ground_truth{i});
end
end