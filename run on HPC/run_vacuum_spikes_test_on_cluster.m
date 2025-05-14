function [] = run_vacuum_spikes_test_on_cluster()
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
config = spikesort_config;
if config.USE_SNR_DIMS
    string_to_add = "SNR Wires";
else
    string_to_add = "Rep Wires";
end
if config.ON_HPC
    dir_to_save_results_to =config.DIR_TO_SAVE_ACC_RESULTS_TO_ON_HPC ;
    table_of_neurons_to_vacuum = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC) ;
    
else
    dir_to_save_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO;
    table_of_neurons_to_vacuum = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
end
[cell_array_of_accuracy_increases] = vacuum_spikes(table_of_neurons_to_vacuum,config);
home_dir = cd(dir_to_save_results_to);
save("cell_array_of_accuracy_increases "+string_to_add+".mat","cell_array_of_accuracy_increases");
cd(home_dir)

end