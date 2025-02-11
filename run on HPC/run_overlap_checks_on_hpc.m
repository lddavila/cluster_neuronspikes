function [] = run_overlap_checks_on_hpc()
% now run regrading on this reclustered data set 
clc;
%close all;
dir_with_output = "/gpfs/home/lddavila/spike_gen_data/TEST refinement_pass_results min amp 0 Top 4 Channels";
varying_z_scores = [0];
tetrodes_to_check = strcat("t",string(1:148));
min_overlap_percentage = 10;
debug = 0;
grades_that_matter = [2,31,30,32,8,28,29,33,34,9,35,36,37,38,40,41];
names_of_grades =["CV (2)","Amp. (31)","Hist. Sym. (30)","R-Wire Amp(32)","TM(8)","CL. Skew(28)","TM New()","Chance Of M.U.A(33)","Min B-Dist From M.U.A(34)","Min B-Dist To Neighbor(9)","TM Cluster Level(35)","TM Rep Wire Level(36)","Min Bhat Best Dim","Best Dim","SNR","burst ratio(41)"] ;
generic_dir_with_grades = dir_with_output +" grades";
generic_dir_with_outputs = dir_with_output;
dir_to_save_figs_to = "";
load_previous_attempt = false;
save_results = true;
time_delta = 0.0004;
refinement_pass = true;
dir_to_save_to = "Reclustered Pass Min Overlap 10";
[best_appearences_of_cluster_from_reclustered_pass,timestamps_of_best_clusters_from_reclustered_pass,table_of_overlapping_clusters_from_reclustered_pass]= id_best_representation_of_clusters_hpc(varying_z_scores,tetrodes_to_check,min_overlap_percentage,debug,grades_that_matter,names_of_grades,generic_dir_with_grades,generic_dir_with_outputs,dir_to_save_figs_to,load_previous_attempt,save_results,time_delta,refinement_pass,dir_to_save_to);
save("./"+dir_to_save_to+"/output_of_id_best_rep_of_clusters.mat","best_appearences_of_cluster_from_reclustered_pass","timestamps_of_best_clusters_from_reclustered_pass","table_of_overlapping_clusters_from_reclustered_pass");
end