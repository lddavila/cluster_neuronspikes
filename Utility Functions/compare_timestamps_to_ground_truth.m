function [] = compare_timestamps_to_ground_truth(ground_truth,timestamps_of_clusters,timestamps,min_percentage_threshold)
tol = 0.000000000000000001;
ground_truth_timestamps = get_corresponding_timestamp_for_each_unit(timestamps,ground_truth);
for j=1:size(timestamps_of_clusters,2)
    timestamps_of_current_cluster = timestamps_of_clusters{j}  * 10^6;
    for i=1:size(ground_truth_timestamps,2)
        unit_timestamps = ground_truth_timestamps{i};
        unique_timestamps_in_unit_and_cluster = unique([timestamps_of_current_cluster.',unit_timestamps]);
        number_of_unique_timestamps_in_unit_and_cluster = length(unique_timestamps_in_unit_and_cluster);


        timestamps_in_both = intersect(timestamps_of_current_cluster,unit_timestamps.');
        number_of_timestamps_in_both = length(timestamps_in_both);

        timestamps_only_in_cluster = setdiff(timestamps_of_current_cluster,unit_timestamps);
        number_of_timestamps_only_in_cluster = length(timestamps_only_in_cluster);

        timestamps_only_in_unit = setdiff(unit_timestamps,timestamps_only_in_cluster);
        number_of_timestamps_only_in_unit =length(timestamps_only_in_unit) ;

        percentage_in_both = (number_of_timestamps_in_both/ number_of_unique_timestamps_in_unit_and_cluster) * 100; %True Positive
        % disp(percentage_in_both)
        percentage_only_in_cluster = (number_of_timestamps_only_in_cluster/number_of_unique_timestamps_in_unit_and_cluster) * 100; %false Positive
        percentage_in_only_unit = (number_of_timestamps_only_in_unit/number_of_unique_timestamps_in_unit_and_cluster) * 100; %false negative

        if percentage_in_both > min_percentage_threshold
            disp("Cluster " + string(j) + " has " + string(percentage_in_both)+"% in common with unit"+string(i));
            disp("Percentage only in cluster: "+ string(percentage_only_in_cluster)+"%");
            disp("Percentage only in unit: "+string(percentage_in_only_unit)+"%");
        end
    end
    disp("Finished "+string(j)+"/"+size(timestamps_of_clusters,2));
end
end