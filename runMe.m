%% Add Utility functions to your padd
cd("Utility Functions\");
addpath(pwd);
cd("..");
%% read binary data used in kilosort
clc;
fn = pwd + "\Data\Data Sample From Kilosort\rawDataSample.bin";
fid = fopen(fn,'r');
dat = fread(fid,[385 inf], '*int16');
fclose(fid);
chanMap = readNPY('channel_map.npy');
dat = dat(chanMap+1,:);
%% do stuff for kilosort
plot_n_channels(dat,5,pwd+"\figures\Kilosort_Channels")

%% Read Some Bindary data
% Ask user for binary file
%[binName,path] = uigetfile('*.bin', 'Select Binary File');

binName = "SalineTest_run_24-7-2024_g1_t0.imec0.ap.bin";
path = 'C:\Users\ldd77\OneDrive\Desktop\spike_detection_work\Data\SalineTest_run_24-7-2024_g1_imec0\';

%% get data from the binary files
clc;
[data_from_binary_file,std_dvns_per_channel,means_per_channel,z_scores_per_channel] = read_data_from_binary_file(path,binName,4,"all",0,pwd+"\Figures\Testing1","A");

%% get min/max z-score per channel
[min_z_scores_per_channel,max_z_score_per_channel] = bounds(z_scores_per_channel,2);
figure;
bar([min_z_scores_per_channel,max_z_score_per_channel]);
legend("Min","Max")
xlabel("Channel")
ylabel("Z-score")
%% get peaks (local maxima) of the input signal, the indices at which the peak occur,the width of of the peaks, and promincences of the peaks
channel = 1;
number_of_seconds = 0.05;
[pks,locs,w,p] = findpeaks(data_from_binary_file(channel,1:number_of_seconds*30000),30000,"MinPeakDistance",0.005);
figure();
data_to_plot = data_from_binary_file(channel,1:number_of_seconds*30000);
plot(data_to_plot);
findpeaks(data_from_binary_file(channel,1:number_of_seconds*30000),30000,'MinPeakDistance',0.005);
xlabel("time (in \mus)");
ylabel("voltage");
hold on;
title("From 0 to 0.05 seconds For Channel " +string(channel));
text(locs+0.002,pks,num2str(p'))

%% look at multiple channels over the same 
number_of_seconds = 0.05;
fig = figure;
for channel=1:5
    subplot(5,1,channel);
    [pks,locs,w,p] = findpeaks(data_from_binary_file(channel,1:number_of_seconds*30000),30000,"MinPeakDistance",0.005);
    data_to_plot = data_from_binary_file(channel,1:number_of_seconds*30000);
    plot(data_to_plot);
    findpeaks(data_from_binary_file(channel,1:number_of_seconds*30000),30000,'MinPeakDistance',0.005);
    % xlabel("time (in \mus)");
    % ylabel("voltage");
    hold on;
    title("Channel " + string(channel));
    text(locs+0.0002,pks,num2str(p'))
end
han=axes(fig,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Voltage');
xlabel(han,'Time (in \mus)');
sgtitle('From 0 to 0.05 seconds');

%% 

channel = 1;
[pks,locs,w,p] = findpeaks(data_from_binary_file(channel,:),30000,"MinPeakDistance",0.005);
figure();
data_to_plot = data_from_binary_file(channel,:);
plot(data_to_plot);
findpeaks(data_from_binary_file(channel,:),30000,'MinPeakDistance',0.005);
xlabel("time (in \mus)");
ylabel("voltage");
title("All Data From Channel" + string(channel));
hold on;
text(locs+0.002,pks,num2str(p'))
%% load the raw recordings & timestamps
load(pwd+"\Data\60 Second Raw Recording\Timestamps_for_60_second_recording.mat");
load(pwd+"\Data\60 Second Raw Recording\Channels_for_60_second_recording.mat");
load(pwd+"\Data\Ground Truth 60 Second\ground_truth_for_60_second_recording.mat")
% recording has n rows depending on how long it is
% recording has 384 columns, 1 column per channel
% timestamps is 1 row with n cols, it has the same number of cols and recording has rows.

%% get the means per channel, the std deviations per channel, and the z-score for every value
channel_wise_means = calculate_the_mean_per_channel(Recordings);
channel_wise_std = calculate_the_std_per_channel(Recordings);
channel_wise_z_scores = calculate_the_z_score_for_every_value(Recordings);
recording_with_mean_removed = remove_average_from_all_channels(Recordings,channel_wise_means);
%% plot ground truth
close all;
plot_ground_truth(ground_truth);
%% create artificial_tetrodes first pass, 
clc;
art_tetr_array = build_artificial_tetrode;

%%
                 %<3 causes out of memory error
                 %=3 causes every tetrode to have spikes (should be impossible when there are only 10 neurons)
                 %=4 causes every tetrode to have spikes (should be impossible 
                 %=5 causes 87 tetrodes which will cause 87 non empty tetrodes (better but still too much) 
                 %=6 creates huge jump to only 43 non empty tetrodes, so I think that this is the minimum needed to get ride of noise
                 %=10 only 21 active tetrodes, which is probably too few given that we have 10 neurons 
min_z_score = 6; 
num_dps = 32;
recording_with_mean_removed_and_min_z_score_filter = zero_out_values_that_dont_meet_min_z_score(recording_with_mean_removed,channel_wise_z_scores,min_z_score);
spikes_per_channel = detect_spikes(recording_with_mean_removed_and_min_z_score_filter);

% get spike windows
spike_windows = get_spike_windows(channel_wise_z_scores,spikes_per_channel,min_z_score,num_dps);
%each array is made up of 4 numbers:
                %the first is the beginning of the spike window
                %the second is the end of the spike_window
                %the third is the original channel of the spike
                %the fourth is the original the peak of the spike according to find_peaks
% get maps of each tetrode to its spikes
[tetrode_dictionary,spike_tetrode_dictionary,timing_tetrode_dictionary,channel_to_tetrode_dictionary,spiking_channel_tetrode_dictionary,spike_tetrode_dictionary_samples_format] = get_dictionaries_of_all_spikes(art_tetr_array,spike_windows,Recordings,timestamps,num_dps);
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
%%

[output_array,aligned_array,reg_timestamps_array] = run_clustering_algorithm_on_desired_tetrodes();
 
 %% get some data out of my maps
%tetrode = "t" + channel_to_tetrode_dictionary("c319");
tetrode = "t92"'
tetrode = "t93";
channels_in_current_tetrode = tetrode_dictionary(tetrode);
raw = spike_tetrode_dictionary(tetrode);
raw = raw *-1;
raw_in_samples_format = spike_tetrode_dictionary_samples_format(tetrode);
raw_in_samples_format = raw_in_samples_format *-1;


mean_of_relevant_channels = channel_wise_means(channels_in_current_tetrode);
std_dvns_of_relevant_channels = channel_wise_std(channels_in_current_tetrode);

wire_filter = find_live_wires(raw);
nonzero_samples =raw_in_samples_format(:,wire_filter,:);
minpeaks = shiftdim(min(max(nonzero_samples),[],2),2);
maxvals = shiftdim(max(min(nonzero_samples),[],2),2);
admax_val = 32767;
good_spike_filter = minpeaks<admax_val & maxvals > (-admax_val);
good_spike_idx = find(good_spike_filter);

timestamps_for_current_tetrode = timing_tetrode_dictionary(tetrode);

ir = calculate_input_range_for_raw_by_channel(raw);
ir = abs(ir(:,1) - ir(:,2));
tvals = mean_of_relevant_channels + (std_dvns_of_relevant_channels * 3); % get the threshold of the chanels
tvals = tvals.';
filenames = ["firstTetrode.mat"]; %dont care 
config = spikesort_config(); %load the config file


clc;
% close all;
[output, aligned, reg_timestamps] = run_spikesort_ntt_core_ver2(raw, timestamps_for_current_tetrode, good_spike_idx, ir, tvals, filenames, config,channels_in_current_tetrode);
%%
disp(channels_in_current_tetrode)
load("firstTetrode.mat")
idx = extract_clusters_from_output(output(:,1),output,config);
plot_clusters(idx,raw,tvals,ir,grades)
channel_string = "";
for i=1:length(channels_in_current_tetrode)
    channel_string = channel_string + " C"+string(channels_in_current_tetrode(i));
end
sgtitle([tetrode,channel_string])
%%
% tetrode = "t4";
% channels_in_current_tetrode = tetrode_to_channel_dictionary(tetrode);
% raw = tetrode_to_spikes_dictionary(tetrode);
% raw_in_samples_format = tetrode_to_spikes_dictionary_samples_format(tetrode);
% mean_of_relevant_channels = mean_of_channels(channels_in_current_tetrode);
% std_dvns_of_relevant_channels = standard_deviations_of_channels(channels_in_current_tetrode);
% 
% wire_filter = find_live_wires(raw);
% nonzero_samples =raw_in_samples_format(:,wire_filter,:);
% minpeaks = shiftdim(min(max(nonzero_samples),[],2),2);
% maxvals = shiftdim(max(min(nonzero_samples),[],2),2);
% admax_val = 32767;
% good_spike_filter = minpeaks<admax_val & maxvals > (-admax_val);
% good_spike_idx = find(good_spike_filter);
% run_spikesort_ntt_core_ver2(raw, timestamps, good_spike_idx, ir, tvals, filenames, config,channels_in_current_tetrode)
% 
% timestamps = tetrode_to_spike_timestamps_dictionary(tetrode);
% 
% ir = calculate_input_range_for_raw_by_channel(raw);
% ir = abs(ir(:,1) - ir(:,2));
% tvals = mean_of_relevant_channels + (std_dvns_of_relevant_channels * 6);
% filenames = ['','',''];
% config = spikesort_config();
%% NO LONGER USED
% %% read the json files 
array_of_return_dictionaries = read_json_artificial_tetrodes_into_memory(pwd+"\Data\Second Set Of Dictionaries");
% %% Read the Recordings dictionaries into memory
% array_of_return_dictionaries = read_json_artificial_tetrodes_into_memory_ver_2(pwd+"\Data\60 Second Dictionaries");
% 
% %% Extract some of the dictionaries into local variables 
% tetrode_to_spikes_dictionary = array_of_return_dictionaries{3};
% % the key of this is all the tetrodes, each tetrode is preceeded by "t", for instance it'll be "t1" will be tetrode 1
% % the value is all the y-points for all found in the tetrode, these are sorted
% tetrode_to_spike_timestamps_dictionary = array_of_return_dictionaries{6};
% %the key is the same as the keys of tetrode_to_spikes_dictionary
% %the values are the timestamps for each spike in each tetrode
% 
% tetrode_to_spikes_dictionary_samples_format = array_of_return_dictionaries{7};
% %the same thing as tetrodetospikes_dictionary, but permutted differently 
% 
% channel_to_tetrode_dictionary = array_of_return_dictionaries{1};
% %the key of this is the channel is a string c+"n", where n is the number of channels
% %the value is what tetrode that channel belongs to 
% 
% tetrode = "t" + channel_to_tetrode_dictionary("c289");
% 
% tetrode_to_channel_dictionary = array_of_return_dictionaries{5};
% % the key of this is all the tetrodes, each tetrode is preceeded by "t", for instance it'll be "t1" will be tetrode 1
% % the value is all the channels which are in the tetrode
% % for example t1: [1;2;98;98]