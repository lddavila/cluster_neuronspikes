function [] = create_figures_on_hpc(parent_dir_of_data_saving,dir_with_data_needed_for_process,dir_with_outputs,dir_with_grades)
home_dir = cd(dir_with_data_needed_for_process);
list_of_files_with_data_needed_for_process = strtrim(string(ls("*.mat")));
for i=1:length(list_of_files_with_data_needed_for_process)
    current_file = list_of_files_with_data_needed_for_process(i);
    load(current_file);
end
cd(home_dir);
home_dir = cd(parent_dir_of_data_saving);
dir_to_save_data_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path("Refined Pass 5 Percent Figures");

parfor i=1:size(best_appearences_of_cluster_from_reclustered_pass)
    current_tetrode = best_appearences_of_cluster_from_reclustered_pass{i,"Tetrode"};
    current_cluster = best_appearences_of_cluster_from_reclustered_pass{i,"Cluster"};
    grades_of_current_tetrode = importdata(dir_with_grades+"/"+current_tetrode+".mat");
end

end