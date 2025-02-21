function [] = check_horizontally_other_appearences_of_given_cluster(list_of_tetrodes,precomputed_dir,name_of_current_tetrode,current_z_score,current_cluster_timestamps,min_overlap_percentage)
other_appearences_of_this_cluster = "";
overlap_percentages_of_this_cluster = "";
other_tetrodes_where_cluster_appears = "";
for compare_against_tetrode_counter=1:length(list_of_tetrodes)
    compare_against_tetrode = list_of_tetrodes(compare_against_tetrode_counter);
    if compare_against_tetrode == name_of_current_tetrode
        continue;
    end
    [grades,~,~,reg_timestamps,idx] =find_all_clusters_for_specified_tetrode(precomputed_dir,compare_against_tetrode,current_z_score);

    for compare_against_cluster_counter=1:size(grades,1)
        if isnan(grades)
            continue;
        end
        compare_against_cluster_idx = idx{compare_against_cluster_counter};
        compare_against_cluster_timestamps = reg_timestamps(compare_against_cluster_idx);

        smaller_cluster_size = min(length(compare_against_cluster_timestamps),length(current_cluster_timestamps));

        number_of_timestamps_in_common = length(intersect(current_cluster_timestamps,compare_against_cluster_timestamps));

        actual_overlap_percentage = (number_of_timestamps_in_common / smaller_cluster_size) * 100;

        if actual_overlap_percentage > min_overlap_percentage
            if other_appearences_of_this_cluster==""
                other_appearences_of_this_cluster =other_appearences_of_this_cluster+"Z_Score:"+string(compare_against_z_score)+" Cluster "+string(compare_against_cluster_counter);
                overlap_percentages_of_this_cluster = overlap_percentages_of_this_cluster+actual_overlap_percentage+"%";
                other_tetrodes_where_cluster_appears = other_tetrodes_where_cluster_appears +compare_against_tetrode;
            else
                other_appearences_of_this_cluster =other_appearences_of_this_cluster+"|Z_Score:"+string(compare_against_z_score)+" Cluster "+string(compare_against_cluster_counter);
                overlap_percentages_of_this_cluster = overlap_percentages_of_this_cluster+"|"+actual_overlap_percentage+"%";
                other_tetrodes_where_cluster_appears = other_tetrodes_where_cluster_appears +"|"+compare_against_tetrode;
            end

        end
    end

end
end