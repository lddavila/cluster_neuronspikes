function [] = create_cluster_plots_with_grades(parent_dir_of_data_saving,data_to_load,name_of_dir_to_save_files_to,gen_dir_of_outputs,gen_dir_with_grades)
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
load(data_to_load,"best_appearences_of_cluster")

%'VariableNames',["Tetrode","Cluster","Z Score","SNR","Overlap Percentage","idx of its location in arrays"]);
home_dir = cd(parent_dir_of_data_saving);
dir_for_figures_to_be_saved_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(name_of_dir_to_save_files_to);
refinement_pass = false;
cd(dir_for_figures_to_be_saved_to)
regrade_best_rep_and_plot_output_hpc(gen_dir_with_grades,gen_dir_of_outputs,best_appearences_of_cluster,refinement_pass)
cd(home_dir);
end