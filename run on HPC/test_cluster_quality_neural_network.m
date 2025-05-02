function [] = test_cluster_quality_neural_network()
home_dir =cd("..");
addpath(genpath(pwd));
cd(home_dir);
number_of_accuracy_categories = [4 5 6 7 8 9 10];
% number_of_accuracy_categories = [3];
number_of_layers = 1:1:50;
% number_of_layers=[25];
filter_sizes = [32 64 128 256 512];
config = spikesort_config();
if config.ON_HPC
    dir_to_save_accuracy_cat_to = config.DIR_TO_SAVE_ACC_RESULTS_TO_ON_HPC;
else
    dir_to_save_accuracy_cat_to = config.DIR_TO_SAVE_ACC_RESULTS_TO;
end

cd(dir_to_save_accuracy_cat_to);
first_for_loop_num_iters = size(number_of_accuracy_categories,2);
second_for_loop_num_iters =size(number_of_layers,2);
third_for_loop_num_iters = size(filter_sizes,2);
total_num_iterations = first_for_loop_num_iters * second_for_loop_num_iters * third_for_loop_num_iters;
name_of_neural_net = config.WHICH_NEURAL_NET;
parfor j=1:size(number_of_layers,2)
    num_layers = number_of_layers(j);
    for k=1:size(filter_sizes,2)
        current_filter_size = filter_sizes(k);
        tic
        [accuracy_score,net,~] = classify_clusters_neural_network_on_hpc(config,num_layers,current_filter_size);
        end_time = toc;
        current_iteration = ((j-1)*second_for_loop_num_iters)+k;
        % disp("Projected end time:"+string(currentDateTime+end_time));
        disp("Finished "+string(current_iteration)+"/"+string(total_num_iterations));
        disp("The last iteration took "+string(end_time)+" seconds")

        name_to_save_under = "accuracy score "+num2str(accuracy_score)+" num layers "+string(num_layers)+ " filter size "+string(current_filter_size)+" "+name_of_neural_net;
        fileID = fopen(name_to_save_under+ ".txt",'w');
        fclose(fileID);
        net_struct = struct();
        net_struct.Layers = net.Layers;
        net_struct.Connections = net.Connections
        net_struct.net = net;
        save(name_to_save_under+".mat","-fromstruct",net_struct)
    end

end


end