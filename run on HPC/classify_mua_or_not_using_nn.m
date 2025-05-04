function [] = classify_mua_or_not_using_nn(config,table_of_all_clusters,image_dir)
for i=1:size(table_of_all_clusters,1)
    current_tetrode = table_of_all_clusters{i,"Tetrode"};
    current_z_score = table_of_all_clusters{i,"Z Score"};
    current_cluster = table_of_all_clusters{i,"Cluster"};
    current_grades = table_of_all_clusters{i,"grades"};
    current_channels = current_grades{49};
    current_dimension_1 = current_channels(current_grades{42});
    current_dimension_2 = current_channels(current_grades{43});
    photo_string = "Z Score "+string(current_z_score)+" Tetrode "+current_tetrode+" Cluster "+string(current_cluster)+ " Channels"+string(current_dimension_2)
end
end