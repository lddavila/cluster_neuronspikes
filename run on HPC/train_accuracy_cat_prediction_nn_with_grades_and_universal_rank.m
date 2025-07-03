function [] = train_accuracy_cat_prediction_nn_with_grades_and_universal_rank()
home_dir =cd("..");
addpath(genpath(pwd));
cd(home_dir);
number_of_accuracy_categories = [3];
number_of_layers = 1:1:50;
% number_of_layers = [6];
filter_sizes = [5 10 15 20 25 30 35 40 50];
% filter_sizes = [35];
accuracy_array = cell(length(number_of_accuracy_categories),1);
config = spikesort_config;

if config.ON_HPC
    parent_save_dir = config.parent_save_dir_ON_HPC;
    blind_pass_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
    choose_better_nn_struct = config.FP_TO_COMPLEX_CHOOSE_BETTER_NN_ON_HPC;
else
    parent_save_dir = config.parent_save_dir;
    blind_pass_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
    choose_better_nn_struct = importdata(config.FP_TO_COMPLEX_CHOOSE_BETTER_NN);
    presorted_table = readtable(config.FP_TO_PRE_RANKED_TABLE,'VariableNamingRule','preserve');
end

choose_better_nn = choose_better_nn_struct.net;


dir_to_save_accuracy_cat_to = fullfile(parent_save_dir,config.DIR_TO_SAVE_RESULTS_TO);
if ~exist(dir_to_save_accuracy_cat_to,"dir")
    dir_to_save_accuracy_cat_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_accuracy_cat_to);
end

pieces_to_remove = ["accuracy score ","number of acc cats ","num layers ","num neurons per layer"," predict_grades_nn_with_ranking.mat"];
already_done_nn = get_nn_architectures_to_skip(fullfile(dir_to_save_accuracy_cat_to,"*.mat"),pieces_to_remove);
disp("Finished loading the updated table of overlap")
% currentDateTime = datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss');
cd(dir_to_save_accuracy_cat_to);
first_for_loop_num_iters = size(number_of_accuracy_categories,2);
second_for_loop_num_iters =size(number_of_layers,2);
third_for_loop_num_iters = size(filter_sizes,2);
total_num_iterations = first_for_loop_num_iters * second_for_loop_num_iters * third_for_loop_num_iters;
which_nn = config.WHICH_NEURAL_NET;

[grade_names,all_grades]= flatten_grades_cell_array(blind_pass_table{:,"grades"},config);
[indexes_of_grades_were_looking_for,~] = find(ismember(grade_names,config.NAMES_OF_CURR_GRADES(config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST)));
grades_array = all_grades(:,indexes_of_grades_were_looking_for);

disp("Finished Flattening Grades")

%get the mean waveform from each row
mean_waveform_array = cell2mat(blind_pass_table{:,"Mean Waveform"});


% data_for_nn = [mean_waveform_array(all_possible_combos(random_indexes,1),:),...
%     grades_array(all_possible_combos(random_indexes,1),:),...
%     mean_waveform_array(all_possible_combos(random_indexes,2),:),...
%     grades_array(all_possible_combos(random_indexes,2),:),...
%     random_sample_indexes,...
%     left_is_better_col];

%overlap_col = get_overlap_percentage_for_nn_training_data(blind_pass_table,remaining_idxs,config);


% table_of_nn_data = array2table([shuffled_data_for_nn(:,1:end-1),overlap_col,first_size_col(:,1),sec_size_col(:,1),shuffled_data_for_nn(:,end)]);


estimated_rank_col = nan(size(blind_pass_table,1),1);

% add a smarter version of the sorted table
presorted_table = [];
rng(0);
for i=1:1:100
    lower_bound = i-1;
    upper_bound = i;
    [rows_in_boundary,~] = find(blind_pass_table{:,"accuracy"}<= upper_bound & blind_pass_table{:,"accuracy"} > lower_bound);
    presorted_table = [presorted_table;blind_pass_table(rows_in_boundary(randperm(size(rows_in_boundary,1),1)),:)];
end

for i=1:size(blind_pass_table,1)
    estimated_rank_col(i) = add_universal_rank(blind_pass_table{i,"Mean Waveform"}{1},grades_array(i,:),size(blind_pass_table{i,"timestamps"}{1},1),presorted_table,choose_better_nn,blind_pass_table,grades_array,blind_pass_table{i,"timestamps"}{1},config);
    print_status_iter_message("train_accuracy_cat_prediction_nn_with_grades_and_universal_rank.m",i,size(blind_pass_table,1));
end

blind_pass_table.rank = estimated_rank_col;


for i=1:size(number_of_accuracy_categories,2)
    number_of_accuracy_cats = number_of_accuracy_categories(i);
    % tic;
    table_with_accuracy = add_accuracy_col_on_hpc([],spikesort_config(),blind_pass_table,number_of_accuracy_cats);
    table_of_nn_data =array2table([grades_array(:,:),estimated_rank_col./100,table_with_accuracy{:,"accuracy_category"}]);
    table_of_nn_data = rmmissing(table_of_nn_data);
    accuracy_sub_array_num_layers = cell(length(number_of_layers),1);
    % disp(table_with_accuracy{:,"grades"});
    for j=1:size(number_of_layers,2)
        accuracy_sub_array_num_neurons = cell(length(filter_sizes),1);
        num_layers = number_of_layers(j);
        for k=1:size(filter_sizes,2)
            num_neurons = filter_sizes(k);
            if ~isempty(already_done_nn)
                if any(ismember(already_done_nn,[number_of_accuracy_cats,num_layers,num_neurons],'rows' ))
                    continue;
                end
            end

            beginning_time = tic;
            [accuracy_score,net,~]=predict_acc_cat_using_leaky_relu(table_of_nn_data,num_neurons,num_layers);
            % [accuracy_score,net,~]= grades_neural_network_on_hpc(table_with_accuracy,spikesort_config,num_neurons,num_layers);
            end_time = toc(beginning_time);
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