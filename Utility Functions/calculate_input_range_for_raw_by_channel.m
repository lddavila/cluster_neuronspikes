function [array_of_min_max_per_channel] = calculate_input_range_for_raw_by_channel(raw)
%raw is an array with the following dimensions
%1) Number of channels
%2) number of spikes
%3) number of data points
%to access all of the data points for the first channel, spike 1 you would index it as in the following example
%raw(1,1,:)

array_of_min_max_per_channel = [];
for i=1:size(raw,1)
    [min_value,max_value] = bounds(squeeze(raw(i,:,:)),"all"); %get the min/max value per channel
    array_of_min_max_per_channel = [array_of_min_max_per_channel;min_value,max_value];
end
end