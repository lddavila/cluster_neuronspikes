%% STEP 1: Add Utility functions to your path
cd("Utility Functions\");
addpath(pwd);
cd("..");
cd("clustering-master\")
addpath(genpath(pwd));
cd("..")

%% step 2: Get all the recording directories 
clc
recording_dir= "D:\spike_gen_data\Recordings By Channel";
%list_of_recording_dir = pwd;
files_containing_recordings = dir(recording_dir);
dir_flags = [files_containing_recordings.isdir];
subfolders = files_containing_recordings(dir_flags);
subfolder_names = {subfolders(3:end).name};
disp(subfolder_names.')


%% Step 3: Run the blind pass
precomputed_dir = "D:\spike_gen_data\Recordings By Channel Precomputed";
dir_of_timestamps = "D:\spike_gen_data\Recordings By Channel Timestamps";
for i=1:length(subfolder_names)
    close all;
    clc;
    scale_factor = -1;
    dir_with_channel_recordings = recording_dir + "\"+string(subfolder_names{i});
    min_z_score = 4;
    min_threshold = 20;
    num_dps = 60;
    timestamps_dir = dir_of_timestamps+"\"+string(subfolder_names{i});
    create_z_score_matrix = 1;
    precomputed_dir_current = precomputed_dir +"\"+string(subfolder_names{i});
    what_is_precomputed = [""];
    what_is_precomputed = run_entire_clustering_algorithm_ver_2(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir,what_is_precomputed,min_threshold);
end