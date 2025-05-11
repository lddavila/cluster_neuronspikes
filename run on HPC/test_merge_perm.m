function [cell_array_of_new_grades_and_accuracies] = test_merge_perm(aligned_cell_array,ts_of_clusters_spikes_cell_array,idx_cell_array,r_tvals_cell_array,all_channels,spike_og_locs_cell_array,config,all_z_scores,all_tetrodes,all_clusters,all_max_overlap_units,all_accuracies)
%we will not check whether or not they're good here we'll simply comine and regrade, then find then return the grades
%and the accuracy which we'll have to compute again
%we'll have to check every possible combination unfortunately which may quickly destroy the run time
%let's hope that there are never examples with too may overlaps

how_many_groups_you_can_make = 2;%:1:length(aligned_cell_array);
idxs_to_permute = 1:length(aligned_cell_array);


possible_comb = nchoosek(idxs_to_permute,how_many_groups_you_can_make);
possible_comb = possible_comb(any(possible_comb == 1, 2),:);
%disp(possible_comb);
% disp("Number of Combinations to try:"+size(possible_comb,1));
cell_array_of_new_grades_and_accuracies = cell(size(possible_comb,1),4);
for possible_comb_counter = 1:size(possible_comb,1)
    comb_key = strjoin(strcat("Z Score:",string(all_z_scores(possible_comb(possible_comb_counter,:)).')," ",all_tetrodes(possible_comb(possible_comb_counter,:)).'," Cluster ",string(all_clusters(possible_comb(possible_comb_counter,:)).')),"|");
    ts_to_combine = ts_of_clusters_spikes_cell_array(possible_comb(possible_comb_counter,:));
    idx_of_cluster_ts = idx_cell_array(possible_comb(possible_comb_counter,:));
    aligned_to_combine = aligned_cell_array(possible_comb(possible_comb_counter,:));

    [grades_of_comb,new_accuracy,flag] = regrade_spikes(ts_to_combine,idx_of_cluster_ts,aligned_to_combine,all_channels(possible_comb(possible_comb_counter,:),:),spike_og_locs_cell_array(possible_comb(possible_comb_counter,:)),config,r_tvals_cell_array(possible_comb(possible_comb_counter,:)),all_max_overlap_units(possible_comb(possible_comb_counter,:)));
    cell_array_of_new_grades_and_accuracies{possible_comb_counter,1} = comb_key+" grades"+flag;
    cell_array_of_new_grades_and_accuracies{possible_comb_counter,2}= grades_of_comb;
    cell_array_of_new_grades_and_accuracies{possible_comb_counter,3} = all_accuracies(1);
    cell_array_of_new_grades_and_accuracies{possible_comb_counter,4} =new_accuracy;
end


end