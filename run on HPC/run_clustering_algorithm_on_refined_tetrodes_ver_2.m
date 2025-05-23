function [] = run_clustering_algorithm_on_refined_tetrodes_ver_2(ideal_dimensions,precomputed_dir,dictionaries_dir,refined_tetrode_idx,config,z_score_to_use_for_reclustering)

channels_in_current_tetrode = ideal_dimensions;

if config.ON_HPC
    timestamps = importdata(config.TIMESTAMP_FP_ON_HPC);
    load(config.DIR_WITH_CHANNEL_WISE_MEANS_AND_STDS_ON_HPC);
    % disp("Loading Spikes")
    % disp(fullfile(config.BLIND_PASS_DIR_PRECOMPUTED_ON_HPC,"spike_windows min_z_score "+string(z_score_to_use_for_reclustering)+" num dps "+string(config.NUM_DPTS_TO_SLICE),"spike_windows.mat"));
    spike_windows_per_z_score = importdata(fullfile(config.BLIND_PASS_DIR_PRECOMPUTED_ON_HPC,"spike_windows min_z_score "+string(z_score_to_use_for_reclustering)+" num dps "+string(config.NUM_DPTS_TO_SLICE),"spike_windows.mat"));
    disp("Finished Loading Spikes")
    disp("Beginning Spike Slicing for "+strjoin(string(ideal_dimensions)));
    get_dictionaries_for_refined_pass_spikes(channels_in_current_tetrode,spike_windows_per_z_score,config.DIR_WITH_OG_CHANNEL_RECORDINGS_ON_HPC,timestamps,config.NUM_DPTS_TO_SLICE,config.SCALE_FACTOR,dictionaries_dir,refined_tetrode_idx)
else
    timestamps = importdata(config.TIMESTAMP_FP);
    load(config.DIR_WITH_CHANNEL_WISE_MEANS_AND_STDS);
    % disp("Loading Spikes")
    spike_windows_per_z_score = importdata(fullfile(config.BLIND_PASS_DIR_PRECOMPUTED,"spike_windows min_z_score "+string(z_score_to_use_for_reclustering)+" num dps "+string(config.NUM_DPTS_TO_SLICE),"spike_windows.mat"));
    disp("Finished Loading Spikes")
    get_dictionaries_for_refined_pass_spikes(channels_in_current_tetrode,spike_windows_per_z_score,config.DIR_WITH_OG_CHANNEL_RECORDINGS,timestamps,config.NUM_DPTS_TO_SLICE,config.SCALE_FACTOR,dictionaries_dir,refined_tetrode_idx)
end
%get the spike windows for each channel defined in
%table_of_desired_tetrodes


initial_tetrode_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(fullfile(precomputed_dir,"ideal_dims_pass Top "+string(size(ideal_dimensions,2))+ " Channels"));
initial_tetrode_results_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(fullfile(precomputed_dir,"ideal_dims_pass_results Top "+string(size(ideal_dimensions,2)) + " Channels"));

disp("Beginning Re clustering")
%run_clustering_algorithm_on_desired_tetrodes_ver_3(list_of_desired_tetrodes,channel_wise_means,channel_wise_std,number_of_std_above_means,dir_with_channel_recordings,dictionaries_dir,inital_tetrode_dir,initial_tetrodes_results_dir)
if config.ON_HPC
    try
        [output_array,aligned_array,~] = run_clustering_algorithm_on_desired_tetrodes_ver_3("t"+string(refined_tetrode_idx),channel_wise_means,channel_wise_std,config.NUM_OF_STD_ABOVE_MEAN,config.DIR_WITH_OG_CHANNEL_RECORDINGS_ON_HPC,dictionaries_dir,initial_tetrode_dir,initial_tetrode_results_dir);
        save(fullfile(initial_tetrode_results_dir,"t"+string(refined_tetrode_idx)+"_z_score_"+z_score_to_use_for_reclustering+".txt"))
        save(fullfile(initial_tetrode_results_dir,"t"+string(refined_tetrode_idx)+"_channels_"+strjoin(string(channels_in_current_tetrode))+".txt"))
    catch ME
        disp("t"+string(refined_tetrode_idx) +"Failed Because of ")
        disp(ME.identifier)
        disp(ME.message)
        disp(ME.cause)
        disp(ME.stack);
        disp(ME.Correction);
    end
else
    try
        [output_array,aligned_array,~] = run_clustering_algorithm_on_desired_tetrodes_ver_3("t"+string(refined_tetrode_idx),channel_wise_means,channel_wise_std,config.NUM_OF_STD_ABOVE_MEAN,config.DIR_WITH_OG_CHANNEL_RECORDINGS,dictionaries_dir,initial_tetrode_dir,initial_tetrode_results_dir);
        save(fullfile(initial_tetrode_results_dir,"t"+string(refined_tetrode_idx)+"_z_score_"+z_score_to_use_for_reclustering+".txt"))
    catch ME
        disp("t"+string(refined_tetrode_idx) +"Failed Because of ")
        disp(ME.identifier)
        disp(ME.message)
        disp(ME.cause)
        disp(ME.stack);
        disp(ME.Correction);
    end
end

%run_clustering_algorithm_on_desired_tetrodes_ver_3("t"+string(refined_tetrode_idx),channel_wise_means,channel_wise_std,config.NUM_OF_STD_ABOVE_MEAN,config.DIR_WITH_OG_CHANNEL_RECORDINGS,)


end