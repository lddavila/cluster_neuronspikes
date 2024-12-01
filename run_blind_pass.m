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
varying_z_scores = [5,6,7,8,9];
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
        what_is_precomputed = ["z_score","mean_and_std"];
        %what_is_precomputed = ["mean_and_std","z_score","dictionaries min_z_score "+string(min_z_score)+" num_dps 60","spike_windows min_z_score "+string(min_z_score)+" num dps 60","spikes_per_channel min_z_score " + string(min_z_score)];
        
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
debug = 0;
varying_z_scores = [3,3.5,4];
varying_z_scores = [3, 3.5, 4, 5, 6,7,8,9];
%varying_z_scores = [3, 3.5, 5, 6,7,8,9];
varying_z_scores = [6,7,8,9];
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
clc;
close all;
generic_dir_with_grades = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass min z_score 3 grades";
generic_dir_with_outputs = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass_results min z_score3";
relevant_grades = [2] ;
names_of_relevant_grades = ["Tightness","Overlap Percentage"];
config = spikesort_config; %load the config file;
the_range = [0.0 0.1] ;
compare_before_after_filter_application_ver_2(generic_dir_with_grades,generic_dir_with_outputs,relevant_grades,names_of_relevant_grades,config,the_range,ground_truth_array,timestamps);

%% second method of testing
clc;
close all;
generic_dir_with_grades = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass min z_score 3 grades";
generic_dir_with_outputs = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass_results min z_score3";
%relevant grades include
%2 tightness 2
%3 percent short isi 3
%4 incompleteness 4
%8 template matching 8
%9 min bhat 9
%28 skewness of cluster
%29 measure the difference between the cluster's individual spikes and the
%cluster's spike templates
%30 Incompleteness using histogram symmetry
%31 Classification of cluster amplitude
%32 classification of cluster amplitude based only on rep wire
relevant_grades = [2,31,30,32,4,8,9,28,29];
relevant_grade_names = ["Tightness","Amplitude","Hist Sym","Rep Wire Amp","incompleteness","TM","Min Bhat","cluster skewness","TM New","Overlap Percentage"];
debug = 1;
conditions = {@less_than,@greater_than,@less_than, @greater_than};
check_against_values = [0.1, 1,7,1];
ground_truth = importdata("D:\spike_gen_data\Recording By Channel Ground Truth\0_100Neuron300SecondRecordingWithLevel3Noise.h5.mat");
timestamps = importdata("D:\spike_gen_data\Recordings By Channel Timestamps\0_100Neuron300SecondRecordingWithLevel3Noise\timestamps.mat");
[clusters_which_survive_purge,names_of_tetrodes_clusters_belong_to] = filter_noise_clusters(debug,conditions,generic_dir_with_grades,generic_dir_with_outputs,ground_truth,timestamps,relevant_grades,check_against_values,relevant_grade_names);

%% grading clusters with a bunch of if statements
clc;
close all;
generic_dir_with_grades = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass min z_score";
generic_dir_with_outputs = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass_results min z_score";
optional_z_scores = [3 3.5 4];
optional_z_scores = [4,3.5,3];
list_of_desired_tetrodes = strcat("t",string(1:285));
debug =1;
relevant_grades = [2,31,30,32,8,28,29,33,34,9,35,36,37,38];
relevant_grade_names = ["CV (2)","Amp. (31)","Hist. Sym. (30)","R-Wire Amp(32)","TM(8)","CL. Skew(28)","TM New()","Chance Of M.U.A(33)","Min B-Dist From M.U.A(34)","Min B-Dist To Neighbor(9)","TM Cluster Level(35)","TM Rep Wire Level(36)","Min Bhat Best Dim","Best Dim"];
dir_to_save_figs_to = "D:\OneDrive - The University of Texas at El Paso\Graded Clusters Z Score 4";
grade_clusters(generic_dir_with_grades,generic_dir_with_outputs,optional_z_scores,list_of_tetrodes,debug,relevant_grades,relevant_grade_names,dir_to_save_figs_to);

%% finding clusters with varying z scores and 
clc;
close all;
dir_with_precomputed = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise";
varying_z_scores = [3, 3.5, 4, 5,6,7,8,9];
tetrodes_to_check = strcat("t",string(1:285));
debug = 1;
grades_that_matter = [2,31,30,32,8,28,29,33,34,9,35,36,37,38];
names_of_grades = ["CV (2)","Amp. (31)","Hist. Sym. (30)","R-Wire Amp(32)","TM(8)","CL. Skew(28)","TM New()","Chance Of M.U.A(33)","Min B-Dist From M.U.A(34)","Min B-Dist To Neighbor(9)","TM Cluster Level(35)","TM Rep Wire Level(36)","Min Bhat Best Dim","Best Dim"];
min_overlap_percentage = 50;
finding_clusters_bringing_in_varying_z_scores(dir_with_precomputed,varying_z_scores,tetrodes_to_check,min_overlap_percentage,debug,grades_that_matter,names_of_grades);
