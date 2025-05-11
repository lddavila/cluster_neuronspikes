function [] = get_sorted_spike_windows(config)
z_scores = [3 4 5 6 7 8 9];
list_of_tetrodes = strcat("t",string(1:size(config.ART_TETR_ARRAY,1)));
precomputed_dir = config.BLIND_PASS_DIR_PRECOMPUTED;
for lowest_z_score=z_scores
load(fullfile(precomputed_dir,"mean_and_std","mean_and_std.mat"),'channel_wise_means','channel_wise_std')
dictionaries_dir = fullfile(config.BLIND_PASS_DIR_PRECOMPUTED,"dictionaries min_z_score "+string(lowest_z_score)+" num_dps 60" );
initial_tetrode_results_dir = fullfile(config.BLIND_PASS_DIR_PRECOMPUTED,"initial_pass_results min z_score"+string(lowest_z_score));
initital_tetrode_dir = fullfile(config.BLIND_PASS_DIR_PRECOMPUTED,"initial_pass min z_score"+string(lowest_z_score));
run_clustering_algorithm_on_desired_tetrodes_ver_3(list_of_tetrodes,channel_wise_means,channel_wise_std,config.NUM_OF_STD_ABOVE_MEAN,config.DIR_WITH_OG_CHANNEL_RECORDINGS,dictionaries_dir,initital_tetrode_dir,initial_tetrode_results_dir);
end
end