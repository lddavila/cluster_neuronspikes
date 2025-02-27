function [] = run_overlap_checks_for_blind_pass_using_cont_table(parent_dir_of_data_saving,generic_dir_with_outputs,generic_dir_with_grades,file_path_of_ground_truth,dir_of_timestamps,filepath_of_cont_table)
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
disp("Finished adding File Path");

min_overlap_percentage = 15;
% generic_dir_with_grades = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass min z_score";
% generic_dir_with_outputs = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass_results min z_score";

save_results = true;
refinement_pass = false;
dir_to_save_to = "Contamination Table Blind Pass Min Overlap Threshold " + string(min_overlap_percentage);
home_dir = cd(parent_dir_of_data_saving);
disp("Finished getting into saving dir")

%load the contamination table
contamination_table = importdata(filepath_of_cont_table);
[~,neurons_of_graded_contamination_table,~] = grade_the_results_of_cont_table(contamination_table,1:100);

disp("Finished loading contamination table")
% ground_truth_dir = "D:\spike_gen_data\Recording By Channel Ground Truth";
ground_truth_array = importdata(file_path_of_ground_truth);
% dir_of_timestamps = "D:\spike_gen_data\Recordings By Channel Timestamps\0_100Neuron300SecondRecordingWithLevel3Noise";
timestamps = importdata(fullfile(dir_of_timestamps,"timestamps.mat"));
disp("Finished importing timestamps and ground truth")
time_delta = 0.004;
debug =0;
disp("Beginning identification of best cluster using contamination table")
[best_appearences_of_cluster_from_blind_pass,timestamps_of_best_clusters_from_blind_pass,table_of_overlapping_clusters_from_blind_pass] = id_best_rep_of_cl_using_cont_table_hpc(neurons_of_graded_contamination_table,min_overlap_percentage,debug,generic_dir_with_grades,generic_dir_with_outputs,save_results,time_delta,refinement_pass,dir_to_save_to);
disp("finished identifying the best clusters using contamination table")
save("bpass_results_of_id_best_rep_of_clusters using cont table"+string(min_overlap_percentage)+" Percent.mat","best_appearences_of_cluster_from_blind_pass","timestamps_of_best_clusters_from_blind_pass","table_of_overlapping_clusters_from_blind_pass");
disp("Finished saving results")
disp("Beginning retriving accuracy table")
accuracy_table = compare_timestamps_to_ground_truth_ver_3(ground_truth_array{1},timestamps_of_best_clusters_from_blind_pass,timestamps,time_delta,debug,best_appearences_of_cluster_from_blind_pass);
save("accuracy_table Min overlap"+string(min_overlap_percentage)+" Percent","accuracy_table")
disp("Finished calculating and saving accuracy table")
grades_to_check = ["overlap_with_unit"];
plot_the_configurations = false;
%plot_debugging_sets(dir_of_precomputed,accuracy_table,40,grades_to_check,plot_the_configurations,time_delta);
cd(home_dir);

end