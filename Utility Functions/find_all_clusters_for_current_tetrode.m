function [aligned_cluster_data,grades_cluster_data,timestamps_cluster_data,idx_cluster_data,output_cluster_data] = find_all_clusters_for_current_tetrode(varying_z_scores,precomputed_dir)
aligned_cluster_data= cell(1,length(varying_z_scores));
grades_cluster_data = cell(1,length(varying_z_scores));
timestamps_cluster_data = cell(1,length(varying_z_scores));
idx_cluster_data = cell(1,length(varying_z_scores));
output_cluster_data = cell(1,length(varying_z_scores));

for z_score_counter =1:length(varying_z_scores)
    current_z_score = varying_z_scores(z_score_counter);
    dir_with_grades = ; % update this with appropriate dynamic string
    dir_with_outputs = ;%update this with appropriate string
    [grades_cluster_data{z_score_counter},output_cluster_data{z_score_counter},aligned_cluster_data{z_score_counter},timestamps_cluster_data{z_score_counter},idx_cluster_data{z_score_counter}] =import_data(dir_with_grades,dir_with_outputs,current_tetrode);
end
end