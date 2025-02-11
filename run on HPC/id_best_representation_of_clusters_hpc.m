function [best_appearences_of_cluster,timestamps_of_best_clusters,table_of_overlapping_clusters] = id_best_representation_of_clusters_hpc(varying_z_scores,tetrodes_to_check,min_overlap_percentage,debug,grades_that_matter,names_of_grades,generic_dir_with_grades,generic_dir_with_outputs,dir_to_save_figs_to,load_previous_attempt,save_results,time_delta,refinement_pass,dir_to_save_to)
%the important part of this function will be to find every cluster that might appear given various z_scores
%and to try and assign some kind of system, so that we can see what clusters appear given what z_score
%and in the case of the same cluster appearing over multiple z_scores then who has the best representation of this cluster

if ~exist(dir_to_save_to,"dir")
    dir_to_save_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_to);
end



table_of_cluster_classification = grade_clusters_hpc(generic_dir_with_grades,generic_dir_with_outputs,varying_z_scores,tetrodes_to_check,debug,grades_that_matter,names_of_grades,dir_to_save_figs_to,refinement_pass);
home_dir = cd(dir_to_save_to);
if save_results
    save(" table_of_cluster_classification_data.mat","table_of_cluster_classification");
end
cd(home_dir);



table_of_only_neurons = table_of_cluster_classification(contains(table_of_cluster_classification.category,"Neuron","IgnoreCase",true),:);

%get the data of all the clusters found to be neurons

[grades_array,~,aligned_array,timestamp_array,idx_array]= get_data_of_neurons_identified_as_clusters_hpc(table_of_only_neurons,generic_dir_with_grades,generic_dir_with_outputs,refinement_pass);
home_dir = cd(dir_to_save_to);
if save_results
    save(dir_to_save_to+" aligned_array.mat","aligned_array");
    save(dir_to_save_to+" grades.mat","grades_array");
    save(dir_to_save_to+" timestamp_array.mat","timestamp_array");
    save(dir_to_save_to+" idx.mat","idx_array");
end
cd(home_dir);

%now see which clusters are just the same cluster in different
%configurations


table_of_overlapping_clusters =check_timestamp_overlap_between_clusters_ver_3(table_of_only_neurons,timestamp_array,min_overlap_percentage,time_delta);
home_dir = cd(dir_to_save_to);
if save_results
    save(dir_to_save_to+" table of overlapping clusters.mat","table_of_overlapping_clusters")
end
cd(home_dir);
%now given that we have this table we can now check to see which
%z score gives the best/only representation of the cluster
%will also plot debugging plots in this stage if so desired
if ~refinement_pass
    best_appearences_of_cluster = return_best_conf_for_cluster(table_of_overlapping_clusters,table_of_only_neurons,grades_array,debug,timestamp_array,min_overlap_percentage);

    if save_results
        save(dir_to_save_to+" table of best appearences of cluster.mat","best_appearences_of_cluster");
    end


    timestamps_of_best_clusters = timestamp_array(best_appearences_of_cluster{:,"idx of its location in arrays"});
else
    timestamps_of_best_clusters = timestamp_array;
    best_appearences_of_cluster = table(table_of_only_neurons{:,"tetrode"},table_of_only_neurons{:,"cluster"},table_of_only_neurons{:,"z-score"},'VariableNames',["Tetrode","Cluster","Z Score"]);
end
end