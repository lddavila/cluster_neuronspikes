%% Add the Open Ephys Reading tools to the path 
%this directory is available here at the following github link
%https://github.com/open-ephys/open-ephys-matlab-tools.git
dir_with_open_ephys_reader_functions = "D:\open-ephys-matlab-tools"; %change this to match the local path
clustering_dir = cd("D:\open-ephys-matlab-tools");
addpath(genpath("."));

cd(clustering_dir);
addpath(genpath("."));
%% Load the Data (this one can take a while to run)
clc;
dir_with_continuous_recording_data = 'D:\Ephys Data\Electrophysiology Data (OpenEphys)\Steven\2024-11-26_15-42-34__Steven';
session = Session(dir_with_continuous_recording_data);
%% get the json file that tells you the multiplier to use 
% Read the content of the .oebin file
clc;
oebinFilePath = "D:\Ephys Data\Electrophysiology Data (OpenEphys)\Steven\2024-11-26_15-42-34__Steven\Record Node 103\experiment1\recording"+string(i)+"\structure.oebin";
fileID = fopen(oebinFilePath, 'r');
rawData = fread(fileID, inf, 'uint8=>char')';
fclose(fileID);

% Parse the JSON content
oebinStruct = jsondecode(rawData);

% Display the structure
disp(oebinStruct);
%% display how many recordings there are and in what format
clc;
session.show()
%% get the session's recording object
node = session.recordNodes{1};
%% print the size of the continous data
clc;
disp(node.recordings{1}.continuous.keys());
disp(node.recordings{1}.continuous('Neuropix-PXI-100.ProbeA-AP'))
disp(node.recordings{1}.continuous('Neuropix-PXI-100.ProbeA-AP').metadata)
%% save the samples into a compatible format (they are inverted in microvolts)
for i=1:3
    dir_to_save_samples_to = "E:\Steven\2024-11-26_15-42-34__Steven "+string(i) + " Raw Recordings";
    clc;
    oebinFilePath = "D:\Ephys Data\Electrophysiology Data (OpenEphys)\Steven\2024-11-26_15-42-34__Steven\Record Node 103\experiment1\recording"+string(i)+"\structure.oebin";
    fileID = fopen(oebinFilePath, 'r');
    rawData = fread(fileID, inf, 'uint8=>char')';
    fclose(fileID);

    % Parse the JSON content
    oebinStruct = jsondecode(rawData);
    struct_with_bit_volts = oebinStruct.continuous.channels;
    bit_volts = [struct_with_bit_volts(:).bit_volts] * -1;
    save_open_ehys_data_by_channel(node.recordings{i}.continuous('Neuropix-PXI-100.ProbeA-AP'),dir_to_save_samples_to,bit_volts);
end
%% run an initial pass of find peaks on the raw data (with the hope of identifying the spikes that appear on too many channels)
%spikes that appear on too many channels are indicative of chewing or
%bumps, artifacts in general
list_of_channels = strcat("c",string(1:384));
clc;
spikes_per_continous_recording = cell(1,3);
for i=1:3
    dir_with_channel_recordings  = "E:\Steven\2024-11-26_15-42-34__Steven "+string(i) + " Raw Recordings";
    spikes_per_continous_recording{i} = detect_spikes_on_raw_recordings(list_of_channels,dir_with_channel_recordings);
end

%% produce a mask for any spikes that appear in 6+ channels or spikes where the amplitude is high enough that it indicates a artifact
clc;
list_of_channels = strcat("c",string(177:384));
for i=1:1.5
    close all;
    clc;
    dir_with_raw_recordings = "E:\Steven\2024-11-26_15-42-34__Steven "+string(i) + " Raw Recordings";
    dir_to_save_index_mask_to = "E:\Steven\2024-11-26_15-42-34__Steven "+string(i)+" Raw Recordings Indexes Without artifacts";
    dir_to_save_index_mask_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_index_mask_to);
    make_plots = false;
    remove_peaks_that_appear_on_too_many_channels(spikes_per_continous_recording{i},dir_with_raw_recordings,dir_to_save_index_mask_to,make_plots,bit_volts,list_of_channels)
