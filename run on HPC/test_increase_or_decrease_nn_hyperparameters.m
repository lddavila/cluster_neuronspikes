function [] = test_increase_or_decrease_nn_hyperparameters()
home_dir =cd("..");
addpath(genpath(pwd));
cd(home_dir);
number_of_accuracy_categories = [3 4 5 6 7 8 9 10];
number_of_layers = 1:1:50;
filter_sizes = [5 10 15 20 25 30 35 40 50];
config = spikesort_config;

if config.ON_HPC
    dir_to_save_accuracy_cat_to = config.DIR_TO_SAVE_ACC_RESULTS_TO_ON_HPC;
    accuracy_array = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
else
    dir_to_save_accuracy_cat_to = config.DIR_TO_SAVE_ACC_RESULTS_TO;
    accuracy_array = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
end



disp("Finished loading the updated table of overlap")
table_of_increase_or_decrease = array2table(accuracy_array,'VariableNames',["grades_before_1","grades_before_2","grades_after","accuracy"]);
accuracy_category = nan(size(table_of_increase_or_decrease,1),1);
for i=1:size(table_of_increase_or_decrease,1)
    if table_of_increase_or_decrease{i,"accuracy"}{1} >0
        accuracy_category(i) =1;
    else
        accuracy_category(i) = 0;
    end
end
table_of_increase_or_decrease.("accuracy_category") = accuracy_category;

table_of_increase_or_decrease(isnan(table_of_increase_or_decrease{:,"accuracy_category"}),:) = [];
[grade_names,all_grades_for_primary]= flatten_grades_cell_array(table_of_increase_or_decrease{:,"grades_before_1"},config);
[~,all_grades_for_secondary]= flatten_grades_cell_array(table_of_increase_or_decrease{:,"grades_before_2"},config);
[indexes_of_grades_were_looking_for,~] = find(ismember(grade_names,config.NAMES_OF_CURR_GRADES(config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST)));
disp("Finished Grade Flattening")

accuracy_category = table_of_increase_or_decrease{:,"accuracy_category"};


data_to_put_into_neural_network = array2table([all_grades_for_primary(:,indexes_of_grades_were_looking_for),all_grades_for_secondary(:,indexes_of_grades_were_looking_for),accuracy_category]);
data_to_put_into_neural_network = convertvars(data_to_put_into_neural_network,data_to_put_into_neural_network.Properties.VariableNames(end),"categorical");


cd(dir_to_save_accuracy_cat_to);
first_for_loop_num_iters = size(number_of_accuracy_categories,2);
second_for_loop_num_iters =size(number_of_layers,2);
third_for_loop_num_iters = size(filter_sizes,2);
total_num_iterations = first_for_loop_num_iters * second_for_loop_num_iters * third_for_loop_num_iters;
which_nn = config.WHICH_NEURAL_NET;
for i=1:size(number_of_accuracy_categories,2)
    % tic
    parfor j=1:size(number_of_layers,2)
        num_layers = number_of_layers(j);
        for k=1:size(filter_sizes,2)
            num_neurons = filter_sizes(k);
            tic
            [accuracy_score,net,~]= increase_decrease_accuracy_nn(data_to_put_into_neural_network,spikesort_config,num_neurons,num_layers);
            end_time = toc;
            current_iteration = ((i-1)*first_for_loop_num_iters)+((j-1)*second_for_loop_num_iters)+k;
            % disp("Projected end time:"+string(currentDateTime+end_time));
            disp("Finished "+string(current_iteration)+"/"+string(total_num_iterations));
            disp("The last iteration took "+string(end_time)+" seconds")
            name_to_save_under = "accuracy score "+string(accuracy_score)+" num layers "+string(num_layers)+ " num neurons per layer"+string(num_neurons)+ " "+which_nn;
            fileID = fopen(name_to_save_under+ ".txt",'w');
            fclose(fileID);
            net_struct = struct();
            net_struct.Layers = net.Layers;
            net_struct.Connections = net.Connections;
            net_struct.net = net;
            save(name_to_save_under+".mat","-fromstruct",net_struct)
        end
     
    end
end
% save("accuracy_array.mat","accuracy_array");
cd(home_dir);
end