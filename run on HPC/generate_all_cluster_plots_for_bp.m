function [] = generate_all_cluster_plots_for_bp(parent_dir_of_data_saving,name_of_dir_to_save_files_to,gen_dir_of_outputs,gen_dir_with_grades)
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);

% best_appearences_of_cluster = 
names_of_grades = string(1:42);
grades_to_check = 1:42;

z_scores_to_check = [3 4 5 6 7 8 9];
art_tetr_array = build_artificial_tetrode();

list_of_tetrodes = strcat("t",string(1:size(art_tetr_array,1)));
list_of_tetrodes = list_of_tetrodes.';
list_of_clusters = repelem(1,length(list_of_tetrodes),1);

best_appearences_of_cluster = table(repelem(list_of_tetrodes,length(z_scores_to_check)),repelem(list_of_clusters,length(z_scores_to_check)),repelem(z_scores_to_check,length(list_of_tetrodes)).','VariableNames',["Tetrode","Cluster","Z Score"]);

home_dir = cd(parent_dir_of_data_saving);
dir_for_figures_to_be_saved_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(name_of_dir_to_save_files_to);

refinement_pass = false;
cd(dir_for_figures_to_be_saved_to)



plot_output_hpc(gen_dir_with_grades,gen_dir_of_outputs,best_appearences_of_cluster,refinement_pass,grades_to_check,names_of_grades)
cd(home_dir);
disp("Finished")
end