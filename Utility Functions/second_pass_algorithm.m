function [possible_improvement_channels] = second_pass_algorithm(dir_with_first_pass_grades,dir_with_first_pass_results,first_pass_tetrode,precomputed_dir,min_z_score,num_dps,timestamps_dir,example_name,number_of_stds_above_mean,dir_with_channel_recordings,extract_features_fn,config,min_amplitude_distance,plot_the_avg_plots,dir_to_save_figs_to)
dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
load(dir_with_first_pass_grades+"\t1.mat");
load(dir_with_first_pass_results+"\t1 aligned.mat");
load(dir_with_first_pass_results+"\t1 output.mat");
load(dir_with_first_pass_results+"\t1 reg_timestamps.mat");
size_of_tetrode = length(first_pass_tetrode);

clusters_from_output = extract_clusters_from_output(output(:,1),output,config);

% get the spikes for the first pass tetrode back
spike_windows_label = "spike_windows min_z_score " + string(min_z_score) + " num dps " + string(num_dps) ;
%import the spike windows per channel
load(precomputed_dir+"\"+spike_windows_label+"\spike_windows.mat","spike_windows")
%import the timestamps
timestamps = importdata(timestamps_dir+"\timestamps.mat");

%get the mean and standard deviation of all channels
load(precomputed_dir+"\mean_and_std\mean_and_std.mat",'channel_wise_means','channel_wise_std') %loads the previously found mean and std

%get the dir of dictionaries that have all the info on the current tetrode's spikes
dictionaries_label = "testing dictionaries min_z_score " + string(min_z_score) + " num_dps " + string(num_dps) + " Number of Channels " + string(size_of_tetrode) + " Example " + example_name;
dictionaries_dir = precomputed_dir+"\"+dictionaries_label;
load(dictionaries_dir+"\t1 spiking_channel_tetrode_dictionary.mat","spiking_channel_tetrode_dictionary")
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



%now we want to determine which channel in the tetrode is the dominant channel in the found cluster 
%this is trivial and can be done simply by identifying which channel appears the most in the existing cluster
%now for each cluster determine the dominant channel as well as some other helpful statistics
channel_for_each_spike = cell2mat(spiking_channel_tetrode_dictionary("t1").');
dominant_channel_array = get_dominant_channel_per_cluster(clusters_from_output,first_pass_tetrode,channel_for_each_spike);
%dominant_channel_array:
    % a nx3 array
    %n represents the amount of clusters found in clusters_from_output 
    %the first column is which channel is dominant per cluster
    %the second column is the size of the cluster
    %the third column is how many of the spikes in the cluster belong to the dominant cluster

%now we have the dominant channel per cluster    
%ideally each cluster represents a neuron
%this isn't always the case because some clusters are noise clusters
%but we'll add filtering those out as a to do for later
%now what we need to do in what direction the neuron is projecting
%the best way to do this is by checking amplitude of channels which surround the dominant channel per cluster
%should you ignore channels already in the tetrode? I'm not sure



    
    
    
    
list_of_desired_tetrodes = ["t1"];


possible_improvement_channels = find_ideal_channel_config(spike_windows,first_pass_tetrode,dir_with_channel_recordings,clusters_from_output,dominant_channel_array,min_amplitude_distance,plot_the_avg_plots,dir_to_save_figs_to);

end