function [table_of_mean_grades_per_cluster] = calculate_the_average_grade_per_cluster(associated_tetrodes,dir_with_nth_pass_grades,relevant_grades,names_of_grades)
means_of_all_clust = zeros(length(associated_tetrodes),length(relevant_grades)+1);
cluster_name = 1:length(associated_tetrodes).';
means_of_all_clust(:,1) = cluster_name;
for i=1:length(associated_tetrodes)
    associated_clusters_of_current_cluster = associated_tetrodes{i};
    associated_grades = zeros(length(associated_clusters_of_current_cluster),length(relevant_grades));
    for j=1:length(associated_clusters_of_current_cluster)
        cluster_and_tetrode = associated_clusters_of_current_cluster(j);
        cluster_and_tetrode = split(cluster_and_tetrode," ");
        curr_cluster = str2double(cluster_and_tetrode(2));
        curr_tetrode = cluster_and_tetrode(1);
        load(dir_with_nth_pass_grades+"\"+curr_tetrode+".mat","grades");
        associated_grades(j,:) = grades(curr_cluster,relevant_grades);
    end
    means_of_all_clust(i,2:end) = mean(associated_grades,1);

end
table_of_mean_grades_per_cluster = array2table(means_of_all_clust,"VariableNames",names_of_grades);
end