end
%% get the mean std and z score of the example open ephys data (mean and std are in microvolts)
channel_wise_means = cell(1,3);
channel_wise_stds = cell(1,3);
list_of_channels = strcat("c",string(1:384));
for i=1:1.5
    clc;
    dir_with_channel_data = "E:\Steven\2024-11-26_15-42-34__Steven "+string(i) + " Raw Recordings";
    dir_with_index_masks = "E:\Steven\2024-11-26_15-42-34__Steven 1 Raw Recordings Indexes Without artifacts";
    dir_to_save_z_score_files_to = "E:\Steven\2024-11-26_15-42-34__Steven "+string(i)+" Z Score With Artifacts Removed";
    save_z_score = false;
    scale_factor = 1;
    [channel_wise_means{i},channel_wise_stds{i}] =get_channel_wise_statistics_ver_2(list_of_channels,dir_with_channel_data,dir_with_index_masks,dir_to_save_z_score_files_to,save_z_score);
    clc;
end

%% clean data with various filters applied (filtered data is saved in inverted microvolts)
clc;
close all;
list_of_channels = strcat("c",string(177:384));
for i=1:1.5
    precomputed_dir = "E:\Steven\2024-11-26_15-42-34__Steven Precomputed "+string(i);
    dir_with_raw_recordings =  "E:\Steven\2024-11-26_15-42-34__Steven "+string(i) + " Raw Recordings";
    filters_to_apply = ["average","butterworth"];
    channel_means = channel_wise_means{i};
    channel_std = channel_wise_stds{i};
    plot_before_and_after = false;
    apply_filters_to_data(dir_with_raw_recordings,precomputed_dir,filters_to_apply,list_of_channels,channel_means,channel_std,plot_before_and_after)
end


%% run the find peaks function and getting the datapoints
clc;
num_dps=50;
spikes_per_recording_2 = cell(1,3);
list_of_channels = strcat("c",string(1:384));
precomputed_dir = "E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1";
min_z_score = 5;
for i=1:1.5
    % 
    dir_with_channel_recordings  = "E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1\average butterworth";
    % z_score_dir = "E:\2024-11-26_15-42-34__Steven "+string(i)+" Z Score";
    % 
    spikes_per_chan_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\spikes_per_channel_2");
    dir_with_index_masks = "E:\Steven\2024-11-26_15-42-34__Steven "+string(i)+" Raw Recordings Indexes Without artifacts";
    spikes_per_channel = detect_spikes_ver_3(list_of_channels,dir_with_channel_recordings,dir_with_index_masks);
    spikes_per_recording_2{i} = spikes_per_channel;
    save(spikes_per_chan_dir+"\spikes_per_channel.mat","spikes_per_channel");

    spike_windows_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\spike_windows_2");
    spike_windows = get_spike_windows_ver_3(list_of_channels,spikes_per_channel,min_z_score,num_dps,dir_with_channel_recordings);
    %each array is made up of 4 numbers:
    %the first is the beginning of the spike window
    %the second is the end of the spike_window
    %the third is the original channel of the spike
    %the fourth is the original the peak of the spike according to find_peaks

end
%% run the find peaks using minimum z score instead of amplitude and getting the datapoints
clc;
close all;
num_dps=50;
spikes_per_recording_2 = cell(1,3);
list_of_channels = strcat("c",string(1:384));
precomputed_dir = "E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1";
original_data_size = 52891792;
time_delta = 1/30000;
timestamps = linspace(1*time_delta,original_data_size*time_delta,original_data_size);
min_z_score = 1;
time_interval = 1;
for i=1:1.5
    % 
    dir_with_channel_recordings  = "E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1\average butterworth";
    % z_score_dir = "E:\2024-11-26_15-42-34__Steven "+string(i)+" Z Score";
    % 
    spikes_per_chan_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\spikes_per_channel_using_min_z_score");
    dir_with_index_masks = "E:\Steven\2024-11-26_15-42-34__Steven "+string(i)+" Raw Recordings Indexes Without artifacts";
    spikes_per_channel = detect_spikes_ver_4(list_of_channels,dir_with_channel_recordings,dir_with_index_masks,min_z_score,timestamps,time_interval);
    spikes_per_recording_2{i} = spikes_per_channel;
    save(spikes_per_chan_dir+"\spikes_per_channel.mat","spikes_per_channel");

    spike_windows_dir_using_min_z_score = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\spike_windows_using_min_z_score");
    spike_windows_using_min_z_score = get_spike_windows_ver_3(list_of_channels,spikes_per_channel,min_z_score,num_dps,dir_with_channel_recordings);
    %each array is made up of 4 numbers:
    %the first is the beginning of the spike window
    %the second is the end of the spike_window
    %the third is the original channel of the spike
    %the fourth is the original the peak of the spike according to find_peaks

