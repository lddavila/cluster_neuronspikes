function [] = plot_all_clusters_by_branch(dir_of_table_to_plot)
home_dir =cd("..");
addpath(genpath(pwd));
cd(home_dir);
disp("Finished path adding now loading the table whose branch classifications will be plotted")

table_to_plot=importdata(dir_of_table_to_plot);
disp("Finished loading data to plot");

groupcounts_of_branches =groupcounts(table_to_plot,"Classification");
dir_to_save_plots_to = fullfile("/home/lddavila/data_to_be_copied_to_local_server/neuron_plots_by_branches");
if ~exist(dir_to_save_plots_to,"dir")
    dir_to_save_plots_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_plots_to);
end
disp("Finished Creating save dir")
for i=1:size(groupcounts_of_branches,1)
    current_branch = groupcounts_of_branches{i,"Classification"};
    current_branch_samples = table_to_plot(contains(table_to_plot{:,"Classification"},"Neuron","IgnoreCase",true),:);
    % dir_to_save_plots_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_plots_to);
    generic_dir_with_grades = "/home/lddavila/spike_gen_data/0_100Neuron300SecondRecordingWithLevel3Noise/initial_pass min z_score";
    generic_dir_with_outputs = '/home/lddavila/spike_gen_data/0_100Neuron300SecondRecordingWithLevel3Noise/initial_pass_results min z_score';

    home_dir = cd(dir_to_save_plots_to);

    current_unit_dir = "Branch "+current_branch+ " Plots";
    mkdir(current_unit_dir);
    cd(current_unit_dir);
    plot_output_hpc_ver_2(generic_dir_with_grades,generic_dir_with_outputs,current_branch_samples,false,[],[])
    cd(dir_to_save_plots_to);
    disp("Finished Printing Branch "+string(i)+"/"+string(size(groupcounts_of_branches)));
end
cd(home_dir)
end