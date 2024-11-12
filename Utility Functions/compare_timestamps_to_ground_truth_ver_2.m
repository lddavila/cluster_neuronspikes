function [table_of_info] = compare_timestamps_to_ground_truth_ver_2(ground_truth,timestamps_of_clusters,timestamps)
ground_truth_timestamps = get_corresponding_timestamp_for_each_unit(timestamps,ground_truth);
accuracy = [];
unit_id = [];
overlap_with_unit = [];
cluster_number = [];
number_of_false_positives = [];
number_of_true_positives = [];

for j=1:size(timestamps_of_clusters,2)
    timestamps_of_current_cluster = timestamps_of_clusters{j};
    for i=1:size(ground_truth_timestamps,2)
        unit_timestamps = ground_truth_timestamps{i};

        timestamps_in_both = intersect(timestamps_of_current_cluster,unit_timestamps.');
        number_of_timestamps_in_both = length(timestamps_in_both);

        in_unit_but_not_in_cluster = setdiff(unit_timestamps,timestamps_of_current_cluster);

        false_positives = setdiff(timestamps_of_current_cluster,unit_timestamps);


        current_accuracy = number_of_timestamps_in_both/(length(in_unit_but_not_in_cluster) +number_of_timestamps_in_both + length(false_positives)) * 100;

        overlap_with_unit = [overlap_with_unit;((number_of_timestamps_in_both/length(unit_timestamps))*100)];
        accuracy = [accuracy;current_accuracy];
        cluster_number = [cluster_number;j];
        unit_id = [unit_id;i];
        number_of_false_positives = [number_of_false_positives;false_positives];
        number_of_true_positives = [number_of_true_positives;number_of_timestamps_in_both];



    end
    disp("Finished "+string(j)+"/"+size(timestamps_of_clusters,2));
end
table_of_info = table(cluster_number,unit_id,accuracy,overlap_with_unit,number_of_false_positives);
end