end
%%
for j=1:length(spike_windows)
    something = spike_windows{i};
    save(spike_windows_dir+"\c"+string(j)+" spike_windows.mat","something");
    disp("Finished "+string(j)+"/384")
end
%% run the figure generation of continous filtered
clc;
list_of_channels = strcat("c"+string(2));
for i=1:length(list_of_channels)
    oebinFilePath = "D:\Ephys Data\Electrophysiology Data (OpenEphys)\Steven\2024-11-26_15-42-34__Steven\Record Node 103\experiment1\recording"+string(i)+"\structure.oebin";
    fileID = fopen(oebinFilePath, 'r');
    rawData = fread(fileID, inf, 'uint8=>char')';
    fclose(fileID);

    % Parse the JSON content
    oebinStruct = jsondecode(rawData);
    struct_with_bit_volts = oebinStruct.continuous.channels;
    bit_volts = [struct_with_bit_volts(:).bit_volts];
    bit_volts(:) = 1;

    dir_with_channel_recordings  = "E:\Steven\2024-11-26_15-42-34__Steven 1 Filtered\average butterworth";
    %timestamps = node.recordings{i}.continuous('Neuropix-PXI-100.ProbeA-AP').timestamps;
    timestamps = -1;
    display_the_spike_traces_and_examples(dir_with_channel_recordings,timestamps,list_of_channels,bit_volts);
end


%% EXAMPLE CHANNEL run the figure generation of cut spikes
clc;
list_of_channels = strcat("c",string([33]));
close all;
for i=1:1.5
    oebinFilePath = "D:\Ephys Data\Electrophysiology Data (OpenEphys)\Steven\2024-11-26_15-42-34__Steven\Record Node 103\experiment1\recording"+string(i)+"\structure.oebin";
    fileID = fopen(oebinFilePath, 'r');
    rawData = fread(fileID, inf, 'uint8=>char')';
    fclose(fileID);

    % Parse the JSON content
    oebinStruct = jsondecode(rawData);
    struct_with_bit_volts = oebinStruct.continuous.channels;
    bit_volts = [struct_with_bit_volts(:).bit_volts];
    bit_volts(:) = 1;
    dir_with_channel_recordings  = "E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1\average butterworth";
    %timestamps = node.recordings{i}.continuous('Neuropix-PXI-100.ProbeA-AP').timestamps;
    %spike_windows = importdata("E:\2024-11-26_15-42-34__Steven Precomputed "+string(i)+"\spike_windows min_z_score 5 num dps 60\spike_windows.mat");
    timestamps = -1;
    current_spike_windows = importdata("E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1\spike_windows\spike_windows.mat");
    dir_with_og_idx = "E:\Steven\2024-11-26_15-42-34__Steven Artifact Removed Recordings "+string(i);
    time_to_start_plotting_spikes_at = 150; %in seconds
    single_plot = false;
    how_many_spikes = 20;
    how_many_to_cut = 4;
    plot_individual_spikes_from_open_ephys(dir_with_channel_recordings,current_spike_windows,list_of_channels,time_to_start_plotting_spikes_at,single_plot,how_many_spikes,how_many_to_cut);
