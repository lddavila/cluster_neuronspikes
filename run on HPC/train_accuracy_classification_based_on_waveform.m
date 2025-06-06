function [] = train_accuracy_classification_based_on_waveform()
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
config = spikesort_config();
which_nn = config.WHICH_NEURAL_NET;
if config.ON_HPC
    table_of_clusters = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
    dir_to_save_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO_ON_HPC;
else
    dir_to_save_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO;
    table_of_clusters = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
end

if ~exist(dir_to_save_results_to,"dir")
    dir_to_save_results_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_results_to);
end

number_of_layers = 1:1:50;
filter_sizes = [5 10 15 20 25 30 35 40 50];

%flatten the mean waveforms
array_of_mean_waveforms_without_acc_cat = cell2mat(table_of_clusters{:,"Mean Waveform"});
num_accuracy_categories_to_try = [3,4,5,6,7,8,9];
cd(dir_to_save_results_to);
for i=1:size(num_accuracy_categories_to_try,2)
    current_acc_cat = num_accuracy_categories_to_try(i);
    table_of_clusters_with_accuracy_cat = add_accuracy_col_on_hpc([],[],table_of_clusters,current_acc_cat);
    table_of_nn_data = array2table([array_of_mean_waveforms_without_acc_cat,table_of_clusters_with_accuracy_cat{:,"accuracy_category"}]);
    parfor j=1:size(number_of_layers,2)
        num_layers = number_of_layers(j);
        for k=1:size(filter_sizes,2)
            num_neurons = filter_sizes(k);
            beginning_time = tic;
            [accuracy_score,net,~]= merge_or_dont_nn(table_of_nn_data,spikesort_config,num_neurons,num_layers);
            end_time = toc(beginning_time);

            disp("The last iteration took "+string(end_time)+" seconds")
            name_to_save_under = "accuracy score "+string(accuracy_score)+"num accuracy cats "+string(current_acc_cat)+" num layers "+string(num_layers)+ " num neurons per layer"+string(num_neurons)+ " "+which_nn;
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
cd(home_dir);
end