function [art_tetrode_array] = build_artificial_tetrode_ver_2(size_of_tetrode)
art_tetrode_array = [];

for i=1:384
    neighbors_of_current_channel = find_valid_neighbors_ver_2(i);
    if length(neighbors_of_current_channel)+1 < size_of_tetrode
        additional_neighbors = [];
        for j=1:size(neighbors_of_current_channel)
            additional_neighbors = [additional_neighbors,find_valid_neighbors_ver_2(neighbors_of_current_channel(j))];
        end
        all_neighbors_with_current_channel = [neighbors_of_current_channel,additional_neighbors,i];
        all_neighbors_with_current_channel = unique(all_neighbors_with_current_channel);
        all_permutations_of_tetrodes = combinations(all_neighbors_with_current_channel,size_of_tetrode);
        
        % all_valid_permutations = check_permutations_to_ensure_valid_neighbors_minimum_met(all_permutations_of_tetrodes);
        art_tetrode_array = [art_tetrode_array;all_permutations_of_tetrodes];
    elseif length(neighbors_of_current_channel)+1 == size_of_tetrode
        all_neighbors_with_current_channel = [i,neighbors_of_current_channel];
        art_tetrode_array = [art_tetrode_array;all_neighbors_with_current_channel];
    elseif length(neighbors_of_current_channel)+1 > size_of_tetrode
        all_neighbors_with_current_channel = [i,neighbors_of_current_channel];
        all_permutations_of_tetrodes = nchoosek(all_neighbors_with_current_channel,size_of_tetrode);
        all_permutations_of_tetrodes(any(diff(sort(all_permutations_of_tetrodes,2),[],2)==0,2),:)=[];
        all_valid_permutations = check_permutations_to_ensure_valid_neighbors_minimum_met(all_permutations_of_tetrodes);
        art_tetrode_array = [art_tetrode_array;all_valid_permutations];
    end


end
art_tetrode_array = unique(art_tetrode_array,"rows");

disp(art_tetrode_array);
disp(size(art_tetrode_array))

end