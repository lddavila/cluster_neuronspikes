function [] = train_mergable_or_not_nn()
home_dir =cd("..");
addpath(genpath(pwd));
cd(home_dir);
number_of_accuracy_categories = [3 4 5 6 7 8 9 10];
number_of_layers = 1:1:50;
filter_sizes = [5 10 15 20 25 30 35 40 50];
accuracy_array = cell(length(number_of_accuracy_categories),1);
config = spikesort_config;

num_samples = 1000000;

if config.ON_HPC
    dir_to_save_accuracy_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO_ON_HPC;
    updated_table_of_overlap = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
else
    dir_to_save_accuracy_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO;
    updated_table_of_overlap = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
end

if ~exist(dir_to_save_accuracy_results_to,"dir")
    create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_accuracy_results_to);
end

disp("Finished loading the updated table of overlap")




cd(dir_to_save_accuracy_results_to);
first_for_loop_num_iters = size(number_of_accuracy_categories,2);
second_for_loop_num_iters =size(number_of_layers,2);
third_for_loop_num_iters = size(filter_sizes,2);
total_num_iterations = first_for_loop_num_iters * second_for_loop_num_iters * third_for_loop_num_iters;
which_nn = config.WHICH_NEURAL_NET;

% table_with_accuracy = add_accuracy_col_on_hpc([],spikesort_config(),updated_table_of_overlap,number_of_accuracy_cats);

% get random permutations of mean spike waveforms
possible_waveforms = 1:size(updated_table_of_overlap,1);
combination_indexes= nchoosek(possible_waveforms,2);

rng(0)
data_for_nn =array2table(nan(num_samples,(size(updated_table_of_overlap{1,"Mean Waveform"}{1},2)*2)+1)) ;
% merge_or_dont_array = nan(num_samples,1);
random_samples = randi(size(combination_indexes,1),num_samples,1);


for i=1:size(random_samples,1)
    current_row = combination_indexes(random_samples(i),:);
    wave_1_idx = current_row(1);
    wave_1 = updated_table_of_overlap{wave_1_idx,"Mean Waveform"}{1};
    wave_1_max_overlap_neuron = updated_table_of_overlap{wave_1_idx,"Max Overlap Unit"};
    
    wave_2_idx = current_row(2);
    wave_2 = updated_table_of_overlap{wave_2_idx,"Mean Waveform"}{1};
    wave_2_max_overlap_neuron = updated_table_of_overlap{wave_2_idx,"Max Overlap Unit"};
    if wave_2_max_overlap_neuron==wave_1_max_overlap_neuron
        is_mergable = 1;
    else
        is_mergable =0;
    end
    data_for_nn{i,:} = [wave_1,wave_2,is_mergable];
    if mod(i,1000)==0
        print_status_iter_message("train_mergable_or_not constructing waveform_table",i,size(random_samples,1))
    end
end

disp("Finished Loading Samples Into Table")

%train different neural network infrastructures
% accuracy_sub_array_num_layers = cell(length(number_of_layers),1);

num_of_true_examples = sum(data_for_nn{:,end});
[indexes_of_true] = find(data_for_nn{:,end}==1);
[indexes_of_non_true,~ ]= find(data_for_nn{:,end}==0);

data_for_nn = [data_for_nn(indexes_of_true,:);data_for_nn(indexes_of_non_true(1:num_of_true_examples),:)];

for j=1:size(number_of_layers,2)
    accuracy_sub_array_num_neurons = cell(length(filter_sizes),1);
    num_layers = number_of_layers(j);
    for k=1:size(filter_sizes,2)
        num_neurons = filter_sizes(k);
        beginning_time = tic;
        [accuracy_score,net,~]= merge_or_dont_nn(data_for_nn,spikesort_config,num_neurons,num_layers);
        end_time = toc(beginning_time);

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
    % accuracy_sub_array_num_layers{j} = accuracy_sub_array_num_neurons;
end
% accuracy_array{i} = accuracy_sub_array_num_layers;
% disp("Finished accuracy cats "+string(i)+"/"+string(size(number_of_accuracy_cats,2)))

% save("accuracy_array.mat","accuracy_array");
cd(home_dir);
end