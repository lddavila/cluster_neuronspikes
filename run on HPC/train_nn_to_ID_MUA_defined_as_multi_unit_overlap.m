function [] = train_nn_to_ID_MUA_defined_as_multi_unit_overlap()
home_dir =cd("..");
addpath(genpath(pwd));
cd(home_dir);
number_of_layers = 1:1:50;
% number_of_layers = [6];
filter_sizes = [5 10 15 20 25 30 35 40 50];
% filter_sizes = [35];

config = spikesort_config;

if config.ON_HPC
    parent_save_dir = config.parent_save_dir_ON_HPC;
    blind_pass_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
else
    parent_save_dir = config.parent_save_dir;
    blind_pass_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
end
disp("Finished loading the updated table of overlap")

blind_pass_table = determine_multiple_under_units(blind_pass_table);



dir_to_save_accuracy_cat_to = fullfile(parent_save_dir,config.DIR_TO_SAVE_RESULTS_TO);
if ~exist(dir_to_save_accuracy_cat_to,"dir")
    dir_to_save_accuracy_cat_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_accuracy_cat_to);
end


% currentDateTime = datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss');
cd(dir_to_save_accuracy_cat_to);

which_nn = config.WHICH_NEURAL_NET;

[grade_names,all_grades]= flatten_grades_cell_array(blind_pass_table{:,"grades"},config);
[indexes_of_grades_were_looking_for,~] = find(ismember(grade_names,config.NAMES_OF_CURR_GRADES(config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST)));
grades_array = all_grades(:,indexes_of_grades_were_looking_for);

disp("Finished Flattening Grades")

%get the mean waveform from each row
mean_waveform_array = cell2mat(blind_pass_table{:,"Mean Waveform"});

use_mean_waveform_or_dont = [0 1];

for use_mean_waveform=1:size(use_mean_waveform_or_dont,2)
    for j=1:size(number_of_layers,2)
        num_layers = number_of_layers(j);
        for k=1:size(filter_sizes,2)
            num_neurons = filter_sizes(k);
            if use_mean_waveform
                table_of_nn_data = array2table([grades_array,mean_waveform_array,blind_pass_table{:,"has_multiple_under_units"}]);
                to_add = "_used_mean_waveform";
            else
                table_of_nn_data = array2table([grades_array,blind_pass_table{:,"has_multiple_under_units"}]);
                to_add = "";
            end
            beginning_time = tic;

            
            [accuracy_score,net,~]=predict_acc_cat_using_leaky_relu(table_of_nn_data,num_neurons,num_layers);
            end_time = toc(beginning_time);
            name_to_save_under = "acc_score_"+string(accuracy_score)+"_num_layers_"+string(num_layers)+ "_n_n_per_layer"+string(num_neurons)+ "_"+which_nn+"_"+string(end_time)+"_seconds"+to_add;
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