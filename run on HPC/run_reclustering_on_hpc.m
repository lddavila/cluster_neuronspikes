function [] = run_reclustering_on_hpc()
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
load(fullfile("home","lddavila","data_from_local_server","table_with_best_channels.mat"),"-mat","table_with_best_channels")
recluster_with_ideal_dims(table_with_best_channels,choose_best_config());

end