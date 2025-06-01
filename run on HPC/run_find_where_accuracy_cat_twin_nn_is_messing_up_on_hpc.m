function [] = run_find_where_accuracy_cat_twin_nn_is_messing_up_on_hpc()
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
config = spikesort_config();
if config.ON_HPC()
    table_of_all_clusters = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
    parent_save_dir = config.parent_save_dir_ON_HPC; 
else
    table_of_all_clusters = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
    parent_save_dir = config.parent_save_dir;
end
num_accuracy_cats = 5;
number_of_samples = 100;

confusion_matrix = find_where_accuracy_cat_twin_nn_is_messing_up(table_of_all_clusters,config,num_accuracy_cats,number_of_samples);
file_to_save_to = fullfile(parent_save_dir,"where_cat_twin_nn_is_messing_up");
if ~exist(file_to_save_to,"dir")
    file_to_save_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(file_to_save_to);
end
cd(file_to_save_to)
save("confusion_matrix.mat","confusion_matrix");
cd(home_dir)
end