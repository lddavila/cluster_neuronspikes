function [] = run_reclustering_on_hpc()
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
disp("finished adding file paths")
% disp(fullfile("/home","lddavila","data_from_local_server","table_with_best_channels.mat"))
% load(fullfile("/home","lddavila","data_from_local_server","table_with_best_channels.mat"),"table_with_best_channels")
% disp("finished loading")
recluster_with_ideal_dims(choose_best_config());

end