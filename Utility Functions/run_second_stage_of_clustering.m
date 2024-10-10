function [] = run_second_stage_of_clustering(grades_dir,results_dir,valid_neighbors,channels_in_current_tetrode,tetrode_you_want_to_load,dir_to_save_sub_tetrodes_to,dir_with_channel_recordings,scale_factor,min_z_score,num_dps,timestamps_dir,precomputed_dir,min_threshold)
% dir_to_save_sub_tetrodes_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_sub_tetrodes_to);
% grades_for_current_tetrode = load(grades_dir+"\"+tetrode_you_want_to_load+".mat");
config = spikesort_config(); %load the config file;

results_of_initial_pass_for_tetrode = strtrim(string(ls(results_dir+"\"+tetrode_you_want_to_load+"*.mat")));

for i=1:size(results_of_initial_pass_for_tetrode,1)
    load(results_dir+"\"+results_of_initial_pass_for_tetrode(i));
end

% for debugging
%plot the original version

idx = extract_clusters_from_output(output(:,1),output,config);
for first_dimension = 1:length(channels_in_current_tetrode)
    for second_dimension = first_dimension+1:length(channels_in_current_tetrode)
        new_plot_proj(idx,aligned,first_dimension,second_dimension,channels_in_current_tetrode,tetrode_you_want_to_load);
    end
end
% precomputed_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 Second Precomputed Data";
what_is_precomputed = ["z_score","mean_and_std", "spikes_per_channel 3","spike_windows min_z_score 4 num dps 60","spikes_per_channel min_z_score 4","dictionaries min_z_score 4 num_dps 60"];

%then plot the results of adding new channels in
for i=7:length(valid_neighbors)
    [output_array,aligned_array,reg_timestamps_array] =run_clustering_on_subtetrode(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,[channels_in_current_tetrode,valid_neighbors(i)],tetrode_you_want_to_load,valid_neighbors(i));

    output = output_array{1};
    idx = extract_clusters_from_output(output(:,1),output,config);
    for first_dimension = 1:length(channels_in_current_tetrode)+1
        for second_dimension = first_dimension+1:length(channels_in_current_tetrode)+1
            new_plot_proj(idx,aligned_array{1},first_dimension,second_dimension,[channels_in_current_tetrode,valid_neighbors(i)],tetrode_you_want_to_load+" SUP "+string(valid_neighbors(i)));
        end
    end
end

end