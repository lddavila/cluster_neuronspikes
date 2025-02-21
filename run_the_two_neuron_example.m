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

%% run the blind pass with a various min_z_score (cut threshold) 
precomputed_dir = "D:\spike_gen_data\Recordings By Channel Precomputed";
dir_of_timestamps = "D:\spike_gen_data\Recordings By Channel Timestamps";
varying_z_scores = [3,4,5,6,7,8,9];
for i=15:15.5%length(subfolder_names)
    what_is_precomputed = [""];
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
        
        %what_is_precomputed = [""];
        what_is_precomputed = ["mean_and_std","z_score","dictionaries min_z_score "+string(min_z_score)+" num_dps 60","spike_windows min_z_score "+string(min_z_score)+" num dps 60","spikes_per_channel min_z_score " + string(min_z_score)];
        
        what_is_precomputed = run_entire_clustering_algorithm_ver_2(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir_current,what_is_precomputed,min_threshold);
        what_is_precomputed = ["z_score","mean_and_std"];
    end
end

%% run blind pass only up to the point of saving the timestamp, used to debug
precomputed_dir = "D:\spike_gen_data\Recordings By Channel Precomputed";
dir_of_timestamps = "D:\spike_gen_data\Recordings By Channel Timestamps";
varying_z_scores = [3,4,5,6,7,8,9];
for i=15:15.5%length(subfolder_names)
    what_is_precomputed = [""];
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
        
        %what_is_precomputed = [""];
        what_is_precomputed = ["mean_and_std","z_score","dictionaries min_z_score "+string(min_z_score)+" num_dps 60","spike_windows min_z_score "+string(min_z_score)+" num dps 60","spikes_per_channel min_z_score " + string(min_z_score)];
        
        what_is_precomputed = save_only_the_timestamp(scale_factor,dir_with_channel_recordings,min_z_score,num_dps,timestamps_dir,precomputed_dir_current,what_is_precomputed,min_threshold);
        what_is_precomputed = ["z_score","mean_and_std"];
    end
end

%% compute the grades for the nth pass
clc;
config = spikesort_config; %load the config file;
config = config.spikesort;
clc;
close all;
dir_with_data = "D:\spike_gen_data\Recordings By Channel Precomputed";
current_recording = "22_2Neuron400SecondRecordingWithLevel3Noise";
debug = 0;
varying_z_scores = [3,4,5,6,7,8,9];
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
%% id the best
clc;
%close all;
dir_with_pre_computed = "D:\spike_gen_data\Recordings By Channel Precomputed\22_2Neuron400SecondRecordingWithLevel3Noise";
varying_z_scores = [4,5,6,7,8,9];
tetrodes_to_check = strcat("t",string(1:285));
min_overlap_percentage = 30;
debug = 0;
grades_that_matter = [2,31,30,32,8,28,29,33,34,9,35,36,37,38,40,41];
names_of_grades =["CV (2)","Amp. (31)","Hist. Sym. (30)","R-Wire Amp(32)","TM(8)","CL. Skew(28)","TM New()","Chance Of M.U.A(33)","Min B-Dist From M.U.A(34)","Min B-Dist To Neighbor(9)","TM Cluster Level(35)","TM Rep Wire Level(36)","Min Bhat Best Dim","Best Dim","SNR","burst ratio(41)"] ;
generic_dir_with_grades = "D:\spike_gen_data\Recordings By Channel Precomputed\22_2Neuron400SecondRecordingWithLevel3Noise\initial_pass min z_score";
generic_dir_with_outputs = "D:\spike_gen_data\Recordings By Channel Precomputed\22_2Neuron400SecondRecordingWithLevel3Noise\initial_pass_results min z_score";
dir_to_save_figs_to = "D:\OneDrive - The University of Texas at El Paso\Graded Clusters Z Score 4";
load_previous_attempt = false;
[best_appearences_of_cluster,timestamps_of_best_clusters ]= id_best_representation_of_clusters(varying_z_scores,tetrodes_to_check,min_overlap_percentage,debug,grades_that_matter,names_of_grades,generic_dir_with_grades,generic_dir_with_outputs,dir_to_save_figs_to,load_previous_attempt);

%% now compare these best representations to ground truth to see how well they compare
clc;
%close all;
ground_truth_dir = "D:\generate_spike_scripts\2 Neuron Ground Truth";
ground_truth_array = load_ground_truth_into_data(ground_truth_dir);
dir_of_timestamps = "D:\spike_gen_data\Recordings By Channel Timestamps\22_2Neuron400SecondRecordingWithLevel3Noise";
timestamps = importdata(dir_of_timestamps+"\timestamps.mat") ;

min_percentage_threshold = 1;
time_delta = 0.002;
debug =0;

table_of_accuracy_of_clusters = compare_timestamps_to_ground_truth_ver_3(ground_truth_array{1},timestamps_of_best_clusters,timestamps,time_delta,debug,best_appearences_of_cluster);

% plot the grades in a heatmap
%grades_to_check = ["accuracy","overlap_with_unit","number_of_false_positives","number_of_true_positives","agreement_scores","recall_scores","precision_scores"];
%grades_to_check = ["overlap_with_unit","number_of_false_positives","number_of_true_positives"];
grades_to_check = ["overlap_with_unit"];
create_heatmaps_of_grades_in_accuracy_table(table_of_accuracy_of_clusters,grades_to_check);

