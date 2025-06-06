function [] = generate_cluster_plots_for_contamination_table(parent_dir_of_data_saving,name_of_dir_to_save_files_to,gen_dir_of_outputs,gen_dir_with_grades,data_to_load)
tic
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);

names_of_grades =["LRat","CV","ISI","#spike","TM OG","min bhat","skew","sym of hist","amp cat","tight euc","SNR"];
grades_to_check = [1,2,3,6,8,9,28,30,32,35,40];

home_dir = cd(parent_dir_of_data_saving);
dir_for_figures_to_be_saved_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(name_of_dir_to_save_files_to);

refinement_pass = false;
cd(dir_for_figures_to_be_saved_to)
final_contamination_table = importdata(data_to_load);
all_clusters_in_cont_table_with_90_overlap = final_contamination_table(final_contamination_table{:,"Max Overlap % With Unit"} > 90,:);
disp("Beginning plot generation")
plot_output_hpc(gen_dir_with_grades,gen_dir_of_outputs,all_clusters_in_cont_table_with_90_overlap,refinement_pass,grades_to_check,names_of_grades)
cd(home_dir);
disp("Finished")
toc
end