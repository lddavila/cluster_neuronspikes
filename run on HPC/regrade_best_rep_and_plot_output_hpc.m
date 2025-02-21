function [] = regrade_best_rep_and_plot_output_hpc(generic_dir_with_grades,generic_dir_with_outputs,table_of_best_rep,refinement_pass,grades_to_check,names_of_grades)
%relevant grades include
%2 cv 2
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
%34 min bhat distance from all the clusters in the current configuration which are likely to be co activation

%possible classifications
%probably a neuron - passes all tests that I care about so far
%might be a neuron - doesn't pass all the test, but is saved by its bhat distance from clusters identified as multiunit activity
%probably multi unit activity - a cluster which does not tie to a neuron, but may tie to a helpful multi unit activity cluster, therefore we do not purge it

%10000 default rows are preallocated as an upper bound on clusters
%its unlikely that all rows will be filled, and in case they are you can
%simply preallocate more

art_tetr_array = build_artificial_tetrode();


list_of_tetrodes_to_check = unique(table_of_best_rep.Tetrode);
number_of_times_the_for_loop_will_run = size(table_of_best_rep,1);

%slice the data
table_of_best_rep_in_cell_format = cell(1,size(table_of_best_rep,1));
for i=1:size(table_of_best_rep,1)
    table_of_best_rep_in_cell_format{i} = table_of_best_rep(i,:);
end

parfor tetrode_counter=1:length(list_of_tetrodes_to_check)
    current_tetrode = list_of_tetrodes_to_check(tetrode_counter);
    channels_of_curr_tetr = art_tetr_array(tetrode_counter,:);
    current_z_score = table_of_best_rep.("Z Score")(tetrode_counter);
    current_clust = table_of_best_rep.("Cluster")(tetrode_counter);
    if ~refinement_pass
        dir_with_grades = generic_dir_with_grades + " "+string(current_z_score) + " grades";
        dir_with_outputs = generic_dir_with_outputs +string(current_z_score);
    else
        dir_with_grades = generic_dir_with_grades;
        dir_with_outputs = generic_dir_with_outputs;
    end
    [current_grades,~,aligned,~,idx_b4_filt] = import_data_hpc(dir_with_grades,dir_with_outputs,current_tetrode,refinement_pass);
    if any(isnan(current_grades))
        continue;
    end
    table_of_cluster_classification = table(repelem("default value",size(current_grades,1),1),repelem("default value",size(current_grades,1),1),nan(size(current_grades,1),1),nan(size(current_grades,1),1),'VariableNames',["category","tetrode","cluster","z-score"]);
    % list_of_clusters = 1:length(idx_b4_filt);
    % idx_aft_filt = cell(1,length(idx_b4_filt));
    for cluster_counter=1:size(current_grades,1)
        current_cluster_grades = current_grades(cluster_counter,:);
        current_cluster_category = classify_clusters_based_on_grades(current_cluster_grades);
        table_of_cluster_classification{cluster_counter,1} = current_cluster_category;
        table_of_cluster_classification{cluster_counter,2} = current_tetrode;
        table_of_cluster_classification{cluster_counter,3} = cluster_counter;
        table_of_cluster_classification{cluster_counter,4} = current_z_score;

        % sprintf("%i / %i Finished",tetrode_counter,length(list_of_tetrodes_to_check))
    end


    disp("Finished "+string(tetrode_counter)+" /"+string(length(number_of_times_the_for_loop_will_run)))
    clc;
    current_clusters_category = table_of_cluster_classification{:,"category"};
    plot_the_clusters_hpc(channels_of_curr_tetr,idx_b4_filt,"before",aligned,current_clusters_category,current_tetrode,current_z_score,current_clust,grades_to_check,names_of_grades,current_grades);


end


end