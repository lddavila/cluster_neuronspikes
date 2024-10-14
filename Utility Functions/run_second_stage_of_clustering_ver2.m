function [] = run_second_stage_of_clustering_ver2(results_dir,valid_neighbors,channels_in_current_tetrode,tetrode_you_want_to_load,dir_with_channel_recordings,scale_factor,min_z_score,num_dps,timestamps_dir,precomputed_dir,min_threshold,number_of_channels_to_add,pass_number)
config = spikesort_config(); %load the config file;

results_of_initial_pass_for_tetrode = strtrim(string(ls(results_dir+"\"+tetrode_you_want_to_load+" *.mat")));

for i=1:size(results_of_initial_pass_for_tetrode,1)
    load(results_dir+"\"+results_of_initial_pass_for_tetrode(i));
end

% for debugging
%plot the original version

% idx = extract_clusters_from_output(output(:,1),output,config);
% for first_dimension = 1:length(channels_in_current_tetrode)
%     for second_dimension = first_dimension+1:length(channels_in_current_tetrode)
%         new_plot_proj(idx,aligned,first_dimension,second_dimension,channels_in_current_tetrode,tetrode_you_want_to_load);
%     end
% end
% precomputed_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 Second Precomputed Data";
what_is_precomputed = ["z_score","mean_and_std", "spikes_per_channel 3","spike_windows min_z_score 4 num dps 60","spikes_per_channel min_z_score 4","dictionaries min_z_score 4 num_dps 60"];

%then plot the results of adding new channels in
possible_valid_neigbor_combinations = nchoosek(valid_neighbors,number_of_channels_to_add);

for i=1:size(possible_valid_neigbor_combinations,1)
    new_tetrode_with_additional_neighbors = [channels_in_current_tetrode,possible_valid_neigbor_combinations(i,:)];
    [output_array,aligned_array,reg_timestamps_array] =run_clustering_on_subtetrode(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,new_tetrode_with_additional_neighbors,tetrode_you_want_to_load,possible_valid_neigbor_combinations(i,:),pass_number);
    output = output_array{1};
    idx = extract_clusters_from_output(output(:,1),output,config);
    % for first_dimension = 1:length(channels_in_current_tetrode)+1
    %     for second_dimension = first_dimension+1:length(channels_in_current_tetrode)+1
    %         new_plot_proj(idx,aligned_array{1},first_dimension,second_dimension,[channels_in_current_tetrode,valid_neighbors(i)],tetrode_you_want_to_load+" SUP "+string(valid_neighbors(i)));
    %     end
    % end
end

end