function [number_of_tetrodes_with_at_least_1_spike] = check_how_many_tetrodes_have_more_than_zero_spikes(spike_tetrode_dictionary)
keys_of_dict = string(keys(spike_tetrode_dictionary));
number_of_tetrodes_with_at_least_1_spike = 0;
for i=1:length(keys_of_dict)
    current_key = keys_of_dict(i);
    if all(size(spike_tetrode_dictionary(current_key)) ~= 0)
        number_of_tetrodes_with_at_least_1_spike = number_of_tetrodes_with_at_least_1_spike +1;
    end
end
end