function [] = find_best_representation_of_clusters(table_of_varying_z_score_info,aligned_spike_cluster_data,idx_cluster_data,grades_cluster_data,current_tetrode,varying_z_scores,debug,names_of_grades,grades_that_matter)

for i=1:size(table_of_varying_z_score_info,1)
    current_z_score = table_of_varying_z_score_info{i,1};
    current_cluster = table_of_varying_z_score_info{i,2};
    array_of_overlap_percentages = split(table_of_varying_z_score_info{i,3},"|");
    array_of_other_appearences = split(table_of_varying_z_score_info{i,4},"|");

    index_with_primary_data = find(varying_z_scores==current_z_score);
    grades_of_primary_z_score = grades_cluster_data{index_with_primary_data};

    grades_of_primary_cluster = grades_of_primary_z_score(current_cluster,grades_that_matter);

    all_grades_of_primary_cluster = grades_of_primary_cluster;

    cluster_names_of_primary_cluster = [current_cluster];
    all_z_scores_of_primary_cluster = [current_z_score];
    secondary_array_of_overlap_percentages = ["100%";array_of_overlap_percentages];
    for j=1:length(array_of_other_appearences)
        all_data = split(array_of_other_appearences(j),":");

        if debug
            clc;
            disp(all_data)
        end

        if all_data==""
            continue;
        end
        % display([i,j])
        % display(all_data)
        just_z_score_and_cluster = split(all_data(2)," Cluster ");
        compare_against_z_score = str2double(just_z_score_and_cluster(1));
        

        all_z_scores_of_primary_cluster = [all_z_scores_of_primary_cluster,compare_against_z_score];
        compare_against_cluster = str2double(just_z_score_and_cluster(2));
        compare_against_overlap_percentage = array_of_overlap_percentages(j);

        index_with_compare_data = find(varying_z_scores == compare_against_z_score);
        grades_of_compare_z_score = grades_cluster_data{index_with_compare_data};
        grades_of_compare_cluster = grades_of_compare_z_score(compare_against_cluster,grades_that_matter);

        all_grades_of_primary_cluster = [all_grades_of_primary_cluster;grades_of_compare_cluster];
        cluster_names_of_primary_cluster = [cluster_names_of_primary_cluster,compare_against_cluster];


    end
    if debug
        number_of_rows = length(array_of_other_appearences)+1;
        number_of_cols = 6;
        plot_clusters_of_tetrodes_across_z_scores(all_grades_of_primary_cluster,secondary_array_of_overlap_percentages,number_of_rows,number_of_cols,names_of_grades,all_z_scores_of_primary_cluster,current_tetrode,aligned_spike_cluster_data,idx_cluster_data,cluster_names_of_primary_cluster)

        close all;
    end





end

end