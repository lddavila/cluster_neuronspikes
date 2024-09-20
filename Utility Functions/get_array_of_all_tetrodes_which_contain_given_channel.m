function [all_tetrodes_which_appear_in_array] = get_array_of_all_tetrodes_which_contain_given_channel(given_channel,art_tetr_array)
[all_tetrodes_which_appear_in_array,~] = find(art_tetr_array==given_channel);
all_tetrodes_which_appear_in_array = strcat("t", string(all_tetrodes_which_appear_in_array));
end