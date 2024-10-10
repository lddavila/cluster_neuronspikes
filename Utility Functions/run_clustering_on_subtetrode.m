function [output_array,aligned_array,reg_timestamps_array] = run_clustering_on_subtetrode(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_pre_computed,min_threshold,art_tetr_array,name_of_original_tetrode,added_channel)
% if what_is_pre_computed is not empty then we can skip several of the steps and just load the data
%   each element of "what_is_precomputed" is a string telling you what is already done

%create the directory if it doesn't alreay exist so you can save anything you need to it
if isempty(what_is_pre_computed)
    precomputed_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir);
end

has_been_computed = []; %will store what was successfully computed and saved

% Step 2: Get ordered List of Channels
ordered_list_of_channels = get_ordered_list_of_channel_names();

% step 4: get or make the z_score channel data directory
if ~ismember("z_score",what_is_pre_computed) %means that the z_score matrix is already computed and we will skip computing it again
    z_score_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\z_score"); %not yet computed
    create_z_score_matrix = 1;
else
    z_score_dir = precomputed_dir+"\z_score"; %in this case it already exists
    create_z_score_matrix = 0;
    has_been_computed = [has_been_computed,"z_score"];
end

% step 5: get the mean and std of all channels
if ~ismember("mean_and_std",what_is_pre_computed) %means that the channel wise mean and standard deviation are already computed so we will skip computing them again
    [channel_wise_means,channel_wise_std] = get_channel_wise_statistics(ordered_list_of_channels,dir_with_channel_recordings,z_score_dir,create_z_score_matrix,scale_factor); %will get the mean and std of every channel and calculate z_score for data set if not yet created
    mean_and_std_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\mean_and_std");
    save(mean_and_std_dir+"\mean_and_std.mat","channel_wise_means","channel_wise_std");
    has_been_computed = [has_been_computed,"mean_and_std"];
else
    load(precomputed_dir+"\mean_and_std\mean_and_std.mat",'channel_wise_means','channel_wise_std') %loads the previously found mean and std
end
%there is 1 mean per channel and 1 std dvn per channel

%step 6: create artificial_tetrodes first pass,
clc;
% art_tetr_array = build_artificial_tetrode;
% art_tetr_array = [25 26 27 28 ;122 219 314 315];
% art_tetr_array = [25 26 27 101; 122 219 314 290];


% step 7: get potential spikes from continuous recordings
%<3 causes out of memory error
%=3 causes every tetrode to have spikes (should be impossible when there are only 10 neurons)
%=4 causes every tetrode to have spikes (should be impossible
%=5 causes 87 tetrodes which will cause 87 non empty tetrodes (better but still too much)
%=6 creates huge jump to only 43 non empty tetrodes, so I think that this is the minimum needed to get ride of noise
%=10 only 21 active tetrodes, which is probably too few given that we have 10 neurons
%ordered_list_of_channels = ["c25","c26","c27","c28","c122","c219","c314","c315","c101","c290"];
if ~ismember("spikes_per_channel min_z_score "+ string(min_z_score),what_is_pre_computed)
    spikes_per_chan_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\spikes_per_channel min_z_score "+string(min_z_score));
    spikes_per_channel = detect_spikes_ver_2(ordered_list_of_channels,dir_with_channel_recordings,z_score_dir,min_z_score,scale_factor);
    save(spikes_per_chan_dir+"\spikes_per_channel.mat","spikes_per_channel");
    has_been_computed = [has_been_computed,"spikes_per_channel min_z_score"+string(min_z_score)];
else
    load(precomputed_dir+"\spikes_per_channel min_z_score " + string(min_z_score)+"\spikes_per_channel.mat", "spikes_per_channel")
end
% step 6; Get all the data points from the potential spikes
if ~ismember("spike_windows min_z_score " + string(min_z_score) + " num dps " + string(num_dps),what_is_pre_computed)
    spike_windows_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\spike_windows min_z_score " + string(min_z_score) + " num dps "+ string(num_dps));
    spike_windows = get_spike_windows_ver_2(ordered_list_of_channels,spikes_per_channel,min_z_score,num_dps,z_score_dir);
    has_been_computed = [has_been_computed,"spike_windows min_z_score" + string(min_z_score) + " num dps " + string(num_dps),what_is_pre_computed];
    %each array is made up of 4 numbers:
    %the first is the beginning of the spike window
    %the second is the end of the spike_window
    %the third is the original channel of the spike
    %the fourth is the original the peak of the spike according to find_peaks
    save(spike_windows_dir+"\spike_windows.mat","spike_windows");
else
    load(precomputed_dir+"\spike_windows min_z_score "+string(min_z_score)+" num dps "+string(num_dps) +"\spike_windows.mat","spike_windows")
end


% step 7: load the timestamps into memory
timestamps = importdata(timestamps_dir+"\timestamps.mat");

% step 8: get maps of each tetrode to its spikes
name_of_possible_dictionaries_dir = "sub_tetrode_dictionaries min_z_score " + string(min_z_score) + " num_dps " + string(num_dps)+" OG tetrode "+name_of_original_tetrode + " new channel " + string(added_channel);
if ~ismember(name_of_possible_dictionaries_dir,what_is_pre_computed)
    clc;
    dictionaries_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\"+name_of_possible_dictionaries_dir);
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
    has_been_computed = [has_been_computed,name_of_possible_dictionaries_dir];
else
    dictionaries_dir = precomputed_dir+"\"+name_of_possible_dictionaries_dir;
end


% Step 9: Run Clustering Algorithm
% close all;
clc;
if ~ismember("initial_pass",what_is_pre_computed)
    initial_tetrode_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\initial_pass");
    initial_tetrode_results_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\initial_pass_results");
    [output_array,aligned_array,reg_timestamps_array] = run_clustering_algorithm_on_desired_tetrodes_ver_3("t1",channel_wise_means,channel_wise_std,min_threshold,dir_with_channel_recordings,dictionaries_dir,initial_tetrode_dir,initial_tetrode_results_dir);
    has_been_computed = [has_been_computed,"initial_pass"];


end
end