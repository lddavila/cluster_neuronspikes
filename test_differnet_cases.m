%% STEP 1: Add Utility functions to your path
cd("Utility Functions\");
addpath(pwd);
cd("..");
cd("clustering-master\")
addpath(genpath(pwd));
cd("..")
clc;

%% common Parameters
scale_factor = -1;
dir_with_channel_recordings = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\50 Neuron 300 Second Recording Level 3 Noise";
min_z_score = 4;
num_dps = 60;
timestamps_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 second timestamps" ;
precomputed_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\50 Neuron 300 Second Pre Computed (1)";
what_is_precomputed = ["z_score","mean_and_std", "spikes_per_channel 3","spike_windows min_z_score 4 num dps 60","spikes_per_channel min_z_score 4", "dictionaries min_z_score 4 num_dps 60"];
min_threshold = 20 ;

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

%% Single Neuron
clc;
% 2 channel case
manually_made_tetrode = [294,198];
size_of_tetrode = length(manually_made_tetrode);
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,"1N2Ch",@extract_cluster_features);
disp("finished 2 channel case")
% Single Neuron 3 channel case
disp("Beginning 3 Channel Case")
manually_made_tetrode = [294,198,199];
size_of_tetrode = length(manually_made_tetrode);
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,"1N3Ch",@extract_cluster_features);
disp("Finished 3 Channel Case")
% Single Neuron 4 channel case
disp("Beginning 4 Channel Case")
manually_made_tetrode = [294,198,199,102];
size_of_tetrode = length(manually_made_tetrode);
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,"1N4Ch",@extract_cluster_features);
disp("Finished 4 Channel Case")
% Single Neuron 5 channel case using original
disp("Beginning 5 channel case")
manually_made_tetrode = [294,198,199,102,6];
size_of_tetrode = length(manually_made_tetrode);
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,"1N5Ch",@extract_cluster_features);
disp("Finished Final Case")
%% Single Neuron 5 channel case using updated
disp("Beginning 5 channel case")
manually_made_tetrode = [294,198,199,102,6];
size_of_tetrode = length(manually_made_tetrode);
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,"1N5Ch",@extract_cluster_features_5_channels);
disp("Finished Final Case")
%% 2 neurons
% 2 Neurons 2 channels
clc;
manually_made_tetrode = [89 88];
size_of_tetrode = length(manually_made_tetrode);
name_of_experiment = "2N2Ch";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%2 Neuron 3 channels
manually_made_tetrode = [89 88 184];
size_of_tetrode = length(manually_made_tetrode);
name_of_experiment = "2N3Ch";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%2 Neuron 4 channels
manually_made_tetrode = [89 88 184 281];
size_of_tetrode = length(manually_made_tetrode);
name_of_experiment = "2N4Ch";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,name_of_experiment,@extract_cluster_features);

% 2 Neuron 5 Channels original
manually_made_tetrode = [89 88 184 281 376];
size_of_tetrode = length(manually_made_tetrode);
name_of_experiment = "2N5Ch";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,name_of_experiment,@extract_cluster_features);

% 2 Neuron 6 Channels OG
manually_made_tetrode = [89 88 184 281 276 90];
size_of_tetrode = length(manually_made_tetrode);
name_of_experiment = "2N6ChOG";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%% 2 Neuron 5 Channels updated 
manually_made_tetrode = [89 88 184 281 376];
size_of_tetrode = length(manually_made_tetrode);
name_of_experiment = "2N5ChUpdated";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,name_of_experiment,@extract_cluster_features_5_channels);


%% 2 Neuron 6 Channels updated
manually_made_tetrode = [89 88 184 281 276 90];
size_of_tetrode = length(manually_made_tetrode);
name_of_experiment = "2N6ChUpdated";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,name_of_experiment,@extract_cluster_features_6_channels);

