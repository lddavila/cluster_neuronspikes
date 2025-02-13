function [] = create_cluster_plots_with_grades(parent_dir_of_data_saving,data_to_load,name_of_dir_to_save_files_to,gen_dir_of_outputs,gen_dir_with_grades)
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
load(data_to_load,"best_appearences_of_cluster_from_blind_pass")
home_dir = cd(parent_dir_of_data_saving);
dir_for_figures_to_be_saved_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(name_of_dir_to_save_files_to);

table_of_only_neurons = table_of_cluster_classification(contains(table_of_cluster_classification.category,"Neuron","IgnoreCase",true),:);

cd(home_dir);
end