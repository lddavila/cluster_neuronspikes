%% STEP 1: Add Utility functions to your path
cd("Utility Functions\");
addpath(pwd);
cd("..");
cd("clustering-master\")
addpath(genpath(pwd));
cd("..")

%% plot ground truth
close all;
plot_ground_truth(ground_truth_array,10);
%% id unique clusters in initial pass
clc;
close all;
dir_with_nth_pass_results = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\100 Neuron 300 Second Pre Computed\initial_pass_results";
[unique_clusters,associated_tetrodes]= id_unique_clusters_in_nth_pass(dir_with_nth_pass_results,0.05,70);
disp(size(unique_clusters))
%% test to see which of the clusters contain a good percentage of ground truth timestamps
clc
compare_timestamps_to_ground_truth(ground_truth_array,unique_clusters,timestamps,2);
%% cull noise clusters
clc;
close all;
plot_the_og_output=1;
grade_threshold = 1;
less_than_or_greater = 0;
possible_variables = ["OG tetrode","tightness","%Short ISI","Incompleteness","Template Matching","Min Bhat"];
dir_with_nth_pass_results = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\100 Neuron 300 Second Pre Computed\initial_pass_results";
dir_with_nth_pass_grades = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\100 Neuron 300 Second Pre Computed\initial_pass";
condition_names_to_use = ["tightness","Template Matching","Min Bhat"];
conditions = ["<","<",">"];
values_to_compare_against = [0.1, 2, 1];
min_amplitude = 60;
cull_noise_clusters_ver_2(unique_clusters,associated_tetrodes,dir_with_nth_pass_grades,dir_with_nth_pass_results,plot_the_og_output,condition_names_to_use,conditions,values_to_compare_against,60);
%% Work with ground truths
ordered_list_of_channels = get_ordered_list_of_channel_names();
ground_truth_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 Second Recording Ground Truth";
ground_truth_array = load_ground_truth_into_data(ground_truth_dir);
dir_with_channel_recordings = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 Second Recording Level 3 Noise";
dir_with_peaks_per_channel = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 second peaks_per_channel";
dir_with_neurons_to_possible_channels = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 second neuron_to_possible_channels";

peaks_per_channel = run_find_peaks_on_every_channel(dir_with_channel_recordings,ordered_list_of_channels,1,dir_with_peaks_per_channel);
neurons_to_possible_channels = compare_ground_truth_to_peaks_per_channel(peaks_per_channel,ground_truth_array,.99,1,dir_with_neurons_to_possible_channels);

clc;
close all;
plot_around_peaks(neurons_to_possible_channels("1"),dir_with_channel_recordings,ground_truth_array{1},5)
my_perfect_tetrode = [25 26 27 28 122 219 314 315];

%% 
close all;
clc;
scale_factor = -1;
dir_with_channel_recordings = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 Second Recording Level 3 Noise";
min_z_score = 4;
min_threshold = 20;
num_dps = 60;
timestamps_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 second timestamps";
create_z_score_matrix = 0;
dir_to_save_everything_to = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 Second Data";
precomputed_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 Second Precomputed Data";
what_is_precomputed = ["z_score","mean_and_std", "spikes_per_channel 3","spike_windows min_z_score 4 num dps 60","spikes_per_channel min_z_score 4","dictionaries min_z_score 4 num_dps 60"];
what_is_precomputed = run_entire_clustering_algorithm_ver_2(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold);
%% plot the graph of the probe
create_graph_object_representing_probe();
%% run spike detection for 50 neuron recording
close all;
clc;
scale_factor = -1;
dir_with_channel_recordings = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\50 Neuron 300 Second Recording Level 3 Noise";
min_z_score = 4;
min_threshold = 20;
num_dps = 60;
timestamps_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 second timestamps";
create_z_score_matrix = 0;
dir_to_save_everything_to = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\50 Neuron 300 Second";
precomputed_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\50 Neuron 300 Second Pre Computed";
what_is_precomputed = ["z_score","mean_and_std", "spikes_per_channel 3","spike_windows min_z_score 4 num dps 60","spikes_per_channel min_z_score 4", "dictionaries min_z_score 4 num_dps 60"];
size_of_tetrode = 4;
what_is_precomputed = run_entire_clustering_algorithm_ver_3(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode);

%% now test how adding new channels will affect the clustering results of 50 neuron recording
close all;
clc;
art_tetr_array = build_artificial_tetrode;
array_of_desired_tetrodes = get_array_of_all_tetrodes_which_contain_given_channel(345,art_tetr_array);
tetrode_you_want_to_load = array_of_desired_tetrodes(1);
channels_in_current_tetrode = art_tetr_array(str2double(erase(tetrode_you_want_to_load,"t")),:);
dir_with_tetrode_initial_pass_grades = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\50 Neuron 300 Second Pre Computed\initial_pass" ;
dir_with_tetrode_initial_pass_results = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\50 Neuron 300 Second Pre Computed\initial_pass_results";
dir_to_save_sub_tetrodes_to = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\50 Neuron 300 Second Pre Computed\sub_tetrode_results";

neighbors_of_current_tetrode = find_valid_neighbors(channels_in_current_tetrode);
scale_factor = -1;
dir_with_channel_recordings = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\50 Neuron 300 Second Recording Level 3 Noise";
min_z_score = 4;
min_threshold = 20;
num_dps =60;
timestamps_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 second timestamps";
precomputed_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\50 Neuron 300 Second Pre Computed";
run_second_stage_of_clustering(dir_with_tetrode_initial_pass_grades,dir_with_tetrode_initial_pass_results,neighbors_of_current_tetrode,channels_in_current_tetrode,tetrode_you_want_to_load,dir_to_save_sub_tetrodes_to,dir_with_channel_recordings,scale_factor,min_z_score,num_dps,timestamps_dir,precomputed_dir,min_threshold);

%% run the second stage en masse
clc;
results_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\50 Neuron 300 Second Pre Computed (1)\initial_pass_results" ;
list_of_initial_tetrodes = strcat("t",string(1:285));
number_of_channels_to_add =2 ;
scale_factor = 1;
dir_with_channel_recordings = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\50 Neuron 300 Second Recording Level 3 Noise";
min_z_score = 4;
min_threshold = 20;
num_dps = 60;
timestamps_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 second timestamps" ;
precomputed_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\50 Neuron 300 Second Pre Computed (1)";

pass_number = 2;

run_second_pass_of_clustering(results_dir,list_of_initial_tetrodes,number_of_channels_to_add,scale_factor,dir_with_channel_recordings,min_z_score,min_threshold,num_dps,timestamps_dir,precomputed_dir,pass_number)

%% manually test different cases 
manually_made_tetrode = [294,198];
scale_factor = -1;
dir_with_channel_recordings = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\50 Neuron 300 Second Recording Level 3 Noise";
min_z_score = 4;
num_dps = 60;
timestamps_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 second timestamps" ;
precomputed_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\50 Neuron 300 Second Pre Computed (1)";
what_is_precomputed = ["z_score","mean_and_std", "spikes_per_channel 3","spike_windows min_z_score 4 num dps 60","spikes_per_channel min_z_score 4", "dictionaries min_z_score 4 num_dps 60"];
min_threshold = 20;
size_of_tetrode = length(manually_made_tetrode);
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode)
%% now test how adding new channels will affect the clustering results
close all;
tetrode_you_want_to_load = "t157";
channels_in_current_tetrode = [53 54 149 150];
dir_with_tetrode_initial_pass_grades = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 Second Precomputed Data\initial_pass";
dir_with_tetrode_initial_pass_results = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 Second Precomputed Data\initial_pass_results";
dir_to_save_sub_tetrodes_to = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 Second Precomputed Data\sub_tetrode_results";
neighbors_of_current_tetrode = find_valid_neighbors(channels_in_current_tetrode);
scale_factor = -1;
dir_with_channel_recordings = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 Second Recording Level 3 Noise";
min_z_score = 4;
min_threshold = 20;
num_dps = 60;
timestamps_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 second timestamps";
create_z_score_matrix = 0;
dir_to_save_everything_to = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 Second Data";
precomputed_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 Second Precomputed Data";
what_is_precomputed = ["z_score","mean_and_std", "spikes_per_channel 3","spike_windows min_z_score 4 num dps 60","spikes_per_channel min_z_score 4","dictionaries min_z_score 4 num_dps 60"];
run_second_stage_of_clustering(dir_with_tetrode_initial_pass_grades,dir_with_tetrode_initial_pass_results,neighbors_of_current_tetrode,channels_in_current_tetrode,tetrode_you_want_to_load,dir_to_save_sub_tetrodes_to,dir_with_channel_recordings,scale_factor,min_z_score,num_dps,timestamps_dir,precomputed_dir,min_threshold);

%% 
initial_results_dir ="C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 Second Precomputed Data\initial_pass";
ordered_list_of_first_pass_tetrodes = get_ordered_list_of_tetrodes(size(ls(initial_results_dir+"\*.mat"),1));


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
    [pks,locs,w,p] = findpeacks(data_from_binary_file(channel,1:number_of_seconds*30000),30000,"MinPeakDistance",0.005);
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
% [pks,locs,w,p] = findpeaks(data_from_binary_file(channel,:),30000,"MinPeakDistance",0.005);
% figure();
% data_to_plot = data_from_binary_file(channel,:);
% plot(data_to_plot);
% findpeaks(data_from_binary_file(channel,:),30000,'MinPeakDistance',0.005);
% xlabel("time (in \mus)");
% ylabel("voltage");
% title("All Data From Channel" + string(channel));
% hold on;
% text(locs+0.002,pks,num2str(p'))
%%% load the raw recordings & timestamps
%load(pwd+"\Data\60 Second Raw Recording\Timestamps_for_60_second_recording.mat");
%load(pwd+"\Data\60 Second Raw Recording\Channels_for_60_second_recording.mat");
load(pwd+"\Data\Ground Truth 60 Second\ground_truth_for_60_second_recording.mat")
%% Step 2: Get ordered List of Channels
ordered_list_of_channels = get_ordered_list_of_channel_names();
% 
 %% load the raw recordings as tall arrays 
 %data_dir = pwd+"\Data\500 Second Recordings 2";
 %tall_array_of_recordings = load_all_the_recordings_into_tall_array(data_dir);
 %tall_array_of_recordings is a tall array of structs which contain the channel readings 
 %there should be 384 structs provided that everything was extracted properly
 %each struct will have a single field which is the name of the channel 
    %ex) c1, c2, c3

%% step 3: get the mean and std of all channels
clc;

scale_factor = -1;
z_score_dir = pwd+"\Data\"+string(scale_factor)+" Scaled Z_scores for 500 Second Recording";
data_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 Second Recording Level 3 Noise";
[channel_wise_means,channel_wise_std] = get_channel_wise_statistics(ordered_list_of_channels,"C:\Users\ldd77\OneDrive - The University of Texas at El Paso\500 Second Recordings 3",z_score_dir,0,scale_factor);
% z_score_dir ="C:\Users\ldd77\OneDrive\Desktop\cluster_neuronspikes\Data\Z_scores for 500 Second Recording" ;
%there is 1 mean per channel and 1 std dvn per channel

%% load the data as raw array

% recording has n rows depending on how long it is
% recording has 384 columns, 1 column per channel
% timestamps is 1 row with n cols, it has the same number of cols and recording has rows.

%% get the means per channel, the std deviations per channel, and the z-score for every value
%% plot ground truth
close all;
plot_ground_truth(ground_truth_array);
%% step 4: create artificial_tetrodes first pass, 
clc;
art_tetr_array = build_artificial_tetrode;

%% step 5: get potential spikes from continuous recordings
                 %<3 causes out of memory error
                 %=3 causes every tetrode to have spikes (should be impossible when there are only 10 neurons)
                 %=4 causes every tetrode to have spikes (should be impossible 
                 %=5 causes 87 tetrodes which will cause 87 non empty tetrodes (better but still too much) 
                 %=6 creates huge jump to only 43 non empty tetrodes, so I think that this is the minimum needed to get ride of noise
                 %=10 only 21 active tetrodes, which is probably too few given that we have 10 neurons 
min_z_score = 6; 
num_dps = 60;
% recording_with_mean_removed_and_min_z_score_filter = zero_out_values_that_dont_meet_min_z_score(recording_with_mean_removed,channel_wise_z_scores,min_z_score);
spikes_per_channel = detect_spikes_ver_2(ordered_list_of_channels,data_dir,z_score_dir,min_z_score,scale_factor);

%% step 6; Get all the data points from the potential spikes
spike_windows = get_spike_windows_ver_2(ordered_list_of_channels,spikes_per_channel,min_z_score,num_dps,z_score_dir);
%each array is made up of 4 numbers:
                %the first is the beginning of the spike window
                %the second is the end of the spike_window
                %the third is the original channel of the spike
                %the fourth is the original the peak of the spike according to find_peaks
%% find which channel has max amplitudes
clc;
[channel_with_max_value,the_max_value]= channel_with_max_value(ordered_list_of_channels,data_dir);
disp("Channel with max value:" + string(channel_with_max_value));           
disp("The Max Value:" + string(the_max_value));
%% step 7: load the timestamps into memory
timestamps = importdata(pwd+"\Data\500 Second Timestamps\timestamps.mat");
%% step 8: get maps of each tetrode to its spikes
clc;
[tetrode_dictionary,spike_tetrode_dictionary,timing_tetrode_dictionary,channel_to_tetrode_dictionary,spiking_channel_tetrode_dictionary,spike_tetrode_dictionary_samples_format] = get_dictionaries_of_all_spikes_ver_2(art_tetr_array,spike_windows,data_dir,timestamps,num_dps,scale_factor);
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

%% Step 9: Plot Some Spikes (for debugging, can be skipped) 
close all;
clc;
save_dir = pwd+"\Data\"+"Scale Factor "+string(scale_factor)+" "+string(num_dps)+" DPs Figures";
array_of_desired_tetrodes = get_array_of_all_tetrodes_which_contain_given_channel(24,art_tetr_array);

plot_detected_spikes_of_tetrode(array_of_desired_tetrodes,10,spike_tetrode_dictionary,timing_tetrode_dictionary,tetrode_dictionary,spiking_channel_tetrode_dictionary,save_dir);
%%
concatenate_many_plots_updated(save_dir,"Scaled by" + string(scale_factor)+" "+string(num_dps)+" DPS.pdf",pwd+"\Data\PDF_DIR")

%% Step 10: Run Clustering Algorithm
close all;
clc;
% 80 and 116 and 14
array_of_desired_tetrodes = get_array_of_all_tetrodes_which_contain_given_channel(114,art_tetr_array);
% array_of_desired_tetrodes = array_of_desired_tetrodes(2:end);
% array_of_desired_tetrodes = strcat("t",string(1:size(art_tetr_array,1)));
[output_array,aligned_array,reg_timestamps_array] = run_clustering_algorithm_on_desired_tetrodes(array_of_desired_tetrodes,tetrode_dictionary,spike_tetrode_dictionary,spike_tetrode_dictionary_samples_format,channel_wise_means,channel_wise_std,6,timing_tetrode_dictionary,data_dir);
 %%
 config = spikesort_config(); %load the config file;
 idx = extract_clusters_from_output(output_array{1}(:,1),output_array{1},config);
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