function [] = resort_cluster_pngs_into_accuracy_caegory_folders(dir_with_og_pngs,dir_to_save_sorted_pngs_into,number_of_accuracy_categories,table_of_data_to_plot)
sliced_table = cell(1,size(table_of_data_to_plot,1));

for i=1:size(table_of_data_to_plot,1)
    sliced_table{i}= table_of_data_to_plot(i,:);
end

accuracy_cats_bounds = linspace(1,100,number_of_accuracy_categories);
num_its = size(table_of_data_to_plot,1);
for i=1:size(table_of_data_to_plot,1)
    current_data = sliced_table{i};
    current_z_score = current_data{1,"Z Score"};
    current_tetrode = current_data{1,"Tetrode"};
    current_cluster = current_data{1,"Cluster"};
    current_grades = current_data{1,"grades"}{1};
    current_tetrode_channels =current_grades{49};
    first_dimension = current_grades{42};
    second_dimension = current_grades{43};
    current_accuracy = current_data{1,"accuracy"};
    file_to_trans = "Z Score "+ string(current_z_score)+ " Tetrode "+current_tetrode+" Cluster "+string(current_cluster)+" Channels"+string(current_tetrode_channels(first_dimension))+ " and "+string(current_tetrode_channels(second_dimension))+".png";
    og_place = fullfile(dir_with_og_pngs,file_to_trans);
    category_file_to_sort_into = NaN;
    for j=1:size(accuracy_cats_bounds,2)
       if current_accuracy < accuracy_cats_bounds(j)
           category_file_to_sort_into = j-1;
           break;
       end
    end
    file_to_copy_into = create_a_file_if_it_doesnt_exist_and_ret_abs_path(fullfile(dir_to_save_sorted_pngs_into,string(category_file_to_sort_into)));
    new_loc = fullfile(file_to_copy_into,string(i));

    copyfile(og_place,new_loc);
    % disp("resort_cluster_pngs_into_accuracy_category_folders.m Finished "+string(i)+"/"+string(num_its))
end
end