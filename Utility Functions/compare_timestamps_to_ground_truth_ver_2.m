function [table_of_info] = compare_timestamps_to_ground_truth_ver_2(ground_truth,timestamps_of_clusters,timestamps)
ground_truth_timestamps = get_corresponding_timestamp_for_each_unit(timestamps,ground_truth);
accuracy = [];
unit_id = [];
cluster_number = [];

for j=1:size(timestamps_of_clusters,2)
    timestamps_of_current_cluster = timestamps_of_clusters{j};
    for i=1:size(ground_truth_timestamps,2)
        unit_timestamps = ground_truth_timestamps{i};

        timestamps_in_both = intersect(timestamps_of_current_cluster,unit_timestamps.');
        number_of_timestamps_in_both = length(timestamps_in_both);

        in_unit_but_not_in_cluster = setdiff(unit_timestamps,timestamps_of_current_cluster);

        false_positives = setdiff(timestamps_of_current_cluster,unit_timestamps);


        current_accuracy = number_of_timestamps_in_both/(length(in_unit_but_not_in_cluster) +number_of_timestamps_in_both + length(false_positives)) * 100;


        accuracy = [accuracy;current_accuracy];
        cluster_number = [cluster_number;j];
        unit_id = [unit_id;i];



    end
    disp("Finished "+string(j)+"/"+size(timestamps_of_clusters,2));
end
table_of_info = table(accuracy,cluster_number,unit_id);
end