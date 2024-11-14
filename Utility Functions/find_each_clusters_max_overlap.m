function [overlap_percentage_for_clusters,names_of_units_with_max_overlap] = find_each_clusters_max_overlap(names_of_clusters,cluster_idxs,reg_timestamps,ground_truth,timestamps)
overlap_percentage_for_clusters =[];
names_of_units_with_max_overlap = [];
for i=1:length(names_of_clusters)
    current_cluster = names_of_clusters(i);
    current_cluster_timestamps = reg_timestamps(cluster_idxs{current_cluster});
    max_overlap = 0;
    name_of_unit_with_max_over_lap = "None";
    for j=1:length(ground_truth)
        current_unit_name = "Unit "+string(j);
        timestamps_in_unit = ground_truth{j};
        timestamps_in_unit = timestamps(timestamps_in_unit);
        number_of_timestamps_in_unit = length(timestamps_in_unit);
        number_of_timestamps_in_both_unit_and_cluster = length(intersect(current_cluster_timestamps,timestamps_in_unit));
        percentage_of_overlap = (number_of_timestamps_in_both_unit_and_cluster/(number_of_timestamps_in_unit)) * 100;
        if percentage_of_overlap > max_overlap
            max_overlap = percentage_of_overlap;
            name_of_unit_with_max_over_lap = current_unit_name;
        end
    end
    overlap_percentage_for_clusters = [overlap_percentage_for_clusters;max_overlap];
    names_of_units_with_max_overlap = [names_of_units_with_max_overlap;name_of_unit_with_max_over_lap];

end
end