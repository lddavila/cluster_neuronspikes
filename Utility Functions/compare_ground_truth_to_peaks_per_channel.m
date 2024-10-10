function [neuron_to_possible_channels] = compare_ground_truth_to_peaks_per_channel(peaks_per_channel,ground_truth_array,overlap_percentage,already_calculated,dir_with_data)
if already_calculated
    neuron_to_possible_channels = importdata(dir_with_data+"\neurons_to_possible_channels.mat");
    return;
end
neuron_to_possible_channels = containers.Map("KeyType",'char','ValueType','any');

% neuron_to_possible_channels = cell(1,length(ground_truth_array));
for i=1:length(ground_truth_array)
    current_neuron_ground_truth = ground_truth_array{i};
    og_size_of_ground_truth = size(current_neuron_ground_truth,2);
    current_neuron_ground_truth_with_added_ranges = [];
    for p=1:length(current_neuron_ground_truth)
        current_spike = current_neuron_ground_truth(p);
        current_neuron_ground_truth_with_added_ranges = [current_neuron_ground_truth_with_added_ranges, current_spike - 10:current_spike+10];
    end
    current_neuron_ground_truth = current_neuron_ground_truth_with_added_ranges;
    possible_channels = [];
    for j=1:length(peaks_per_channel)
        current_channel_peaks = peaks_per_channel{j};
        overlap = intersect(current_neuron_ground_truth,current_channel_peaks);
        if length(overlap) >= overlap_percentage * og_size_of_ground_truth
            possible_channels = [possible_channels;j];
        end
        disp("Finished " + string(i)+ "/"+string(length(ground_truth_array))+ " "+ string(j) + "/" + string(length(peaks_per_channel)));
    end
    % disp("Finished "+string(i)+"/"+length(ground_truth_array));
    neuron_to_possible_channels(string(i)) = possible_channels;
end
if ~already_calculated
    dir_with_data = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_with_data);
    save(dir_with_data+"\neurons_to_possible_channels.mat","neuron_to_possible_channels");
end
end