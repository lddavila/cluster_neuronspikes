function [table_of_varying_z_score_info] = check_timestamp_overlap_between_clusters(grades_cluster_data,timestamps_cluster_data,idx_cluster_data,varying_z_scores,min_overlap_percentage,grades_that_matter,names_of_grades,list_of_tetrodes,name_of_current_tetrode,precomputed_dir)
%this function should check which clusters are unique to which cutting threshold and which appear between cutting thresholds
%it will return a list which will indicate which are shared, which are unique
%and in the case of shared it will indicate which cutting threshold represents it best given the available grades
%grades that I will use to compare best are as follows

%relevant grades include
%2 CV 2
%9 min bhat 9
%28 skewness of cluster
%29 measure the difference between the cluster's individual spikes and the
%cluster's spike templates
%30 Incompleteness using histogram symmetry
%31 Classification of cluster amplitude
%32 classification of cluster amplitude based only on rep wire
%33 How likely a cluster is to be multi unit activity
%1 is definitely multi unit activity
%3 is definitely NOT multiunit activity
%2 could go either way
%34 bhat distance from possible multi unit activity clusters
%35 tightness of the cluster, using Euclidean distance
%It measures the euc distance of the mean waveform to all spikes in the peak then divides it by the max euc distance
%thus this gradewill be from 0-1 with closer to 0 being better
%36 same as 35 but only using rep wire spikes


table_of_varying_z_score_info = table(NaN,NaN,"","","",'VariableNames',["Z Score","Cluster #","Overlap %","Other Appearences","Tetrode"]);
for z_score_counter=1:length(varying_z_scores)
    current_z_score = varying_z_scores(z_score_counter);
    current_z_score_idx = idx_cluster_data{z_score_counter};
    current_z_score_timestamps = timestamps_cluster_data{z_score_counter};
    current_z_score_grades = grades_cluster_data{z_score_counter};
    for current_cluster_counter=1:size(current_z_score_grades,1)
        if isscalar(current_z_score_idx)
            continue;
        end
        current_cluster_idx  = current_z_score_idx{current_cluster_counter};
        current_cluster_timestamps = current_z_score_timestamps(current_cluster_idx);
        other_appearences_of_this_cluster = "";
        overlap_percentages_of_this_cluster = "";
        other_tetrodes_where_cluster_appears = "";
        %the following nested for loops will check vertically
        %ie the same tetrode but diferent z-score
        for compare_against_z_score_counter=1:length(varying_z_scores)
            if compare_against_z_score_counter==z_score_counter
                continue;
            end
            compare_against_z_score= varying_z_scores(compare_against_z_score_counter);
            compare_against_z_score_idx = idx_cluster_data{compare_against_z_score_counter};
            compare_against_z_score_timestamps = timestamps_cluster_data{compare_against_z_score_counter};
            compare_against_z_score_grades = grades_cluster_data{compare_against_z_score_counter};

            for compare_against_cluster_counter=1:size(compare_against_z_score_grades,1)
                if isscalar(compare_against_z_score_idx)
                    continue
                end
                compare_against_cluster_idx = compare_against_z_score_idx{compare_against_cluster_counter};
                compare_against_cluster_timestamps = compare_against_z_score_timestamps(compare_against_cluster_idx);

                smaller_cluster_size = min(length(compare_against_cluster_timestamps),length(current_cluster_timestamps));

                number_of_timestamps_in_common = length(intersect(current_cluster_timestamps,compare_against_cluster_timestamps));

                actual_overlap_percentage = (number_of_timestamps_in_common / smaller_cluster_size) * 100;

                if actual_overlap_percentage > min_overlap_percentage
                    if other_appearences_of_this_cluster==""
                        other_appearences_of_this_cluster =other_appearences_of_this_cluster+"Z_Score:"+string(compare_against_z_score)+" Cluster "+string(compare_against_cluster_counter);
                        overlap_percentages_of_this_cluster = overlap_percentages_of_this_cluster+actual_overlap_percentage+"%";
                        other_tetrodes_where_cluster_appears = other_tetrodes_where_cluster_appears +name_of_current_tetrode;
                    else
                        other_appearences_of_this_cluster =other_appearences_of_this_cluster+"|Z_Score:"+string(compare_against_z_score)+" Cluster "+string(compare_against_cluster_counter);
                        overlap_percentages_of_this_cluster = overlap_percentages_of_this_cluster+"|"+actual_overlap_percentage+"%";
                        other_tetrodes_where_cluster_appears = other_tetrodes_where_cluster_appears +"|"+ name_of_current_tetrode;
                    end

                end

            end

        end

        single_row_of_varying_z_score_info = table(current_z_score,current_cluster_counter,overlap_percentages_of_this_cluster,other_appearences_of_this_cluster,other_tetrodes_where_cluster_appears,'VariableNames',["Z Score","Cluster #","Overlap %","Other Appearences","Tetrode"]);
        table_of_varying_z_score_info = [table_of_varying_z_score_info;single_row_of_varying_z_score_info];
    end

end
table_of_varying_z_score_info=table_of_varying_z_score_info(~any(ismissing(table_of_varying_z_score_info),2),:);
end