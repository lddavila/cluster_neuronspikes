function [] = create_heatmaps_of_grades_in_accuracy_table(table_of_accuracy_of_clusters,grades_to_check,mask_level)
unique_clusters = unique(table_of_accuracy_of_clusters.("og_tetr_and_clust_num"),"stable");
unique_units = unique(table_of_accuracy_of_clusters.("unit_id"));
names_of_unique_clusters = string(unique_clusters);
names_of_unique_units = string(unique_units);


for current_grade_counter=1:length(grades_to_check)
    figure;
    array_of_data = reshape(table_of_accuracy_of_clusters{:,(grades_to_check(current_grade_counter))},length(unique_units),[]);
    array_of_data(array_of_data(:,:)<mask_level) = NaN;
    c_f = heatmap(array_of_data);
    c_f.YDisplayLabels = names_of_unique_units;
    c_f.XDisplayLabels = strrep(names_of_unique_clusters,"_","\_");
    title(strrep(grades_to_check(current_grade_counter),"_","\_") + " %");
    xlabel("Cluster")
    ylabel("Unit (ground truth)")
end

end