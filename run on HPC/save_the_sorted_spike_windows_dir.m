function [] = save_the_sorted_spike_windows_dir(z_scores_to_do_it_for,config)
precomputed_dir = config.BLIND_PASS_DIR_PRECOMPUTED;
num_dps = config.NUM_DPTS_TO_SLICE;
art_tetr_array = config.ART_TETR_ARRAY;
dir_with_channel_recordings = config.DIR_WITH_OG_CHANNEL_RECORDINGS;
timestamps = importdata(config.TIMESTAMP_FP);
scale_factor = config.SCALE_FACTOR;
for min_z_score=z_scores_to_do_it_for
    dictionaries_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(fullfile(precomputed_dir,"dictionaries min_z_score "+string(min_z_score)+ " num_dps "+string(num_dps)));
    spike_windows=importdata(fullfile(precomputed_dir,"spike_windows min_z_score "+string(min_z_score)+" num dps "+string(num_dps),"spike_windows.mat"),"spike_windows");
    get_dictionaries_of_all_spikes_ver_3(art_tetr_array,spike_windows,dir_with_channel_recordings,timestamps,num_dps,scale_factor,dictionaries_dir);
    %tetrode_dictionary
    %keys: "t" + tetrode number
    %values: all channels which are part of the current dictionary
    %spike_tetrode_dictionary
    %keys: "t" + tetrode number
    %values: the spikes for the current tetrode organized as follows
    %[numwires, numspikes, numdp] = size(raw);
    %numwires: number of channels
    %numspikes: number of spikes
    %numdp: number of datapoints
    %timing_tetrode_dictionary
    %channel_to_tetrode_dictionary
    %keys: "c" + channel number
    %values: tetrode which the current channel belongs to
    %spiking_channel_tetrode_dictionary
    %keys: "t"+ tetrode number
    %values: a list of which channel was the actual spiking channel, ordered in the same way as spike_tetrode_dictionary
    %spike_tetrode_dictionary_samples_format
    %keys: "t"+tetrode number
    %values: the spikes for the current tetrode organzied as follows
    %[numdp, numspikes, numswires] = size(raw);
    %numwires: number of channels
    %numspikes: number of spikes
    %numdp: number of datapoints
    %timing_tetrode_dictionary
    % number_of_non_empty_tetrodes = check_how_many_tetrodes_have_more_than_zero_spikes(spike_tetrode_dictionary);
    % disp("Non Empty Tetrodes:" + string(number_of_non_empty_tetrodes))
    % clc;
    % has_been_computed = [has_been_computed,"dictionaries min_z_score " + string(min_z_score) + " num_dps " + string(num_dps),what_is_pre_computed];
end
end