function [] = train_acc_cat_pred_using_window()
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
number_of_accuracy_categories = [3];
number_of_layers = 1:1:50;

filter_sizes = [5 10 15 20 25 30 35 40 50];
config = spikesort_config();
if config.ON_HPC
    parent_save_dir = config.parent_save_dir_ON_HPC;
    blind_pass_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
    list_of_choose_better_nn_structs = config.FPS_OF_STRUCTURED_CHOOSE_BETTER_NEURAL_NETS_ON_HPC;
else
    parent_save_dir = config.parent_save_dir;
    blind_pass_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
    list_of_choose_better_nn_structs = config.FPS_OF_STRUCTURED_CHOOSE_BETTER_NEURAL_NETS;
end
disp("Finished importing blind_pass_table")

%import the neural nets into a cell array
choose_better_neural_nets = cell(1,length(list_of_choose_better_nn_structs));
for i=1:size(choose_better_neural_nets,2)
    neural_net_struct = importdata(list_of_choose_better_nn_structs(i));
    choose_better_neural_nets{i} = neural_net_struct.net;
end
disp("Finished Importing Neural Nets");

dir_to_save_results_to = fullfile(parent_save_dir,config.DIR_TO_SAVE_RESULTS_TO);
if ~exist(dir_to_save_results_to,"dir")
    dir_to_save_results_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_results_to);
end
disp("Finished Creating Save Dir")


%get a table of known accuracy amounts from simulated data
presorted_table = [];
rng(0); %set the seed for reproducability 
for i=1:1:100
    lower_bound = i-1;
    upper_bound = i;
    [rows_in_boundary,~] = find(blind_pass_table{:,"accuracy"}<= upper_bound & blind_pass_table{:,"accuracy"} > lower_bound);
    presorted_table = [presorted_table;blind_pass_table(rows_in_boundary(randperm(size(rows_in_boundary,1),1)),:)];
end
disp("Finished getting presorted table");

[grade_names,all_grades]= flatten_grades_cell_array(blind_pass_table{:,"grades"},config);
[indexes_of_grades_were_looking_for,~] = find(ismember(grade_names,config.NAMES_OF_CURR_GRADES(config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST)));
grades_array = all_grades(:,indexes_of_grades_were_looking_for);
disp("Finished Flattening Grades")

%get the mean waveform from each row in the blind_pass_table
mean_waveform_array = cell2mat(blind_pass_table{:,"Mean Waveform"});
disp("Finished Getting Mean Waveform Array")

%get the size of each cluster
cluster_size_col = cell2mat(cellfun(@size, blind_pass_table{:,"timestamps"}, 'UniformOutput', false));

%for each item in the blind pass table define a window

[window_beginning,window_end] = get_window_based_on_multiple_neural_networks(blind_pass_table,choose_better_neural_nets,presorted_table,cluster_size_col,mean_waveform_array,grades_array,config);
disp("Finished Getting Windows");
disp([window_beginning,window_end])
cd(dir_to_save_results_to);
disp(pwd);
save("windows.mat","window_beginning","window_end")
for i=1:size(number_of_accuracy_categories,2)
    number_of_accuracy_cats = number_of_accuracy_categories(i);
    % tic;
    table_with_accuracy = add_accuracy_col_on_hpc([],spikesort_config(),blind_pass_table,number_of_accuracy_cats);
    table_of_nn_data =array2table([grades_array(:,:),window_beginning,window_end,table_with_accuracy{:,"accuracy_category"}]);
    table_of_nn_data = rmmissing(table_of_nn_data);
    accuracy_sub_array_num_layers = cell(length(number_of_layers),1);
    % disp(table_with_accuracy{:,"grades"});
    for j=1:size(number_of_layers,2)
        accuracy_sub_array_num_neurons = cell(length(filter_sizes),1);
        num_layers = number_of_layers(j);
        for k=1:size(filter_sizes,2)
            num_neurons = filter_sizes(k);
            % if ~isempty(already_done_nn)
            %     if any(ismember(already_done_nn,[number_of_accuracy_cats,num_layers,num_neurons],'rows' ))
            %         continue;
            %     end
            % end

            beginning_time = tic;
            [accuracy_score,net,~]=predict_acc_cat_using_leaky_relu(table_of_nn_data,num_neurons,num_layers);
            % [accuracy_score,net,~]= grades_neural_network_on_hpc(table_with_accuracy,spikesort_config,num_neurons,num_layers);
            end_time = toc(beginning_time);
            % current_iteration = ((i-1)*first_for_loop_num_iters)+((j-1)*second_for_loop_num_iters)+k;
            % disp("Projected end time:"+string(currentDateTime+end_time));
            % disp("Finished "+string(current_iteration)+"/"+string(total_num_iterations));
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

end
% save("accuracy_array.mat","accuracy_array");
cd(home_dir);

%

end