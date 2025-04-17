function [table_of_clusters] = add_second_tree_classifiction(table_of_clusters)
second_tree_classification = repelem("",size(table_of_clusters,1),1);
for i=1:size(table_of_clusters,1)
    current_cluster_grades = table_of_clusters{i,"grades"};
    current_classification = table_of_clusters{i,"Classification"};
    second_tree_classification(i) = second_level_tree(current_classification,current_cluster_grades);
end
table_of_clusters.("Second Tree Classification") = second_tree_classification;
end