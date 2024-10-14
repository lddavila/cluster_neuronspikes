function [valid_permutations] = check_permutations_to_ensure_valid_neighbors_minimum_met(permutations_of_channels)
%for a row to be a valid permutation every channel must be a valid neighbor of at least 2 other channels in the row
valid_permutations = [];
for i=1:size(permutations_of_channels,1)
    current_permutation = permutations_of_channels(i,:);
    valid_neighbors = [];
    for j=1:size(current_permutation,2)
        valid_neighbors= [valid_neighbors,find_valid_neighbors_ver_2(current_permutation(j))];
    end
    is_valid_permutation = true;
    for j=1:size(current_permutation,2)
        current_channel = current_permutation(j);
        how_many_times_does_current_channel_appear_in_valid_neighbors = sum(valid_neighbors == current_channel);
        if how_many_times_does_current_channel_appear_in_valid_neighbors < 2
            is_valid_permutation = false;
        end
    end
    if is_valid_permutation
        valid_permutations = [valid_permutations;current_permutation];
    end
    
end