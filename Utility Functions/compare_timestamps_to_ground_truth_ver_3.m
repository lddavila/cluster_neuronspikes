function [table_of_info] = compare_timestamps_to_ground_truth_ver_3(ground_truth,timestamps_of_clusters,timestamps,time_delta,debug,best_appearences_of_cluster,dir_of_precomputed)
%ground_truth - an array of all the times that a unit actualy fired (got from mearec libraries)
%timestamps_of_clusters - the timestamps of the best representation of clusters
%timestamps - the timestamps array of your recording, generated during recording
%time_delta how long before/after the ground truth spike to be considered true (in seconds, must be positive)
ground_truth_timestamps = get_corresponding_timestamp_for_each_unit_with_delta(timestamps,ground_truth,0);


accuracy = [];
unit_id = [];
overlap_with_unit = [];
cluster_number = [];
number_of_false_positives = [];
number_of_true_positives = [];
agreement_scores = [];
recall_scores = [];
precision_scores = [];
og_tetr_and_clust_num = [];

%first for each of the ground truth timestamps check their z_score in the
%tetrodes identified as "Best"
for j=1:size(timestamps_of_clusters,2)
    timestamps_of_current_cluster = timestamps_of_clusters{j} ;
    
    for i=1:size(ground_truth_timestamps,2)
        unit_timestamps = ground_truth_timestamps{i};
        %extend the unit timestamps with a range equivalent to the
        %timestamp delta

        if debug
            figure;
            histogram(timestamps_of_current_cluster,1000)
            hold on;
            histogram(unit_timestamps, 100)
            legend(["Cluster TS", "Unit TS"])
            close all;
        end

        number_of_timestamps_in_both_aka_tp = find_number_of_true_positives_given_a_time_delta(unit_timestamps,timestamps_of_current_cluster,time_delta);
        %number_of_timestamps_in_both_aka_tp = length(timestamps_in_both);

        in_unit_but_not_in_cluster_aka_fn = setdiff(unit_timestamps,timestamps_of_current_cluster);
        number_of_false_negatives = length(in_unit_but_not_in_cluster_aka_fn);

        false_positives = length(setdiff(timestamps_of_current_cluster,unit_timestamps));



        current_accuracy = number_of_timestamps_in_both_aka_tp/(length(in_unit_but_not_in_cluster_aka_fn) +number_of_timestamps_in_both_aka_tp + false_positives) * 100;

        overlap_with_unit = [overlap_with_unit;((number_of_timestamps_in_both_aka_tp/length(unit_timestamps))*100)];
        accuracy = [accuracy;current_accuracy];
        cluster_number = [cluster_number;j];
        unit_id = [unit_id;i];
        number_of_false_positives = [number_of_false_positives;false_positives];
        number_of_true_positives = [number_of_true_positives;number_of_timestamps_in_both_aka_tp];


        current_agreement_score = number_of_timestamps_in_both_aka_tp/(number_of_timestamps_in_both_aka_tp+false_positives+number_of_false_negatives);
        agreement_scores = [agreement_scores;current_agreement_score];

        current_recall_score =number_of_timestamps_in_both_aka_tp / (number_of_timestamps_in_both_aka_tp + number_of_false_negatives);
        recall_scores = [recall_scores;current_recall_score];

        current_precision_rate = number_of_timestamps_in_both_aka_tp / (number_of_timestamps_in_both_aka_tp+ false_positives);
        precision_scores = [precision_scores;current_precision_rate];

        og_tetr_and_clust_num = [og_tetr_and_clust_num;best_appearences_of_cluster{j,"Tetrode"}+"_"+ best_appearences_of_cluster{j,"Cluster"}+"_Zscore_"+num2str(best_appearences_of_cluster{j,"Z Score"})];
    end
    disp("Finished "+string(j)+"/"+size(timestamps_of_clusters,2));
end
table_of_info = table(cluster_number,unit_id,accuracy,overlap_with_unit,number_of_false_positives,number_of_true_positives,agreement_scores,recall_scores,precision_scores,og_tetr_and_clust_num);
end