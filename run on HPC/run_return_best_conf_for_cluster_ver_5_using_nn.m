function [] = run_return_best_conf_for_cluster_ver_5_using_nn()
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);

config = spikesort_config();

if config.ON_HPC
    parent_dir = config.parent_save_dir_ON_HPC;
    table_of_clusters = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
else
    parent_dir = config.parent_save_dir;
    table_of_clusters = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
end

dir_to_save_results_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(fullfile(parent_dir,config.DIR_TO_SAVE_RESULTS_TO));

cd(dir_to_save_results_to);
timestamp_array = table_of_clusters{:,"timestamps"};

best_conf_per_cluster = return_best_conf_for_cluster_ver_5_using_nn(table_of_clusters,timestamp_array,20,spikesort_config());
save("best_rep_per_cluster.mat","best_conf_per_cluster");
cd(home_dir);


end