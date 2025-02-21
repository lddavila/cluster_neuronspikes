%% STEP 1: Add Utility functions to your path
cd("Utility Functions\");
addpath(pwd);
cd("..");
cd("clustering-master\")
addpath(genpath(pwd));
cd("..")
clc;

%% common Parameters for 100 neuron example
scale_factor = -1;
dir_with_channel_recordings = "D:\spike_gen_data\Recordings By Channel\0_100Neuron300SecondRecordingWithLevel3Noise";
min_z_score = 9;
num_dps = 60;
timestamps_dir = "D:\spike_gen_data\Recordings By Channel Timestamps\0_100Neuron300SecondRecordingWithLevel3Noise" ;
precomputed_dir = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise";
what_is_precomputed = ["z_score","mean_and_std", "spikes_per_channel ","spike_windows min_z_score  num dps 60","spikes_per_channel min_z_score 5", "dictionaries min_z_score 7 num_dps 60"];
min_threshold = 20 ;
dir_to_save_figs_to = "C:\Users\ldd77\OneDrive\Desktop\";

%% test the spike amplitude work to see if it works
%part 1: the first dumb pass, will work with only 2 channels but it should be fine
manually_made_tetrode = art_tetr_arr(18,:);
clc; 
name_of_experiment = "Presentation Example";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,20,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);
%%
%part 1: the first dumb pass, will work with only 2 channels but it should be fine
manually_made_tetrode = [358 262];
clc; 
name_of_experiment = "Presentation Example";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,20,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%% part 1: the first dumb pass, will work with only 2 channels but it should be fine
manually_made_tetrode = [70 166];
clc; 
name_of_experiment = "Presentation Example";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,20,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);