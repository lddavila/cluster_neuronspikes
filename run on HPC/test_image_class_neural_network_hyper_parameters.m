function [] = test_image_class_neural_network_hyper_parameters()
home_dir =cd("..");
addpath(genpath(pwd));
cd(home_dir);
number_of_accuracy_categories = [3 4 5 6 7 8 9 10];
number_of_layers = 3:15:300;
filter_sizes = [32 64 128 256 512];
accuracy_array = cell(length(number_of_accuracy_categories),1);
config = spikesort_config;

if config.ON_HPC
    dir_to_save_accuracy_cat_to = config.DIR_TO_SAVE_ACC_RESULTS_TO_ON_HPC;
    timestamp_array = importdata(fullfile("/home","lddavila","data_from_local_server","Timestamp and table","timestamp_array.mat"));
    disp("Finished loading timestamp array")
    updated_table_of_overlap = importdata(fullfile("/home","lddavila","data_from_local_server","Timestamp and table","overlap_table.mat"));
    disp("Finished loading the updated table of overlap")
else
    timestamp_array = importdata(fullfile("D:\cluster_neuronspikes\Data\Timestamp and table","timestamp_array.mat"));
    disp("Finished loading timestamp array")
    updated_table_of_overlap = importdata(fullfile("D:\cluster_neuronspikes\Data\Timestamp and table","overlap_table.mat"));
    disp("Finished loading the updated table of overlap")
    dir_to_save_accuracy_cat_to = config.DIR_TO_SAVE_ACC_RESULTS_TO;
end





% currentDateTime = datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss');
cd(dir_to_save_accuracy_cat_to);
first_for_loop_num_iters = size(number_of_accuracy_categories,2);
second_for_loop_num_iters =size(number_of_layers,2);
third_for_loop_num_iters = size(filter_sizes,2);
total_num_iterations = first_for_loop_num_iters * second_for_loop_num_iters * third_for_loop_num_iters;
for i=1:size(number_of_accuracy_categories,2)
    number_of_accuracy_cats = number_of_accuracy_categories(i);
    % tic;
    table_with_accuracy = add_accuracy_col_on_hpc(timestamp_array,spikesort_config,updated_table_of_overlap,number_of_accuracy_cats);
    accuracy_sub_array_num_layers = cell(length(number_of_layers),1);
    parfor j=1:size(number_of_layers,2)
        accuracy_sub_array_num_neurons = cell(length(filter_sizes),1);
        num_layers = number_of_layers(j);
        for k=1:size(filter_sizes,2)
            current_filter_size = filter_sizes(k);
            tic
            accuracy_score = cluster_plots_neural_network_on_hpc(table_with_accuracy,spikesort_config,num_layers,current_filter_size);
            end_time = toc;
            current_iteration = ((i-1)*first_for_loop_num_iters)+((j-1)*second_for_loop_num_iters)+k;
            % disp("Projected end time:"+string(currentDateTime+end_time));
            disp("Finished "+string(current_iteration)+"/"+string(total_num_iterations));
            disp("The last iteration took "+string(end_time)+" seconds")
            name_to_save_under = "accuracy score "+num2str(accuracy_score)+" number of acc cats " +string(number_of_accuracy_cats)+" num layers "+string(num_layers)+ " filter size "+string(current_filter_size)+ ".txt";
            fileID = fopen(name_to_save_under,'w');
            fclose(fileID);
        end
        accuracy_sub_array_num_layers{j} = accuracy_sub_array_num_neurons;
    end
    accuracy_array{i} = accuracy_sub_array_num_layers;
    % disp("Finished accuracy cats "+string(i)+"/"+string(size(number_of_accuracy_cats,2)))
end
end