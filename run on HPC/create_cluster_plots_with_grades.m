function [] = create_cluster_plots_with_grades(parent_dir_of_data_saving,generic_dir_with_outputs,generic_dir_with_grades,data_to_load)
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
load(data_to_load,"")
home_dir = cd(parent_dir_of_data_saving);

cd(home_dir);
end