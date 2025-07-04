function [] = train_choose_better_twin_nn()
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
config = spikesort_config();
which_nn = config.WHICH_NEURAL_NET;
if config.ON_HPC
    table_of_clusters = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
    dir_to_save_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO_ON_HPC;
    dir_with_og_cluster_plots = config.DIR_TO_SAVE_CLUSTER_IMAGE_PNGS_TO_ON_HPC ;
    parent_save_dir = config.parent_save_dir_ON_HPC;
    table_of_already_done = importdata(config.FP_TO_ALREADY_DONE_ON_HPC);
else
    dir_to_save_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO;
    dir_with_og_cluster_plots = config.DIR_TO_SAVE_CLUSTER_IMAGE_PNGS_TO;
    table_of_clusters = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
    parent_save_dir = config.parent_save_dir;
    table_of_already_done = importdata(config.FP_TO_ALREADY_DONE);
end
disp("Finished Loading Data")

if ~exist(dir_to_save_results_to,"dir")
    dir_to_save_results_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_results_to);
end

disp("Finished Creating Save Directory")
num_accuracy_tests = 100;
accuracy_batch_size = 10;
number_of_its = 1000;
mini_batch_size = 180;
grad_decay = 0.9;
grady_dec_sq = 0.99;
number_of_accuracy_cats_to_try = 3:1:10;





number_of_layers_to_try = 1:1:40;
%number_of_layers_to_try = 20:1:50;
size_of_number_of_layers = size(number_of_layers_to_try,2);

learning_rates_to_try = [6e-5, 6e-4,6e-3, 6e-2, 6e-1];
% cd(dir_to_save_results_to);
% disp("Moved Into Save Dir")
% disp(pwd);
number_of_permutations_to_try = size(learning_rates_to_try,2) * size(number_of_layers_to_try,2) * size(number_of_accuracy_cats_to_try,2);



for i=1:size(number_of_layers_to_try,2)
    layers = number_of_layers_to_try(i);
    neurons = 1;
    for k=1:size(learning_rates_to_try,2)
        % disp(pwd)
        learning_rate = learning_rates_to_try(k);
        check_if_already_done = sprintf("number of layers %d number of neurons %d learning rate %0.6f %s",layers,neurons,learning_rate,which_nn);
        if any(contains(string(table_of_already_done{:,"name"}),check_if_already_done))
            disp("Current Neural Network Already Trained, moving to next one.")
            continue;
        end
        tic;
        [average_accuracy,net,fc_params]= pick_better_between_2_nn(number_of_its,mini_batch_size,learning_rate,grad_decay,grady_dec_sq,dir_with_og_cluster_plots,spikesort_config,num_accuracy_tests,accuracy_batch_size,layers,neurons,[i,k],table_of_clusters);
        elapsed_time = toc;
        current_iteration = ((i-1)*size(size_of_number_of_layers,2)) +k ;
        disp("train_twin_neural_network_on_hpc.m Finished "+string(current_iteration)+"/"+string(number_of_permutations_to_try))
        fprintf('Elapsed time: %.2f seconds\n', elapsed_time);

        save_name = sprintf("accuracy score %0.2f number of layers %d number of neurons %d learning rate %0.6f %s",average_accuracy,layers,neurons,learning_rate,which_nn);
        net_as_struct = struct();
        net_as_struct.net = net;
        net_as_struct.fc_params = fc_params;
        file_id = fopen(save_name+".txt",'w');
        fclose(file_id);
        save(fullfile(dir_to_save_results_to,save_name+".mat"),"-fromstruct",net_as_struct);
        disp("Finished saving")

    end

end

cd(home_dir);
end