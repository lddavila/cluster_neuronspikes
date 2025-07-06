function [] = train_acc_cat_pred_using_window()
home_dir = cd("..");
addpath(genpath(pwd));
number_of_accuracy_categories = [3];
number_of_layers = 1:1:50;

filter_sizes = [5 10 15 20 25 30 35 40 50];

if config.ON_HPC
    parent_save_dir = config.parent_save_dir_ON_HPC;
    blind_pass_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
    list_of_choose_better_nn_structs = config.FPS_OF_STRUCTURED_CHOOSE_BETTER_NEURAL_NETS_ON_HPC;
else
    parent_save_dir = config.parent_save_dir;
    blind_pass_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
    list_of_choose_better_nn_structs = config.FPS_OF_STRUCTURED_CHOOSE_BETTER_NEURAL_NETS;
end

%import the neural nets into a cell array
choose_better_neural_nets = cell(1,length(list_of_choose_better_nn_structs));
for i=1:size(choose_better_neural_nets,2)
    neural_net_struct = importdata();
    choose_better_neural_nets{i} = neural_net_struct.net;
end

dir_to_save_results_to = fullfile(parent_save_dir,config.DIR_TO_SAVE_RESULTS_TO);
if ~exist(dir_to_save_results_to,"dir")
    dir_to_save_results_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_results_to);
end

%get a table of known accuracy amounts from simulated data
presorted_table = [];
rng(0); %set the seed for reproducability 
for i=1:1:100
    lower_bound = i-1;
    upper_bound = i;
    [rows_in_boundary,~] = find(blind_pass_table{:,"accuracy"}<= upper_bound & blind_pass_table{:,"accuracy"} > lower_bound);
    presorted_table = [presorted_table;blind_pass_table(rows_in_boundary(randperm(size(rows_in_boundary,1),1)),:)];
end



%for each item in the blind pass table define a window

%

end