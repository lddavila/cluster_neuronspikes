function [] = train_twin_neural_network_on_hpc()
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
config = spikesort_config();
which_nn = config.WHICH_NEURAL_NET;
if config.ON_HPC
    dir_with_train = config.twin_nn_training_data_on_hpc;
    dir_with_test = config.twin_nn_test_data_on_hpc;
    dir_to_save_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO_ON_HPC;
else
    dir_with_train = config.twin_nn_training_data;
    dir_with_test = config.twin_nn_test_data;
    dir_to_save_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO;
end
num_accuracy_tests = 100;
accuracy_batch_size = 10;
number_of_its = 10000;
mini_batch_size = 180;
grad_decay = 0.9;
grady_dec_sq = 0.99;

number_of_layers_to_try = 1:1:50;
%number_of_layers_to_try = 20:1:50;
size_of_number_of_layers = size(number_of_layers_to_try,2);

learning_rates_to_try = [6e-5, 6e-4,6e-3, 6e-2, 6e-1];
cd(dir_to_save_results_to);
number_of_permutations_to_try = size(learning_rates_to_try,2) * size(number_of_layers_to_try,2);
parfor i=1:size(number_of_layers_to_try,2)
    layers = number_of_layers_to_try(i);
    neurons = 1;
    for k=1:size(learning_rates_to_try,2)
        learning_rate = learning_rates_to_try(k);
        status_name = sprintf("number of layers %d number of neurons %d learning rate %0.6f %s",layers,neurons,learning_rate,which_nn);
        disp(status_name)
        [average_accuracy,net]= rate_cluster_quality_nn(number_of_its,mini_batch_size,learning_rate,grad_decay,grady_dec_sq,dir_with_train,dir_with_test,spikesort_config,num_accuracy_tests,accuracy_batch_size,layers,neurons);

        current_iteration = ((i-1)*size(size_of_number_of_layers,2)) +k ;
        disp("train_twin_neural_network_on_hpc.m Finished "+string(current_iteration)+"/"+string(number_of_permutations_to_try))

        save_name = sprintf("accuracy score %0.2f number of layers %d number of neurons %d learning rate %0.6f %s",average_accuracy,layers,neurons,learning_rate,which_nn);
        net_as_struct = struct("net",net);
        file_id = fopen(save_name+".txt",'w');
        fclose(file_id);
        save(save_name+".mat","-fromstruct",net_as_struct);

    end

end
cd(home_dir);
end