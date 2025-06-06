function [] = run_update_cluster_table()
home_dir = cd("..");
addpath(genpath(pwd));
if config.ON_HPC
    cluster_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
    dir_to_save_updated_table_to = config.DIR_TO_SAVE_UPDATED_CLUSTER_TABLE_TO_ON_HPC;
else
    cluster_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
    dir_to_save_updated_table_to = config.DIR_TO_SAVE_UPDATED_CLUSTER_TABLE_TO;
end

if ~exist(dir_to_save_updated_table_to,"dir")
    dir_to_save_updated_table_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_updated_table_to);
end


updated_table_of_mean_waveform = update_table_of_overlap_ver_2(cluster_table,spikesort_config());
cd(dir_to_save_updated_table_to)
save("updated_table_of_clusters.mat",'updated_table_of_mean_waveform');
cd(home_dir);
end