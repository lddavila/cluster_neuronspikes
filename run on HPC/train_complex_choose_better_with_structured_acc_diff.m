function [] = train_complex_choose_better_with_structured_acc_diff()
accuracy_differences_to_try = [100 90;90 80;70 60;60 50;30 20;20 10;10 5; 2 1];

max_num_samples = 10000;
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
config = spikesort_config();
which_nn_base = config.WHICH_NEURAL_NET;
if config.ON_HPC
    blind_pass_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
    parent_save_dir = config.parent_save_dir_ON_HPC;
else
    blind_pass_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
    parent_save_dir = config.parent_save_dir;
end
disp("Finished Loading Data");
%set architectures to be tested
number_of_layers = 1:1:50;
filter_sizes = [5 10 15 20 25 30 35 40 50];
disp("Finished Setting Architectures to test")

%get every possible comparison in the blind_pass_table
all_possible_permutations = int32(nchoosek(1:size(blind_pass_table,1),2));

%measure the differences in accuracy between the comparisons (only need up 2 floating point precision for memory's sake
magnitude_of_differences_in_accuracy = single(round(abs(blind_pass_table{all_possible_permutations(:,1),"accuracy"} - blind_pass_table{all_possible_permutations(:,2),"accuracy"}),2));
disp("Finished computing the magnitude of differences")

%get all the grades we will use for choose better
[grade_names,all_grades]= flatten_grades_cell_array(blind_pass_table{:,"grades"},config);
[indexes_of_grades_were_looking_for,~] = find(ismember(grade_names,config.NAMES_OF_CURR_GRADES(config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST)));
grades_array = all_grades(:,indexes_of_grades_were_looking_for);
disp("Finished Flattening Grades")

%get the mean waveform from each row in the blind_pass_table
mean_waveform_array = cell2mat(blind_pass_table{:,"Mean Waveform"});
disp("Finished Getting Mean Waveform Array")

%get the size of each cluster
cluster_size_col = cell2mat(cellfun(@size, blind_pass_table{:,"timestamps"}, 'UniformOutput', false));


for i=1:size(accuracy_differences_to_try,1)
    [rows_within_current_difference_range,~] = find(magnitude_of_differences_in_accuracy <= accuracy_differences_to_try(i,1) & magnitude_of_differences_in_accuracy > accuracy_differences_to_try(i,2));
    original_indexes = all_possible_permutations(rows_within_current_difference_range,:);
    fprintf("Finished Getting Indexes for Differences in Accuracy Between %d-%d",accuracy_differences_to_try(i,1),accuracy_differences_to_try(i,2));
    which_nn = which_nn_base +" With Accuracy Differences Bound By "+string(accuracy_differences_to_try(i,1))+" "+string(accuracy_differences_to_try(i,2));
    dir_to_save_results_to = fullfile(parent_save_dir,config.DIR_TO_SAVE_RESULTS_TO,"Ranging Between "+string(accuracy_differences_to_try(i,1))+" "+string(accuracy_differences_to_try(i,2)));
    if ~exist(dir_to_save_results_to,"dir")
        dir_to_save_results_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_results_to);
    end
    disp("Finished Creating directory")
    if size(original_indexes,1)<1
        continue;
    end

    %set the seed for reproducability
    rng(0)

    %the max number of examples we want to train on is set above
    %if we have fewer than that many examples then we'll train with what's available
    %if there are more than this we'll train only the number set above

    if size(original_indexes,1) > max_num_samples
        randomly_selected_indexes = randi(size(original_indexes,1),max_num_samples,1);
        original_indexes = original_indexes(randomly_selected_indexes);
    end
    disp("Finished Sampling Examples")

    %determine for this set of examples whether or not the "left" example is better
    left_is_better_col = blind_pass_table{original_indexes(:,1),"accuracy"} >= blind_pass_table{original_indexes(:,2),"accuracy"};
    disp("Finished determing whether left is better")

    %assemble the nn data
    data_for_nn = [mean_waveform_array(original_indexes(:,1),:),...
        grades_array(original_indexes(:,1),:),...
        mean_waveform_array(original_indexes(:,2),:),...
        grades_array(original_indexes(:,2),:),...
        original_indexes,...
        left_is_better_col];

    %now we must equalize the examples where left is better and the examples when left is not better
    %we do this because we do not want to bias the neural network into thinking that left is better/worse

    s = RandStream('mlfg6331_64');

    number_of_positives = sum(data_for_nn(:,end));

    equalized_data_for_nn = data_for_nn(data_for_nn(:,end)==true,:);
    idxs_of_false_samples = find(data_for_nn(:,end)==false);

    random_indexes_of_false = datasample(s,idxs_of_false_samples,number_of_positives,'Replace',false);
    equalized_data_for_nn = [equalized_data_for_nn;data_for_nn(random_indexes_of_false,:)];

    randomized_indexes = randperm(size(equalized_data_for_nn,1));
    shuffled_data_for_nn = equalized_data_for_nn(randomized_indexes,:);

    disp("Finished Data Assembly")

    remaining_idxs = shuffled_data_for_nn(:,[end-2,end-1]);
    shuffled_data_for_nn(:,end-2:end-1) = [];

    %get the overlap percentage
    overlap_col = get_overlap_percentage_for_nn_training_data(blind_pass_table,remaining_idxs,config);
    disp("Finished getting overlap percentage array")

    %get the sizes of the of the clusters
    first_size_col = cluster_size_col(remaining_idxs(:,1));
    sec_size_col = cluster_size_col(remaining_idxs(:,2));

    table_of_nn_data = array2table([shuffled_data_for_nn(:,1:end-1),overlap_col,first_size_col,sec_size_col,shuffled_data_for_nn(:,end)]);

    home_dir = cd(dir_to_save_results_to);
    disp(pwd);
    % pieces_to_remove = ["accuracy score ","num layers ","num neurons per layer"," ",which_nn_base,".mat"];
    % already_done_nn = get_nn_architectures_to_skip(pwd,pieces_to_remove);
    all_accuracies = [];
    for j=1:size(number_of_layers,2)
        num_layers = number_of_layers(j);
        for k=1:size(filter_sizes,2)

            num_neurons = filter_sizes(k);
            % already_done_row = [num_layers,num_neurons ];
            disp("About to begin Training");
            beginning_time = tic;
            [accuracy_score,net,~]= merge_or_dont_nn(table_of_nn_data,spikesort_config,num_neurons,num_layers);
            end_time = toc(beginning_time);

            disp("The last iteration took "+string(end_time)+" seconds")
            name_to_save_under = "accuracy score "+string(accuracy_score)+" num layers "+string(num_layers)+ " num neurons per layer"+string(num_neurons)+ " "+which_nn+" It Took "+string(end_time)+" seconds";
            fileID = fopen(name_to_save_under+ ".txt",'w');
            fclose(fileID);
            net_struct = struct();
            net_struct.Layers = net.Layers;
            net_struct.Connections = net.Connections;
            net_struct.net = net;
            save(name_to_save_under+".mat","-fromstruct",net_struct)

            all_accuracies = [all_accuracies;accuracy_score ];
            if any(all_accuracies>=.99)
                break;
            end

        end
        if any(all_accuracies>=.99)
            break;
        end

    end

    cd(home_dir);


end



end