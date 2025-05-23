function [] = run_merge_and_regrade_on_hpc()
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
config = spikesort_config();
if config.ON_HPC
    dir_to_save_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO_ON_HPC;
    updated_table_of_overlap = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
    disp("Finished loading the updated table of overlap")
else
    updated_table_of_overlap = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
    disp("Finished loading the updated table of overlap")
    dir_to_save_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO;
end

[new_accuracies_and_grades] =merge_and_regrade(updated_table_of_overlap,config);

cd(dir_to_save_results_to);
save("new_accuracies_and_grades.mat","new_accuracies_and_grades")

end