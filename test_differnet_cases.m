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
dir_with_channel_recordings = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\100 Neuron 300 Second Recording Level 3 Noise";
min_z_score = 4;
num_dps = 60;
timestamps_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\300 second timestamps" ;
precomputed_dir = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\100 Neuron 300 Second Pre Computed";
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
manually_made_tetrode = [1, 2, 97,98];
size_of_tetrode = length(manually_made_tetrode);
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,"1N2Ch",@extract_cluster_features);
disp("finished 2 channel case")
% Single Neuron 3 channel case
disp("Beginning 3 Channel Case")
%%
manually_made_tetrode = [294,198,199];
size_of_tetrode = length(manually_made_tetrode);
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,size_of_tetrode,manually_made_tetrode,"1N3Ch",@extract_cluster_features);
%%
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
%start
manually_made_tetrode = [301 302];
name_of_experiment = "channel to right of 2 neurons";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);
%% 2 channels above 2 neurons (ideally we go down)
%you can see 2 neurons, but not ideally
manually_made_tetrode = [110 302];
name_of_experiment = "channels below 2 neurons";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%% 3 channels above 2 neurons (ideally we go down) (worse)
manually_made_tetrode = [110 302 301];
name_of_experiment = "channel to right of 2 neurons";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%% 3 channels 2 above neurons and 1 in between 2 neurons (ideally we go down)
%this is even worse
manually_made_tetrode = [110 302 109];
name_of_experiment = "channel to right of 2 neurons";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);
%% 3 channels 2 below neurons (ideally we go up)
clc;
%this is even worse
%interestingly we se only 1 neuroni
manually_made_tetrode = [12 204];
name_of_experiment = "channel to right of 2 neurons";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);
%% 3 channels 2 above neurons and 1 in between 2 neurons (ideally we go down)
%seems much better
%this is actually better it distignuishes the 2 clusters
clc;
manually_made_tetrode = [12 204 109];
name_of_experiment = "channel to right of 2 neurons";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);
%% 3 channels, 2 below the neurons, 1 to the right of the 2 neurons
%again weirdly ideal
clc;
manually_made_tetrode = [12 204 301];
name_of_experiment = "channel to right of 2 neurons";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%% 3 channels, 2 below the neurons, and 1 to the right 
clc;
manually_made_tetrode = [12 204 109];
name_of_experiment = "channel to right of 2 neurons";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%end
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
dir_to_save_figs_to = "C:\Users\ldd77\OneDrive\Desktop\";
%% 4 neuron 4 channel example
clc;
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

%% start of new tests
manually_made_tetrode = [248 152];
name_of_experiment = "";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%%
manually_made_tetrode = [248 152 151];
name_of_experiment = "";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%%
clc;
manually_made_tetrode = [169 168];
name_of_experiment = "";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);
%%
clc;
manually_made_tetrode = [169 168 360];
name_of_experiment = "";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%%
clc;
manually_made_tetrode = [175 270];
name_of_experiment = "";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%%
clc;
manually_made_tetrode = [175 270 365];
name_of_experiment = "";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%%
clc;
manually_made_tetrode = [175 270 365 269 ];
name_of_experiment = "";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%%
clc;
manually_made_tetrode = [175 270 365 269 172 ];
name_of_experiment = "";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);
%%
clc;
manually_made_tetrode = [282 185];
name_of_experiment = "";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);
%%
clc;
manually_made_tetrode = [282 185 377];
name_of_experiment = "";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);
%%
clc;
manually_made_tetrode = [187 283];
name_of_experiment = "";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);

%%
clc;
manually_made_tetrode = [91 187 283];
name_of_experiment = "";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);
%%
clc;
manually_made_tetrode = [91 187 283 379];
name_of_experiment = "";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);
%% test the spike amplitude work to see if it works
%part 1: the first dumb pass, will work with only 2 channels but it should be fine
%this first dumb pass produces 3 total clusters
%1 is clearly a noise cluster (green)
%arguably 1 other is a noise cluster (red)
%and there is a clear cluster that is not identified, but is easy to see
%and the third cluster (blue) seems like it might be a neuron
%keep in mind there are actually 4 clusters in this area
clc; 
manually_made_tetrode = [175 365];
name_of_experiment = "Messy Example With 2 Channels";
manually_test_algorithm(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,20,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features);
%% load the grades from the initial dumb pass

dir_with_initial_pass_results = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\100 Neuron 300 Second Pre Computed\manual tests min_z_score 4 num_dps 60 size of tetrode 2 channels ExampleMessy Example With 2 Channelsresults";
dir_with_initial_pass_grades = "C:\Users\ldd77\OneDrive - The University of Texas at El Paso\100 Neuron 300 Second Pre Computed\manual tests min_z_score 4 num_dps 60 size of tetrode 2 channels ExampleMessy Example With 2 Channels";
load(dir_with_initial_pass_grades+"\t1.mat");
config = spikesort_config(); %load the config file;
%the important part (grades) has an array of shape nx27 where n is the number of clusters, and 27 is the number of grades per cluster
%% part 2: here is where we will test by looking at spike amplitude
%it will essentially be the second pass
%recall in that all spikes are already precomputed, and we will use this to find each cluster's ideal spikes
%in this example I have no human intelligence I have to find ideal configurations using only grades,
clc;
% close all;
min_amplitude_distance = 2;
plot_or_dont = 1;
possible_improvement_channels = second_pass_algorithm(dir_with_initial_pass_grades,dir_with_initial_pass_results,[175,365],precomputed_dir,min_z_score,num_dps,timestamps_dir,"Messy Example With 2 Channels",20,dir_with_channel_recordings,@extract_cluster_features,config,min_amplitude_distance,plot_or_dont,dir_to_save_figs_to+"spike amplitude graphs");

%% now that you have your reccomended channels let's see if running it again with these new channels improves visualization at all
%surprisingly there were more dimensions where my human intelligence could see more clusters, but the algorithm didn't detect them 
%it could be that I added too many channels to the tetrode and broke it 
%this printed a TON of warnings & took forever to run 
manually_made_tetrode = [175 365];
manually_made_tetrode = [manually_made_tetrode,possible_improvement_channels{1}];
name_of_experiment = "First Set of Improvement Channels";
manually_test_algorithm_ver2(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,40,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features,dir_to_save_figs_to+name_of_experiment);

%% now that you have your reccomended channels let's see if running it again with these new channels improves visualization at all
%again this produces a TON of warnings
%again we saw more clusters with my human intelligence, but it didn't actually help with detection
manually_made_tetrode = [175 365];
manually_made_tetrode = [manually_made_tetrode,possible_improvement_channels{2}];
name_of_experiment = "Second Set of Improvement Channels";
manually_test_algorithm_ver2(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features,dir_to_save_figs_to+name_of_experiment);

%% now that you have your reccomended channels let's see if running it again with these new channels improves visualization at all
manually_made_tetrode = [175 365];
manually_made_tetrode = [manually_made_tetrode,possible_improvement_channels{3}];
name_of_experiment = "Third Set of Improvement Channels";
manually_test_algorithm_ver2(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,40,length(manually_made_tetrode),manually_made_tetrode,name_of_experiment,@extract_cluster_features,dir_to_save_figs_to+name_of_experiment);





