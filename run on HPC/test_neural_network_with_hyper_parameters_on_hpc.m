function [] = test_neural_network_with_hyper_parameters_on_hpc()
home_dir =cd("..");
addpath(genpath(pwd));
cd(home_dir);
number_of_accuracy_categories = [3 4 5 6 7 8 9 10]; %og line
number_of_accuracy_categories = [3];
number_of_layers = 1:1:50;
number_of_layers = [6];
filter_sizes = [5 10 15 20 25 30 35 40 50];
filter_sizes = [35];
accuracy_array = cell(length(number_of_accuracy_categories),1);
config = spikesort_config;

if config.ON_HPC
    dir_to_save_accuracy_cat_to = config.DIR_TO_SAVE_ACC_RESULTS_TO_ON_HPC;
else
    dir_to_save_accuracy_cat_to = config.DIR_TO_SAVE_ACC_RESULTS_TO;
end

if ~exist(dir_to_save_accuracy_cat_to,"dir")
    dir_to_save_accuracy_cat_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_accuracy_cat_to);
end
% get_grades_for_nth_pass_of_clustering
% timestamp_array = importdata(fullfile("/home","lddavila","data_from_local_server","Timestamp and table","timestamp_array.mat"));
% disp("Finished loading timestamp array")
updated_table_of_overlap = importdata("/scratch/lddavila/data_from_local_machine/final_overlap_table/overlap_table_updated_with_new_grades.mat");
disp("Finished loading the updated table of overlap")
% currentDateTime = datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss');
cd(dir_to_save_accuracy_cat_to);
first_for_loop_num_iters = size(number_of_accuracy_categories,2);
second_for_loop_num_iters =size(number_of_layers,2);
third_for_loop_num_iters = size(filter_sizes,2);
total_num_iterations = first_for_loop_num_iters * second_for_loop_num_iters * third_for_loop_num_iters;
which_nn = config.WHICH_NEURAL_NET;
for i=1:size(number_of_accuracy_categories,2)
    number_of_accuracy_cats = number_of_accuracy_categories(i);
    % tic;
    table_with_accuracy = add_accuracy_col_on_hpc([],spikesort_config(),updated_table_of_overlap,number_of_accuracy_cats);
    accuracy_sub_array_num_layers = cell(length(number_of_layers),1);
    % disp(table_with_accuracy{:,"grades"});
    parfor j=1:size(number_of_layers,2)
        accuracy_sub_array_num_neurons = cell(length(filter_sizes),1);
        num_layers = number_of_layers(j);
        for k=1:size(filter_sizes,2)
            num_neurons = filter_sizes(k);
            tic
            [accuracy_score,net,~]= grades_neural_network_on_hpc(table_with_accuracy,spikesort_config,num_neurons,num_layers);
            end_time = toc;
            current_iteration = ((i-1)*first_for_loop_num_iters)+((j-1)*second_for_loop_num_iters)+k;
            % disp("Projected end time:"+string(currentDateTime+end_time));
            disp("Finished "+string(current_iteration)+"/"+string(total_num_iterations));
            disp("The last iteration took "+string(end_time)+" seconds")
            name_to_save_under = "accuracy score "+string(accuracy_score)+"number of acc cats " +string(number_of_accuracy_cats)+" num layers "+string(num_layers)+ " num neurons per layer"+string(num_neurons)+ " "+which_nn;
            fileID = fopen(name_to_save_under+ ".txt",'w');
            fclose(fileID);
            net_struct = struct();
            net_struct.Layers = net.Layers;
            net_struct.Connections = net.Connections;
            net_struct.net = net;
            save(name_to_save_under+".mat","-fromstruct",net_struct)
        end
        accuracy_sub_array_num_layers{j} = accuracy_sub_array_num_neurons;
    end
    accuracy_array{i} = accuracy_sub_array_num_layers;
    % disp("Finished accuracy cats "+string(i)+"/"+string(size(number_of_accuracy_cats,2)))
end
% save("accuracy_array.mat","accuracy_array");
cd(home_dir);
end