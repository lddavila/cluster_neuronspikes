function [] = generate_contamination_table(ground_truth_dir,time_delta,gen_data_dir,dir_of_timestamps,parent_save_dir)
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
classify_clusters_as_neurons_based_on_overlap_with_unit(ground_truth_dir,time_delta,gen_data_dir,dir_of_timestamps,parent_save_dir);
end