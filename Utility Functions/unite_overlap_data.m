function [united_lists_of_overlap] = unite_overlap_data(table_of_overlapping_clusters)
rows_to_no_longer_use = boolean(zeros(size(table_of_overlapping_clusters,1),1));
united_lists_of_overlap = cell(1,100000);
united_lists_of_overlap_counter=1;
for i=1:size(table_of_overlapping_clusters,1)
    current_row_z_score = table_of_overlapping_clusters{i,"Z Score"};
    current_row_cluster_number = table_of_overlapping_clusters{i,"Cluster #"};
    other_appearences_z_score_and_cluster = split(table_of_overlapping_clusters{i,"Other Appearences"},"|");
    other_appearences_tetrode = split(table_of_overlapping_clusters{i,"Tetrode"},"|");
    other_appearences_data = strcat(other_appearences_tetrode," ",other_appearences_z_score_and_cluster);
    if rows_to_no_longer_use(i)
        disp("unite_overlap_data: Finished "+string(i)+"/"+string(size(table_of_overlapping_clusters,1)));
        continue;
    end
    rows_to_no_longer_use(i) = true;
    for j=1:size(table_of_overlapping_clusters,1)
        if rows_to_no_longer_use(j)
            continue;
        end
        secondary_row_z_score = table_of_overlapping_clusters{j,"Z Score"};
        secondary_row_cluster_number = table_of_overlapping_clusters{j,"Cluster #"};
        secondary_other_appearences_z_score_and_cluster = split(table_of_overlapping_clusters{j,"Other Appearences"},"|");
        secondary_other_appearences_tetrode = split(table_of_overlapping_clusters{j,"Tetrode"},"|");
        secondary_other_appearences_data = strcat(secondary_other_appearences_tetrode," ",secondary_other_appearences_z_score_and_cluster);
        if any(ismember(secondary_other_appearences_data,other_appearences_data))
            rows_to_no_longer_use(j) = true;
            other_appearences_data = union(other_appearences_data,secondary_other_appearences_data);
        end
    end
    united_lists_of_overlap{united_lists_of_overlap_counter} = other_appearences_data;
    united_lists_of_overlap_counter = united_lists_of_overlap_counter +1;
    disp("unite_overlap_data: Finished "+string(i)+"/"+string(size(table_of_overlapping_clusters,1)));
end
united_lists_of_overlap = united_lists_of_overlap(~cellfun('isempty',united_lists_of_overlap));
end