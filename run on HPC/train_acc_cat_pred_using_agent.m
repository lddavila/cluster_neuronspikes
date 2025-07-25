function [] = train_acc_cat_pred_using_agent()
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
else
    parent_save_dir = config.parent_save_dir;
    blind_pass_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
end
disp("Finished importing blind_pass_table")

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

%get only the grads of the enviornment
grade_locs_for_presorted = nan(size(presorted_table,1),1);
for i=1:size(presorted_table,1)
    c1 = blind_pass_table{:,"Z Score"}==presorted_table{i,"Z Score"};
    c2 = blind_pass_table{:,"Tetrode"}==presorted_table{i,"Tetrode"};
    c3 = blind_pass_table{:,"Cluster"}==presorted_table{i,"Cluster"};
    [grade_locs_for_presorted(i),~] =find(c1 & c2 & c3);
end

c1 = blind_pass_table{:,"Z Score"}==presorted_table{1,"Z Score"};
c2 = blind_pass_table{:,"Tetrode"}==presorted_table{1,"Tetrode"};
c3 = blind_pass_table{:,"Cluster"}==presorted_table{1,"Cluster"};

[beginning_of_environment_index,~] = find(c1 & c2 & c3);

size_of_blind_pass_table = size(blind_pass_table,1);
[grade_names,all_grades]= flatten_grades_cell_array(blind_pass_table{:,"grades"},config);
[indexes_of_grades_were_looking_for,~] = find(ismember(grade_names,config.NAMES_OF_CURR_GRADES(config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST)));
grades_array = all_grades(:,indexes_of_grades_were_looking_for);
disp("Finished Flattening Grades")

presorted_grades_array = grades_array(grade_locs_for_presorted,:);

ResetHandle = @() custom_reset_function(beginning_of_environment_index,grades_array,size_of_blind_pass_table,blind_pass_table,presorted_grades_array,presorted_table);
% [initial_obs_info, info] = custom_reset_function(beginning_of_environment_index,size_of_blind_pass_table);

StepHandle = @(Action,Info) custom_step_function(Action,Info);

num_neurons_per_layer = filter_sizes(1);

features = [grades_array,grades_array];
[agent,~,obs_info,action_info] = get_agent_and_critique_net(features,num_neurons_per_layer);

opt = rlTrainingOptions(MaxEpisodes=1000, ...
    MaxStepsPerEpisode=150, ...
    SaveAgentCriteria="AverageReward");

env = rlFunctionEnv(obs_info,action_info,StepHandle,ResetHandle);

train_results = train(agent,env,opt);


end