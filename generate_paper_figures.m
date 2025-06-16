%% add all files to the path
addpath(genpath(pwd))
%% get config file
config = spikesort_config();
%% import data from clustering table
%update this before finishing
blind_pass_table = importdata("D:\cluster_neuronspikes\Data\final_overlap_table\final_table_with_overlap.mat");
%% set up some frequently used directories and variables
dir_with_raw_recordings ="D:\spike_gen_data\Recordings By Channel\0_100Neuron300SecondRecordingWithLevel3Noise";
timestamps_dir = "D:\spike_gen_data\Recordings By Channel Timestamps\0_100Neuron300SecondRecordingWithLevel3Noise";
dir_to_save_figs_to = "D:\OneDrive - The University of Texas at El Paso\Friedman, Alexander's files - spike sorting paper\Figure SVGs";
%% Plot spike Traces Used In Figure 1 (algorithm overview)
clc;
close all;
tetrode_to_use = "t91";
channels_to_use = strcat("c",string([31 32 127 128]));
time_bounds = [1.225,1.240];

display_the_spike_traces_over_time_interval(dir_with_raw_recordings,channels_to_use,time_bounds,timestamps_dir,config,91);
%% plot the same clustering at different z scores to show how it affects the algorithm
clc;
close all;
rows_with_desired_tetrode = blind_pass_table(blind_pass_table{:,"Tetrode"}==tetrode_to_use,:);
plot_clusters_for_paper(rows_with_desired_tetrode,dir_to_save_figs_to,true);