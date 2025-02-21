function [] = run_clustering_algorithm_on_refined_tetrodes(table_of_ideal_dimension,precomputed_dir,num_dps,dictionaries_dir,dir_with_chan_recordings,timestamps,scale_factor,refined_tetrode_idx,channel_wise_means,channel_wise_std,min_threshold,min_amp)

channels_in_current_tetrode = table_of_ideal_dimension{:,"channel"}.';

%get the spike windows for each channel defined in
%table_of_desired_tetrodes
spike_windows_per_z_score = cell(1,size(table_of_ideal_dimension,1));
for i=1:length(spike_windows_per_z_score)
    spike_windows_per_z_score{i} = importdata(precomputed_dir+"\spike_windows min_z_score "+string(table_of_ideal_dimension{i,"z-score"})+" num dps "+string(num_dps)+"\spike_windows.mat","spike_windows");
end
get_dictionaries_for_refined_pass_spikes(channels_in_current_tetrode,spike_windows_per_z_score,dir_with_chan_recordings,timestamps,num_dps,scale_factor,dictionaries_dir,refined_tetrode_idx)
initial_tetrode_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\TEST refinement_pass min amp "+string(min_amp) + " Top "+string(size(table_of_ideal_dimension,1))+ " Channels");
initial_tetrode_results_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\TEST refinement_pass_results min amp "+string(min_amp)+ " Top "+string(size(table_of_ideal_dimension,1)) + " Channels");

% disp("Beginning Re clustering")
[output_array,aligned_array,~] = run_clustering_algorithm_on_desired_tetrodes_ver_3("t"+string(refined_tetrode_idx),channel_wise_means,channel_wise_std,min_threshold,dir_with_chan_recordings,dictionaries_dir,initial_tetrode_dir,initial_tetrode_results_dir);
% output = output_array{1};
% aligned = aligned_array{1};
% load(initial_tetrode_dir+"\"+"t"+string(refined_tetrode_idx)+".mat","timestamps","r_tvals","cleaned_clusters");
% config = spikesort_config; %load the config file;
% config = config.spikesort;
% grades = compute_gradings_ver_2(aligned, timestamps, r_tvals, cleaned_clusters, config,false,[],output,[""],channels_in_current_tetrode);

end