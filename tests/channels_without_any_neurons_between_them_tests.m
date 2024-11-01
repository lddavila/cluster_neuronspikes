%% STEP 1: Add Utility functions to your path
cd("..\Utility Functions\");
addpath(pwd);
cd("..");
cd("clustering-master\")
addpath(genpath(pwd));
cd("..")
cd("tests\")
clc;

%% common Parameters for 100 neuron example
scale_factor = -1;
dir_with_channel_recordings = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\100 Neuron 300 Second Recording Level 3 Noise";
min_z_score = 4;
num_dps = 60;
timestamps_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 second timestamps" ;
precomputed_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\100 Neuron 300 Second Pre Computed";
what_is_precomputed = ["z_score","mean_and_std", "spikes_per_channel 3","spike_windows min_z_score 4 num dps 60","spikes_per_channel min_z_score 4", "dictionaries min_z_score 4 num_dps 60"];
min_threshold = 20 ;
dir_to_save_figs_to = "C:\Users\ldd77\OneDrive\Desktop\";
manually_made_tetrode = [163 355];
%% test the spike amplitude work to see if it works
%part 1: the first dumb pass, will work with only 2 channels but it should be fine
clc; 
name_of_experiment = "2 Channels Between 2 neurons";
%manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,20,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);
%% load the grades from the initial blind pass

dir_with_initial_pass_results = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\100 Neuron 300 Second Pre Computed\manual tests min_z_score 4 num_dps 60 size of tetrode 2 channels Example"+name_of_experiment+"results";
dir_with_initial_pass_grades = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\100 Neuron 300 Second Pre Computed\manual tests min_z_score 4 num_dps 60 size of tetrode 2 channels Example"+name_of_experiment;
config = spikesort_config(); %load the config file;
%the important part (grades) has an array of shape nx27 where n is the number of clusters, and 27 is the number of grades per cluster
%% part 2: here is where we will test by looking at spike amplitude
%it will essentially be the second pass
%recall in that all spikes are already precomputed, and we will use this to find each cluster's ideal spikes
%in this example I have no human intelligence I have to find ideal configurations using only grades,
clc;
close all;
min_amplitude_distance = 0.5;
plot_or_dont = 0;
possible_improvement_channels = second_pass_algorithm(dir_with_initial_pass_grades,dir_with_initial_pass_results,manually_made_tetrode,precomputed_dir,min_z_score,num_dps,timestamps_dir,name_of_experiment,20,dir_with_channel_recordings,@extract_cluster_features,config,min_amplitude_distance,plot_or_dont,dir_to_save_figs_to+"spike amplitude graphs");

%% now that you have your reccomended channels let's see if running it again with these new channels improves visualization at all
%surprisingly there were more dimensions where my human intelligence could see more clusters, but the algorithm didn't detect them 
%it could be that I added too many channels to the tetrode and broke it 
%this printed a TON of warnings & took forever to run 
close all;
clc;
which_cluster = 1;
channels_of_higher_amplitude = possible_improvement_channels{1,which_cluster};
channels_of_lower_amplidue = possible_improvement_channels{2,which_cluster};
manually_made_tetrode_updated = [manually_made_tetrode,channels_of_higher_amplitude(1)];
manually_made_tetrode_updated = [manually_made_tetrode_updated,channels_of_lower_amplidue(1)];

name_of_experiment = "Set " +string(which_cluster) +" of Improvement Channels";
min_threshold=20;
manually_test_algorithm_ver2(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode_updated),manually_made_tetrode_updated,name_of_experiment,@extract_cluster_features,dir_to_save_figs_to+name_of_experiment);
