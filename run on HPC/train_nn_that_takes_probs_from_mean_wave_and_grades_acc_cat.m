function [] = train_nn_that_takes_probs_from_mean_wave_and_grades_acc_cat()
home_dir =cd("..");
addpath(genpath(pwd));
cd(home_dir);

number_of_layers = 1:1:50;
filter_sizes = [5 10 15 20 25 30 35 40 50];

config = spikesort_config;



if config.ON_HPC
    dir_to_save_accuracy_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO_ON_HPC;
    updated_table_of_overlap = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
    predict_acc_cat_nn_struct =importdata(config.FP_TO_PREDICTING_ACCURACY_ON_GRADES_NN_ON_HPC) ;
else
    dir_to_save_accuracy_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO;
    updated_table_of_overlap = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
    predict_acc_cat_nn_struct = importdata(config.FP_TO_PREDICTING_ACCURACY_ON_GRADES_NN);
end

acc_cat_predicting_nn = predict_acc_cat_nn_struct.net;

if ~exist(dir_to_save_accuracy_results_to,"dir")
    create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_accuracy_results_to);
end

disp("Finished loading the updated table of overlap")




cd(dir_to_save_accuracy_results_to);


which_nn = config.WHICH_NEURAL_NET;

table_with_accuracy = add_accuracy_col_on_hpc([],spikesort_config(),updated_table_of_overlap,3);


mean_waveform_array = cell2mat(table_with_accuracy{:,"Mean Waveform"});
col_of_probabilities = nan(size(mean_waveform_array,1),3);
[grade_names,all_grades] = flatten_grades_cell_array(table_with_accuracy{:,"grades"},config);

[indexes_of_grades_were_looking_for,~] = find(ismember(grade_names,config.NAMES_OF_CURR_GRADES(config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST)));

ordered_grades_array =all_grades(:,indexes_of_grades_were_looking_for);

for i=1:size(mean_waveform_array,1)
    col_of_probabilities(i,:) = predict(acc_cat_predicting_nn,ordered_grades_array(i,:));
end


data_for_nn =array2table([mean_waveform_array,col_of_probabilities,table_with_accuracy{:,"accuracy_category"}]) ;
disp("Finished Loading Samples Into Table")



parfor j=1:size(number_of_layers,2)
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
end

cd(home_dir);
end