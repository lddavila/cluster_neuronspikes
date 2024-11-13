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
for i=1:1.5%length(subfolder_names)
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
    what_is_precomputed = ["mean_and_std","z_score","dictionaries min_z_score 4 num_dps 60","spike_windows min_z_score 4 num dps 60","spikes_per_channel min_z_score 4"];
    what_is_precomputed = run_entire_clustering_algorithm_ver_2(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir_current,what_is_precomputed,min_threshold);
end

%% run the blind pass with a different min_z_score (cut threshold) of 3.9
precomputed_dir = "D:\spike_gen_data\Recordings By Channel Precomputed";
dir_of_timestamps = "D:\spike_gen_data\Recordings By Channel Timestamps";
varying_z_scores = [3,3.5,4];
for i=1:1.5%length(subfolder_names)
    for j=1:length(varying_z_scores)
        close all;
        clc;
        scale_factor = -1;
        dir_with_channel_recordings = recording_dir + "\"+string(subfolder_names{i});
        min_z_score = varying_z_scores(j);
        min_threshold = 20;
        num_dps = 60;
        timestamps_dir = dir_of_timestamps+"\"+string(subfolder_names{i});
        create_z_score_matrix = 0;
        precomputed_dir_current = precomputed_dir +"\"+string(subfolder_names{i});
        %what_is_precomputed = ["z_score","mean_and_std"];
        what_is_precomputed = ["mean_and_std","z_score","dictionaries min_z_score "+string(min_z_score)+" num_dps 60","spike_windows min_z_score "+string(min_z_score)+" num dps 60","spikes_per_channel min_z_score " + string(min_z_score)];
        
        what_is_precomputed = run_entire_clustering_algorithm_ver_2(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir_current,what_is_precomputed,min_threshold);
    end
end

%% compute the grades for the nth pass
clc;
config = spikesort_config; %load the config file;
config = config.spikesort;
clc;
close all;
dir_with_data = "D:\spike_gen_data\Recordings By Channel Precomputed";
current_recording = "0_100Neuron300SecondRecordingWithLevel3Noise";
debug = 1;
varying_z_scores = [3,3.5,4];
for i=1:length(varying_z_scores)
dir_with_output = "D:\spike_gen_data\Recordings By Channel Precomputed\"+current_recording+"\initial_pass_results min z_score"+string(varying_z_scores(i));
dir_to_save_grades_to = "D:\spike_gen_data\Recordings By Channel Precomputed\"+current_recording+"\initial_pass min z_score "+string(varying_z_scores(i))+" grades";
dir_to_save_grades_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_grades_to);
list_of_tetrodes = strcat("t",string(1:285));
dir_with_timestamps_and_rvals = "D:\spike_gen_data\Recordings By Channel Precomputed\"+current_recording+"\initial_pass min z_score"+string(varying_z_scores(i));
name_of_grades = ["Tight","% Short ISI","Inc", "Temp Mat","Min Bhat","Skewness","TM Updated","Sym of Hist","Amp Category"];
relevant_grades = [2,3,4,8,9,28,29,30,31];
get_grades_for_nth_pass_of_clustering(dir_with_timestamps_and_rvals,dir_with_output,list_of_tetrodes,dir_to_save_grades_to,config,varying_z_scores(i),debug,relevant_grades,name_of_grades)
end
%% compare different cut thresholds for the same recording
dir_of_nth_pass_recording = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise";
list_of_z_scores_to_check = [3,3.5,4];
list_of_tetrodes = strcat("t",string(1:285));
%relevant grades include
%tightness 2
%percent short isi 3
%incompleteness 4
%template matching 8
%min bhat 9
clc;
close all;
names_of_grades = ["Tight","% Short ISI","Inc", "Temp Mat","Min Bhat","Skewness","TM Updated","Sym of Hist","Average Amp"];
relevant_grades = [2,3,4,8,9,28,29,30,31];
compare_different_cut_thresholds(dir_of_nth_pass_recording,list_of_z_scores_to_check,list_of_tetrodes,relevant_grades,names_of_grades);

%% compare tests
dir_with_grades = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass min z_score 3 grades";
dir_with_outputs = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass_results min z_score3";
relevant_grades = [30] ;
names_of_relevant_grades = ["Sym of Hist"];
config = spikesort_config; %load the config file;
config = config.spikesort;
the_range = [0.5,6] ;
compare_before_after_filter_application(dir_with_grades,dir_with_outputs,relevant_grades,names_of_relevant_grades,config,the_range);