end
%% PLOT Nearest Spikes To Each other
clc;
close all;
original_data_size = 52891792;
time_delta = 1/30000;
timestamps = linspace(1*time_delta,original_data_size*time_delta,original_data_size);
channels_to_plot = [33 37 30 31 32 34 35 36] ;
time_to_start_plotting = 10;
min_amp = 80;
lag_in_seconds = 0.0001;
number_of_dpts_to_plot =40;
dir_with_recordings ="E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1\average butterworth";
plot_spikes_nearest_to_each_other(spikes_per_channel,channels_to_plot,time_to_start_plotting,min_amp,lag_in_seconds,number_of_dpts_to_plot,timestamps,dir_with_recordings)
%% EXAMPLE CHANNEL plot neighbors
clc;
list_of_channels = strcat("c",string([37 36 38 132 133]));
%close all;
for i=1:1.5
    oebinFilePath = "D:\Ephys Data\Electrophysiology Data (OpenEphys)\Steven\2024-11-26_15-42-34__Steven\Record Node 103\experiment1\recording"+string(i)+"\structure.oebin";
    fileID = fopen(oebinFilePath, 'r');
    rawData = fread(fileID, inf, 'uint8=>char')';
    fclose(fileID);

    % Parse the JSON content
    oebinStruct = jsondecode(rawData);
    struct_with_bit_volts = oebinStruct.continuous.channels;
    bit_volts = [struct_with_bit_volts(:).bit_volts];
    bit_volts(:) = 1;
    dir_with_channel_recordings  = "E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1\average butterworth";
    %timestamps = node.recordings{i}.continuous('Neuropix-PXI-100.ProbeA-AP').timestamps;
    %spike_windows = importdata("E:\2024-11-26_15-42-34__Steven Precomputed "+string(i)+"\spike_windows min_z_score 5 num dps 60\spike_windows.mat");
    timestamps = -1;
    %current_spike_windows = importdata("E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1\spike_windows\spike_windows.mat");
    current_spike_windows = spike_windows;
    dir_with_og_idx = "E:\Steven\2024-11-26_15-42-34__Steven Artifact Removed Recordings "+string(i);
    time_to_start_plotting_spikes_at = 1; %in seconds
    single_plot = false;
    how_many_spikes = 20;
    how_many_to_cut = 4;
    plot_individual_spikes_plus_neighbors(dir_with_channel_recordings,current_spike_windows,list_of_channels,time_to_start_plotting_spikes_at,how_many_to_cut);
end

%% EXAMPLE PLOTS: plot continuous recording over specified interval
clc;
close all;
channels_to_use = strcat("c",string([30 31 32 33 34 35 36]));
dir_with_raw_recordings ="E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1\average butterworth";
time_bounds = [1400,1400.25];
original_data_size = 52891792;
dir_with_og_indexes = "E:\Steven\2024-11-26_15-42-34__Steven 1 Raw Recordings Indexes Without artifacts";
display_the_spike_traces_over_specified_interval_and_channels(dir_with_raw_recordings,channels_to_use,dir_with_og_indexes,time_bounds,original_data_size);

%% Get dictionaries for example tetrode
clc;
original_data_size = 52891792;
art_tetr_array = build_artificial_tetrode_real_data();
% art_tetr_array = art_tetr_array(1:5,:);
% art_tetr_array = [31 33 35 37];
%spikes_per_channel = importdata("E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1\spikes_per_channel min_z_score 5\spikes_per_channel.mat");
%spike_windows_for_example = importdata("E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1\spike_windows\spike_windows.mat");
time_delta = 1/30000;
precomputed_dir = "E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1";
timestamps = linspace(1*time_delta,original_data_size*time_delta,original_data_size);
dictionaries_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\dictionaries Min Amp 40 using min z score");
dir_with_channel_recordings = "E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1\average butterworth";
[all_spike_tetrode_dictionary] =get_dictionaries_of_all_spikes_ver_4(art_tetr_array,spike_windows_using_min_z_score,dir_with_channel_recordings,timestamps,50,1,dictionaries_dir);

%
%% plot the spikes
clc;
close all;
art_tetr_array = build_artificial_tetrode_real_data();
% art_tetr_array = [31 33 35 37];
dir_with_spikes_dicts = "E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1\dictionaries Min Amp 40\";
dir_with_spikes_dicts = "E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1\dictionaries Min Amp 40 using min z score\";
dir_to_save_plots_to = "E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1\Raw Tetrode Plots Z Score Vs Z Score With Whitening";
dir_to_save_plots_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_plots_to);
config = spikesort_config; %load the config file;
config = config.spikesort;
number_of_stds_above_mean = 0;
with_whitening_filter = true;
plot_the_raw_spike_data_with_whitening_filter(art_tetr_array,dir_with_spikes_dicts,dir_to_save_plots_to,config,channel_wise_means{1},channel_wise_stds{1},number_of_stds_above_mean,with_whitening_filter);
%% run the clustering algorithm and see what we get
clc;
list_of_desired_tetrodes = ["t1","t2","t3","t4"];
channel_wise_means_for_current_tetrode_example = channel_wise_means{1};
channel_wise_std_for_current_tetrode_example = channel_wise_stds{1};
number_of_std_above_means = .2;
blind_pass_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\Example Blind Pass");
blind_pass_results_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\Example Blind Pass Results");

