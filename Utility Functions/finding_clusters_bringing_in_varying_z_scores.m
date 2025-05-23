function [] = finding_clusters_bringing_in_varying_z_scores(dir_with_pre_computed,varying_z_scores,tetrodes_to_check,min_overlap_percentage,debug,grades_that_matter,names_of_grades)
%the important part of this function will be to find every cluster that might appear given various z_scores
%and to try and assign some kind of system, so that we can see what clusters appear given what z_score
%and in the case of the same cluster appearing over multiple z_scores then who has the best representation of this cluster

%grade all the clusters across varying z_scores
table_of_cluster_classification = grade_clusters_ver_2(generic_dir_with_grades,generic_dir_with_outputs,possible_z_scores,list_of_tetrodes_to_check,debug,relevant_grades,relevant_grade_names,dir_to_save_figs_to);

for tetrode_counter=1:length(tetrodes_to_check)

    current_tetrode = tetrodes_to_check(tetrode_counter);
    %these arrays are full of the results of clustering with different cutting thresholds (z_scores)
    [aligned_cluster_data,grades_cluster_data,timestamps_cluster_data,idx_cluster_data,output_cluster_data] = find_all_clusters_for_current_tetrode(varying_z_scores,dir_with_pre_computed,current_tetrode);

    %now we will look for overlap given these clusters and their timestamps in order to see which clusters are the same and which are unique to some z_scores
    table_of_varying_z_score_info =check_timestamp_overlap_between_clusters(grades_cluster_data,timestamps_cluster_data,idx_cluster_data,varying_z_scores,min_overlap_percentage,grades_that_matter,names_of_grades,tetrodes_to_check,current_tetrode,dir_with_pre_computed);

    %now given that we have this table we can now check to see which
    %z score gives the best/only representation of the cluster
    %will also plot debugging plots in this stage if so desired
    find_best_representation_of_clusters(table_of_varying_z_score_info,aligned_cluster_data,idx_cluster_data,grades_cluster_data,current_tetrode,varying_z_scores,debug,names_of_grades,grades_that_matter)
    disp("Finished "+string(tetrode_counter)+ "/"+string(length(tetrode_counter)));
end


end