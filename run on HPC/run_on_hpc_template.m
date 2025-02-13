function [] = run_on_hpc_template(parent_dir_of_data_saving,generic_dir_with_outputs,generic_dir_with_grades)
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);

home_dir = cd(parent_dir_of_data_saving);

cd(home_dir);
end