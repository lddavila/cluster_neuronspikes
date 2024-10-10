function [] = run_entire_clustering_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,create_z_score_matrix)
% Step 2: Get ordered List of Channels
ordered_list_of_channels = get_ordered_list_of_channel_names();

% step 3: get the mean and std of all channels
clc;
z_score_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\"+string(scale_factor)+" Scaled Z_scores for 300 Second Recording";

[channel_wise_means,channel_wise_std] = get_channel_wise_statistics(ordered_list_of_channels,dir_with_channel_recordings,z_score_dir,create_z_score_matrix,scale_factor);
%there is 1 mean per channel and 1 std dvn per channel

%step 4: create artificial_tetrodes first pass,
clc;
art_tetr_array = build_artificial_tetrode;
art_tetr_array = [25 26 27 28 ;122 219 314 315];
% art_tetr_array = [25 26 27 101; 122 219 314 290];

% step 5: get potential spikes from continuous recordings
    %<3 causes out of memory error
    %=3 causes every tetrode to have spikes (should be impossible when there are only 10 neurons)
    %=4 causes every tetrode to have spikes (should be impossible
    %=5 causes 87 tetrodes which will cause 87 non empty tetrodes (better but still too much)
    %=6 creates huge jump to only 43 non empty tetrodes, so I think that this is the minimum needed to get ride of noise
    %=10 only 21 active tetrodes, which is probably too few given that we have 10 neurons
%ordered_list_of_channels = ["c25","c26","c27","c28","c122","c219","c314","c315","c101","c290"];
spikes_per_channel = detect_spikes_ver_2(ordered_list_of_channels,dir_with_channel_recordings,z_score_dir,min_z_score,scale_factor);

% step 6; Get all the data points from the potential spikes
spike_windows = get_spike_windows_ver_2(ordered_list_of_channels,spikes_per_channel,min_z_score,num_dps,z_score_dir);
    %each array is made up of 4 numbers:
        %the first is the beginning of the spike window
        %the second is the end of the spike_window
        %the third is the original channel of the spike
        %the fourth is the original the peak of the spike according to find_peaks


% step 7: load the timestamps into memory
timestamps = importdata(timestamps_dir+"\timestamps.mat");

% step 8: get maps of each tetrode to its spikes
clc;
[tetrode_dictionary,spike_tetrode_dictionary,timing_tetrode_dictionary,channel_to_tetrode_dictionary,spiking_channel_tetrode_dictionary,spike_tetrode_dictionary_samples_format] = get_dictionaries_of_all_spikes_ver_2(art_tetr_array,spike_windows,dir_with_channel_recordings,timestamps,num_dps,scale_factor);
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
number_of_non_empty_tetrodes = check_how_many_tetrodes_have_more_than_zero_spikes(spike_tetrode_dictionary);
disp("Non Empty Tetrodes:" + string(number_of_non_empty_tetrodes))
clc;


% Step 9: Run Clustering Algorithm
% close all;
clc;
% 80 and 116 and 14
% array_of_desired_tetrodes = get_array_of_all_tetrodes_which_contain_given_channel(114,art_tetr_array);
% array_of_desired_tetrodes = array_of_desired_tetrodes(2:end);
array_of_desired_tetrodes = strcat("t",string(1:size(art_tetr_array,1)));
[output_array,aligned_array,reg_timestamps_array] = run_clustering_algorithm_on_desired_tetrodes(array_of_desired_tetrodes,tetrode_dictionary,spike_tetrode_dictionary,spike_tetrode_dictionary_samples_format,channel_wise_means,channel_wise_std,6,timing_tetrode_dictionary,dir_with_channel_recordings);
end