[output_array,aligned_array,timestamps_array] =run_clustering_algorithm_on_desired_tetrodes_ver_3(list_of_desired_tetrodes, ...
    channel_wise_means_for_current_tetrode_example, ...
    channel_wise_std_for_current_tetrode_example, ...
    number_of_std_above_means,dir_with_channel_recordings,dictionaries_dir,blind_pass_dir,blind_pass_results_dir);
%% plot the results of the test tetrode

clc;
close all;
figure;
output = output_array{tetrode_to_use};
aligned = aligned_array{tetrode_to_use};
channels_of_curr_tetr =art_tetrode_array(tetrode_to_use,:);
idx = extract_clusters_from_output(output(:,1),output,spikesort_config);
%plot the data without filters
plot_counter =1;
for first_dimension = 1:length(channels_of_curr_tetr)
    for second_dimension = first_dimension+1:length(channels_of_curr_tetr)
        subplot(2,3,plot_counter);
        new_plot_proj_ver_4(idx,aligned,first_dimension,second_dimension,channels_of_curr_tetr,"","",plot_counter);
        plot_counter = plot_counter+1;
    end
end

%% Plot Aligned Spike channels 33
close all;
clc;
spike_dictionary = importdata("E:\Steven\2024-11-26_15-42-34__Steven Precomputed 1\dictionaries Min Amp 40\t16 spike_tetrode_dictonary.mat");
spikes = spike_dictionary("t16");
%%
close all;
aligned = align_to_peak(spikes,1,1);

spikes_of_channel_33 = squeeze(aligned(1,:,:));
% spikes_of_channel_33 = spikes_of_channel_33.';
figure;
spikes_of_channel_33_min_amp = find(spikes_of_channel_33(:,20) > 80);
plot(spikes_of_channel_33(spikes_of_channel_33_min_amp,:).');
hold on;
mean_spike_waveform = mean(spikes_of_channel_33(spikes_of_channel_33_min_amp,:),1);
plot(mean_spike_waveform,"LineWidth",6)
title("Channel 31")

spikes_of_channel_33 = squeeze(aligned(2,:,:));
% spikes_of_channel_33 = spikes_of_channel_33.';
figure;
spikes_of_channel_33_min_amp = find(spikes_of_channel_33(:,20) > 80);
first_10_percent_of_plots = spikes_of_channel_33_min_amp(1:ceil(length(spikes_of_channel_33_min_amp)/10));
plot(spikes_of_channel_33(first_10_percent_of_plots,:).');
hold on;
%mean_spike_waveform = mean(spikes_of_channel_33(spikes_of_channel_33_min_amp,:),1);
%plot(mean_spike_waveform,"LineWidth",6)
title("Channel 33")

spikes_of_channel_33 = squeeze(aligned(3,:,:));
% spikes_of_channel_33 = spikes_of_channel_33.';
figure;
spikes_of_channel_33_min_amp = find(spikes_of_channel_33(:,20) > 80);
plot(spikes_of_channel_33(spikes_of_channel_33_min_amp,:).');
hold on;
%mean_spike_waveform = mean(spikes_of_channel_33(spikes_of_channel_33_min_amp,:),1);
%plot(mean_spike_waveform,"LineWidth",6)
title("Channel 35")

spikes_of_channel_33 = squeeze(aligned(4,:,:));
% spikes_of_channel_33 = spikes_of_channel_33.';
figure;
spikes_of_channel_33_min_amp = find(spikes_of_channel_33(:,20) > 80);
first_10_percent_of_plots = spikes_of_channel_33_min_amp(1:ceil(length(spikes_of_channel_33_min_amp)/10));
plot(spikes_of_channel_33(first_10_percent_of_plots,:).');
hold on;
%mean_spike_waveform = mean(spikes_of_channel_33(spikes_of_channel_33_min_amp,:),1);
%plot(mean_spike_waveform,"LineWidth",6)
title("Channel 37")

