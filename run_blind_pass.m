%% STEP 1: Add Utility functions to your path
cd("Utility Functions\");
addpath(pwd);
cd("..");
cd("clustering-master\")
addpath(genpath(pwd));
cd("..")
%% Step 2: Run the blind pass
close all;
clc;
scale_factor = -1;
dir_with_channel_recordings = "";
min_z_score = 4;
min_threshold = 20;
num_dps = 60;
timestamps_dir = "";
create_z_score_matrix = 0;
dir_to_save_everything_to = "";
precomputed_dir = "";
what_is_precomputed = [""];
what_is_precomputed = run_entire_clustering_algorithm_ver_2(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold);