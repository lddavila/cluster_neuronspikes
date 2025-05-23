function [] = train_twin_nn_using_more_accuracy_cats()
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
else
    dir_to_save_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO;
    dir_with_og_cluster_plots = config.DIR_TO_SAVE_CLUSTER_IMAGE_PNGS_TO;
    table_of_clusters = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
    parent_save_dir = config.parent_save_dir;
end




num_accuracy_tests = 100;
accuracy_batch_size = 10;
number_of_its = 1000;
mini_batch_size = 180;
grad_decay = 0.9;
grady_dec_sq = 0.99;
number_of_accuracy_cats_to_try = 5:1:10;





number_of_layers_to_try = 1:1:10;
%number_of_layers_to_try = 20:1:50;
size_of_number_of_layers = size(number_of_layers_to_try,2);

learning_rates_to_try = [6e-5, 6e-4,6e-3, 6e-2, 6e-1];
cd(dir_to_save_results_to);
number_of_permutations_to_try = size(learning_rates_to_try,2) * size(number_of_layers_to_try,2) * number_of_accuracy_cats_to_try;

for p=1:size(number_of_accuracy_cats_to_try,2)
    dir_to_save_sorted_images_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(fullfile(parent_save_dir,"C_I with "+string(number_of_accuracy_cats_to_try(p))+" acc cats"));
    disp("Starting Resorting Images")
    resort_cluster_pngs_into_accuracy_caegory_folders(dir_with_og_cluster_plots,dir_to_save_sorted_images_to,number_of_accuracy_cats_to_try(p),table_of_clusters);
    disp("Finished Resorting Images")

    dir_to_save_train = fullfile(parent_save_dir,"Tn "+string(number_of_accuracy_cats_to_try(p))+" acc cats");
    dir_to_save_test = fullfile(parent_save_dir,"Tt "+string(number_of_accuracy_cats_to_try(p))+" acc cats");

    disp("Starting Splitting Training and Testing Data")
    [dir_to_save_test,dir_to_save_train] = split_images_into_training_and_testing(dir_to_save_sorted_images_to,dir_to_save_train,dir_to_save_test,0.8,".png");
    disp("Finished Splitting Training and Testing Data")
    parfor i=1:size(number_of_layers_to_try,2)
        layers = number_of_layers_to_try(i);
        neurons = 1;
        for k=1:size(learning_rates_to_try,2)
            learning_rate = learning_rates_to_try(k);
            % fprintf("number of layers %d number of neurons %d learning rate %0.6f %s",layers,neurons,learning_rate,which_nn);
            tic;
            [average_accuracy,net,fc_params]= rate_cluster_quality_nn(number_of_its,mini_batch_size,learning_rate,grad_decay,grady_dec_sq,dir_to_save_train,dir_to_save_test,spikesort_config,num_accuracy_tests,accuracy_batch_size,layers,neurons,[p,i,k]);
            elapsed_time = toc;
            current_iteration = ((i-1)*size(size_of_number_of_layers,2)) +k ;
            disp("train_twin_neural_network_on_hpc.m Finished "+string(current_iteration)+"/"+string(number_of_permutations_to_try))
            fprintf('Elapsed time: %.2f seconds\n', elapsed_time);

            save_name = sprintf("accuracy score %0.2f number of layers %d number of neurons %d learning rate %0.6f number of accuracy cats %d %s",average_accuracy,layers,neurons,learning_rate,number_of_accuracy_cats_to_try(p),which_nn);
            net_as_struct = struct();
            net_as_struct.net = net;
            net_as_struct.fc_params = fc_params;
            file_id = fopen(save_name+".txt",'w');
            fclose(file_id);
            save(save_name+".mat","-fromstruct",net_as_struct);

        end

    end
end
cd(home_dir);
end