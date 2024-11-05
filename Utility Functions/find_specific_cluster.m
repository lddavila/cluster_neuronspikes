function [indexes_of_clusters_with_desired_cluster] = find_specific_cluster(list_of_associated_tetrodes,specific_cluster)
indexes_of_clusters_with_desired_cluster = [];
for i=1:length(list_of_associated_tetrodes)
    current_associated_tetrodes = list_of_associated_tetrodes{i};
    if ismember(specific_cluster,current_associated_tetrodes)
        indexes_of_clusters_with_desired_cluster = [indexes_of_clusters_with_desired_cluster,i];
    end
end
end