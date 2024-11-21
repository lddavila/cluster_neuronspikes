function [] = finding_clusters_bringing_in_varying_z_scores(dir_with_pre_computed,varying_z_scores,tetrodes_to_check,debug)
%the important part of this function will be to find every cluster that might appear given various z_scores
%and to try and assign some kind of system, so that we can see what clusters appear given what z_score
%and in the case of the same cluster appearing over multiple z_scores then who has the best representation of this cluster
for tetrode_counter=1:length(tetrodes_to_check)
    %these arrays are full of the results of clustering with different cutting thresholds (z_scores)
    [aligned_cluster_data,grades_cluster_data,timestamps_cluster_data,idx_cluster_data,output_cluster_data] = find_all_clusters_for_current_tetrode(varying_z_scores,precomputed_dir);

    %now we will look for overlap given these clusters and their timestamps in order to see which clusters are the same and which are unique to some z_scores
    
end


end