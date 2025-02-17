function [] = run_overlap_checks_for_blind_pass(parent_dir_of_data_saving,generic_dir_with_outputs,generic_dir_with_grades)
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
varying_z_scores = [4,5,6,7,8,9];
tetrodes_to_check = strcat("t",string(1:285));
min_overlap_percentage = 15;
debug = 0;
grades_that_matter = [2,31,30,32,8,28,29,33,34,9,35,36,37,38,40,41];
names_of_grades =["CV (2)","Amp. (31)","Hist. Sym. (30)","R-Wire Amp(32)","TM(8)","CL. Skew(28)","TM New()","Chance Of M.U.A(33)","Min B-Dist From M.U.A(34)","Min B-Dist To Neighbor(9)","TM Cluster Level(35)","TM Rep Wire Level(36)","Min Bhat Best Dim","Best Dim","SNR","burst ratio(41)"] ;
% generic_dir_with_grades = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass min z_score";
% generic_dir_with_outputs = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass_results min z_score";
dir_to_save_figs_to = "D:\OneDrive - The University of Texas at El Paso\Graded Clusters Z Score 4";
load_previous_attempt = true;
save_results = true;
time_delta = 0.0004;
refinement_pass = false;
dir_to_save_to = "Blind Pass Overlap Min Overlap Threshold " + string(min_overlap_percentage);
home_dir = cd(parent_dir_of_data_saving);
[best_appearences_of_cluster_from_blind_pass,timestamps_of_best_clusters_from_blind_pass,table_of_overlapping_clusters_from_blind_pass]= id_best_representation_of_clusters_hpc(varying_z_scores,tetrodes_to_check,min_overlap_percentage,debug,grades_that_matter,names_of_grades,generic_dir_with_grades,generic_dir_with_outputs,dir_to_save_figs_to,load_previous_attempt,save_results,time_delta,refinement_pass,dir_to_save_to);
save("blind_pass_results_of_id_best_rep_of_clusters.mat","best_appearences_of_cluster_from_blind_pass","timestamps_of_best_clusters_from_blind_pass","table_of_overlapping_clusters_from_blind_pass");
cd(home_dir);
end