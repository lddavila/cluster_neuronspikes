function run_test_bubble_sort_on_overlapping_clusters_general()
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);

config = spikesort_config();
if config.ON_HPC
    blind_pass_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
else
    blind_pass_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
end
disp("Finished importing data")
blind_pass_table = blind_pass_table(1:1000,:);
test_bubble_sort_choose_better_on_array_of_overlapping_clusters({blind_pass_table},config,"/scratch/cnheaton/data_to_copy_to_local_machine/06_25_2025_general_choose_better_test");
end