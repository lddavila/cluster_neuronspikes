function [table_of_varying_z_score_info] = check_timestamp_overlap_between_clusters(aligned_cluster_data,grades_cluster_data,timestamps_cluster_data,idx_cluster_data,output_cluster_data,varying_z_scores,min_overlap_percentage)
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

grades_that_matter = [2,9,28,29,30,31,32,33,34,35,36];
names_of_grades = ["CV(2)","Min Bhat/Corruption(9)","Skewness(28)","Distance From Template",""];

table_of_varying_z_score_info = table(NaN,NaN,"",'VariableNames',["Z Score","Cluster #","Other Appearences"]);
array_of_grades_for_multiple_appearences = cell(0,1);

for z_score_counter=1:length(varying_z_scores)
    current_z_score = varying_z_scores(z_score_counter);
    current_z_score_idx = idx_cluster_data{z_score_counter};
    current_z_score_timestamps = timestamps_cluster_data{z_score_counter};
    current_z_score_grades = grades_cluster_data{z_score_counter};
    for current_cluster_counter=1:size(current_z_score_grades,1)
        current_cluster_idx  = current_z_score_idx{current_cluster_counter};
        current_cluster_timestamps = current_z_score_timestamps(current_cluster_idx);
        current_cluster_grades = current_z_score_grades(current_cluster_counter,grades_that_matter);
        other_appearences_of_this_cluster = [];
        for compare_against_z_score_counter=1:length(varying_z_scores)
            if compare_against_z_score_counter==z_score_counter
                continue;
            end
            compare_against_z_score= varying_z_scores(compare_against_z_score_counter);
            compare_against_z_score_idx = idx_cluster_data{compare_against_z_score_counter};
            compare_against_z_score_timestamps = timestamps_cluster_data{compare_against_z_score_counter};
            compare_against_z_score_grades = grades_cluster_data{compare_against_z_score_counter};

            for compare_against_cluster_counter=1:size(compare_against_z_score_grades,1)
                compare_against_cluster_idx = compare_against_z_score_idx{compare_against_cluster_counter};
                compare_against_cluster_timestamps = compare_against_z_score_timestamps{compare_against_cluster_counter};
                compare_against_cluster_grades = compare_against_z_score_grades(compare_against_cluster_counter,:);

                smaller_cluster_size = min(length(compare_against_cluster_timestamps),length(current_cluster_timestamps));

                number_of_timestamps_in_common = intersect(current_cluster_timestamps,compare_against_cluster_timestamps);

                if number_of_timestamps_in_common/smaller_cluster_size > min_overlap_percentage
                    other_appearences_of_this_cluster = [other_appearences_of_this_cluster,"Z_Score:"+string(compare_against_z_score)+" Cluster"+string(compare_against_cluster_counter)];

                end

            end
        end
    end

end
end