%% compare the best appearences to the exact ground truth of the found best appearences of the cluster
clc;
close all;
ground_truth_dir = "D:\generate_spike_scripts\2 Neuron Ground Truth";
ground_truth_array = load_ground_truth_into_data(ground_truth_dir);
dir_with_outputs ="D:\spike_gen_data\Recordings By Channel Precomputed\22_2Neuron400SecondRecordingWithLevel3Noise\initial_pass_results min z_score4";
dir_with_grades = "D:\spike_gen_data\Recordings By Channel Precomputed\22_2Neuron400SecondRecordingWithLevel3Noise\initial_pass min z_score 4 grades";
dir_of_precomputed = "D:\spike_gen_data\Recordings By Channel Precomputed\22_2Neuron400SecondRecordingWithLevel3Noise\";
number_of_units_to_compare_to = 1;
dir_with_raw_recordings = "D:\spike_gen_data\Recordings By Channel\22_2Neuron400SecondRecordingWithLevel3Noise";
compare_cluster_spikes_to_ground_truth_spikes(best_appearences_of_cluster,ground_truth_array,dir_with_outputs,dir_with_grades,table_of_accuracy_of_clusters,number_of_units_to_compare_to,dir_with_raw_recordings,dir_of_precomputed);

%% look at the ground truth and its z-scores to see how lowering them affects things
clc;
close all
ground_truth_dir = "D:\generate_spike_scripts\2 Neuron Ground Truth";
ground_truth_array = load_ground_truth_into_data(ground_truth_dir);
dir_of_timestamps = "D:\spike_gen_data\Recordings By Channel Timestamps\22_2Neuron400SecondRecordingWithLevel3Noise";
timestamps = importdata(dir_of_timestamps+"\timestamps.mat") ;
dir_of_precomputed = "D:\spike_gen_data\Recordings By Channel Precomputed\22_2Neuron400SecondRecordingWithLevel3Noise";
levels_to_check =  1;
tetrode_to_check_against = "t239";
dir_of_raw_recordings = "D:\spike_gen_data\Recordings By Channel\22_2Neuron400SecondRecordingWithLevel3Noise";
debug = true;
ground_truth_unit_data = ground_truth_array{1}{1};
levels_benetath_higest_z_score_to_check=1;
interval = 1;
plot_levels_of_SNR_starting_at_GT(ground_truth_unit_data,levels_to_check,interval,tetrode_to_check_against,dir_of_precomputed,dir_of_raw_recordings,debug)

%% look at the ground truth and its z-scores to see how lowering them affects things
clc;
close all
ground_truth_dir = "D:\generate_spike_scripts\2 Neuron Ground Truth";
ground_truth_array = load_ground_truth_into_data(ground_truth_dir);
dir_of_timestamps = "D:\spike_gen_data\Recordings By Channel Timestamps\22_2Neuron400SecondRecordingWithLevel3Noise";
timestamps = importdata(dir_of_timestamps+"\timestamps.mat") ;
dir_of_precomputed = "D:\spike_gen_data\Recordings By Channel Precomputed\22_2Neuron400SecondRecordingWithLevel3Noise";
levels_to_check =  1;
tetrode_to_check_against = "t2";
dir_of_raw_recordings = "D:\spike_gen_data\Recordings By Channel\22_2Neuron400SecondRecordingWithLevel3Noise";
debug = false;
ground_truth_unit_data = ground_truth_array{1}{2};
levels_benetath_higest_z_score_to_check=1;
interval = 1;
plot_levels_of_SNR_starting_at_GT(ground_truth_unit_data,levels_to_check,interval,tetrode_to_check_against,dir_of_precomputed,dir_of_raw_recordings,debug)

%% check how the ground truth looks on every wire in the specified Tetrode
clc;
close all;
tetrode_to_check = "t239";
art_tetr_array = build_artificial_tetrode();
dir_with_og_recordings = "D:\spike_gen_data\Recordings By Channel\22_2Neuron400SecondRecordingWithLevel3Noise";
ground_truth_dir = "D:\generate_spike_scripts\2 Neuron Ground Truth";
ground_truth_array = load_ground_truth_into_data(ground_truth_dir);
ground_truth = ground_truth_array{1}{1};
ground_truth_modifier = -1;
num_dpts_bef_aft_spike = 30;
check_how_GT_looks_on_every_wire_in_tetrode(tetrode_to_check,art_tetr_array,dir_with_og_recordings,ground_truth,ground_truth_modifier,num_dpts_bef_aft_spike)

%% calculate ground truth based on voltages for each wire
clc;
close all;
tetrode_to_check = "t239";
art_tetr_array = build_artificial_tetrode();
dir_with_og_recordings = "D:\spike_gen_data\Recordings By Channel\22_2Neuron400SecondRecordingWithLevel3Noise";
ground_truth_dir = "D:\generate_spike_scripts\2 Neuron Ground Truth";
ground_truth_array = load_ground_truth_into_data(ground_truth_dir);
ground_truth = ground_truth_array{1}{1};
ground_truth_modifier = -1;
num_dpts_bef_aft_spike = 30;

find_which_wire_produces_highest_overlap(tetrode_to_check,ground_truth,dir_with_og_recordings,art_tetr_array,num_dpts_bef_aft_spike,debug);