%% 3 neurons
% 2 channels
clc;
manually_made_tetrode = [45 140];
size_of_tetrode = length(manually_made_tetrode);
name_of_experiment = "3N2Ch";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%3 channels
manually_made_tetrode = [45 140 141];
size_of_tetrode = length(manually_made_tetrode);
name_of_experiment = "3N3Ch";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%% 3 Neuron 4 channels
manually_made_tetrode = [45 140 141 237];
size_of_tetrode = length(manually_made_tetrode);
name_of_experiment = "5N4Ch";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%% 3 Neuron 5 Channels Original
manually_made_tetrode = [45 140 141 237 332];
size_of_tetrode = length(manually_made_tetrode);
name_of_experiment = "3N5ChOG";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%% 3 Neuron 6 Channels Original
manually_made_tetrode = [45 140 141 237 332 336];
size_of_tetrode = length(manually_made_tetrode);
name_of_experiment = "3N6ChOG";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,name_of_experiment,@extract_cluster_features);
%% 3 Neuron 5 Channels Updated 
clc;
manually_made_tetrode = [45 140 141 237 332];
size_of_tetrode = length(manually_made_tetrode);
name_of_experiment = "3N5ChUpdated";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,name_of_experiment,@extract_cluster_features_5_channels);

%% 3 Neuron 6 Channels Updated
clc;
manually_made_tetrode = [45 140 141 237 332 336];
size_of_tetrode = length(manually_made_tetrode);
name_of_experiment = "3N6ChUpdated";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,name_of_experiment,@extract_cluster_features_6_channels);

%% example of tetrode which is slightly off of neuron detection
manually_made_tetrode = [107 299];
size_of_tetrode = length(manually_made_tetrode);
name_of_experiment = "Channels below neuron";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%% add a channel that is directly above the current tetrode
clc;
manually_made_tetrode = [107 299 204];
name_of_experiment = "Channel below neuron Added 204";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%% 2 channels to the right of 2 neurons (ideally we go left) (for some reason this is ideal for seeing the 2 neurons )
manually_made_tetrode = [301 302];
name_of_experiment = "channel to right of 2 neurons";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);
%% 3 channels to the right of 2 neurons (Broke Immediately)
manually_made_tetrode = [301 302 206];
name_of_experiment = "3 channels to the right of 2 neurons";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%% 4 channels to the right of 2 neurons (not terrible )
clc;
manually_made_tetrode = [301 302 206 109];
name_of_experiment = "3 channels to the right of 2 neurons";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%% 2 channels that are directly between 2 neurons
%these are both exactly on top of the neurons
%this will either be perfect, or it will be hurtful because they're too mixed
%the results were much worse 
clc;
manually_made_tetrode = [14 13];
name_of_experiment = "2 ch on top of 2 neurons";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%% add a third channel below 2 neurons
%in this we see that the neuron in the direction of the added channel is shown more clearly

clc;
manually_made_tetrode = [12 14 13];
name_of_experiment = "3 ch on top of 2 neurons";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%% add a third and fourth channel below  and to the right of 2 neurons
%adding a 4th in the same direction strengthens the effect we see in the first
%exactly as expected by adding a horizontal channel one of the 2 neurons is projected much more strongly 
%i expected this because this you're adding a channel which is closer to 1 of the 2 neurons and further from the other
%naturally this should occur 
clc;
manually_made_tetrode = [12 14 13 108];
name_of_experiment = "4 ch on top of 2 neurons";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);


%% common Parameters for 100 neuron example
scale_factor = -1;
dir_with_channel_recordings = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\100 Neuron 300 Second Recording Level 3 Noise";
min_z_score = 4;
num_dps = 60;
timestamps_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 second timestamps" ;
precomputed_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\100 Neuron 300 Second Pre Computed";
what_is_precomputed = ["z_score","mean_and_std", "spikes_per_channel 3","spike_windows min_z_score 4 num dps 60","spikes_per_channel min_z_score 4", "dictionaries min_z_score 4 num_dps 60"];
min_threshold = 20 ;
%% 4 neuron 4 channel example
manually_made_tetrode = [27 219 122 314];
name_of_experiment = "4 ch 4 neurons";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%% 4 neuron 5 channel example
manually_made_tetrode = [27 219 122 314 315];
name_of_experiment = "5 ch 4 neurons";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);
%% 4 neuron 6 channel example
manually_made_tetrode = [27 219 122 314 315 123];
name_of_experiment = "6 ch 4 neurons";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);
