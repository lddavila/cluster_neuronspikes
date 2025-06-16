function [] = sort_images_into_accuracy_cats(dir_with_images,dir_to_save_images_sorted_by_cat,num_accuracy_cats,table_of_clusters,config)
table_of_clusters = add_accuracy_col_on_hpc([],config,table_of_clusters,num_accuracy_cats);

for i=1:size(table_of_clusters,1)
    %Z Score 3 Tetrode t11 Cluster 5 Channels196 and 100
    current_z_score = table_of_clusters{i,"Z Score"};
    current_tetrode = table_of_clusters{i,"Tetrode"};
    current_cluster = table_of_clusters{i,"Cluster"};
    current_grades = table_of_clusters{i,"grades"}{i};
    current_channels = current_grades{49};
    ch_1 = current_channels{current_grades{42}};
    ch_2 = current_channels{current_grades{43}};

    file_name = sprintf("Z Score %d Tetrode %s Cluster %d Channels%d and %d",current_z_score,current_tetrode,current_cluster,ch_1,ch_2);
    
    home_dir = cd(dir_to_save_images_sorted_by_cat);
    current_accuracy_cat_as_file_name = string(table_of_clusters{i,"accuracy_category"});
    if ~exist(current_accuracy_cat_as_file_name,"dir")
        current_accuracy_cat_as_file_name = create_a_file_if_it_doesnt_exist_and_ret_abs_path(fullfile(pwd,current_accuracy_cat_as_file_name));
    else
        current_accuracy_cat_as_file_name = fullfile(pwd,current_accuracy_cat_as_file_name);
    end
    copyfile(fullfile(dir_with_images,file_name),fullfile(current_accuracy_cat_as_file_name,file_name));
end
end