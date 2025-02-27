function [best_appearences_of_cluster,timestamps_of_best_clusters,table_of_overlapping_clusters] = id_best_rep_of_cl_using_cont_table_hpc(neurons_of_graded_cont_table,min_overlap_percentage,debug,generic_dir_with_grades,generic_dir_with_outputs,save_results,time_delta,refinement_pass,dir_to_save_to)
%the important part of this function will be to find every cluster that might appear given various z_scores
%and to try and assign some kind of system, so that we can see what clusters appear given what z_score
%and in the case of the same cluster appearing over multiple z_scores then who has the best representation of this cluster

if ~exist(dir_to_save_to,"dir")
    dir_to_save_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_to);
end


table_of_only_neurons = neurons_of_graded_cont_table;

%get the data of all the clusters found to be neurons

[grades_array,~,~,timestamp_array,idx_array]= get_data_of_neurons_identified_as_clusters_hpc(table_of_only_neurons,generic_dir_with_grades,generic_dir_with_outputs,refinement_pass);
home_dir = cd(dir_to_save_to);
if save_results
    % save('aligned.mat', 'aligned_array', '-v7.3');
    save("grades.mat","grades_array");
    save("timestamp_array.mat","timestamp_array");
    save("idx.mat","idx_array");
end
cd(home_dir);

%now see which clusters are just the same cluster in different configurations
table_of_overlapping_clusters =check_timestamp_overlap_between_clusters_hpc_ver_2(table_of_only_neurons,timestamp_array,min_overlap_percentage,time_delta);
home_dir = cd(dir_to_save_to);
if save_results
    save("table of overlapping clusters.mat","table_of_overlapping_clusters")
end
cd(home_dir);
%now given that we have this table we can now check to see which
%z score gives the best/only representation of the cluster
%will also plot debugging plots in this stage if so desired
best_appearences_of_cluster = return_best_conf_for_cluster(table_of_overlapping_clusters,table_of_only_neurons,grades_array,debug,timestamp_array,min_overlap_percentage);
if ~refinement_pass
    home_dir = cd(dir_to_save_to);
    if save_results
        save("table of best appearences of cluster.mat","best_appearences_of_cluster");
    end
    cd(home_dir)
    timestamps_of_best_clusters = timestamp_array(best_appearences_of_cluster{:,"idx of its location in arrays"});
else
    home_dir = cd(dir_to_save_to);
    if save_results
        save("table of best appearences of cluster.mat","best_appearences_of_cluster");
    end
    % cd(home_dir)
    timestamps_of_best_clusters = timestamp_array;
    best_appearences_of_cluster = table(table_of_only_neurons{:,"tetrode"},table_of_only_neurons{:,"cluster"},table_of_only_neurons{:,"z-score"},'VariableNames',["Tetrode","Cluster","Z Score"]);

end
end