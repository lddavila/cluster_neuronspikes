function [] = train_mergable_or_not_nn_using_grades_mean_waveform_and_timestamps()
num_samples = 100000;
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
config = spikesort_config();
which_nn = config.WHICH_NEURAL_NET;
if config.on_HPC
    blind_pass_table = config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC;
    dir_to_save_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO_ON_HPC;
else
    blind_pass_table = config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS;
    dir_to_save_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO;
end
if ~exist(dir_to_save_results_to,"dir")
    dir_to_save_results_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_results_to);
end

%get grades from each row
[grade_names,all_grades]= flatten_grades_cell_array(table_of_clusters{:,"grades"},config);
[indexes_of_grades_were_looking_for,~] = find(ismember(grade_names,config.NAMES_OF_CURR_GRADES(config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST)));
grades_array = [all_grades(:,indexes_of_grades_were_looking_for),accuracy_category];

%get the mean waveform from each row
mean_waveform_array = cell2mat(blind_pass_table{:,"Mean Waveform"});

%get the overlap percentage

%get indexes of combinations
all_possible_combos = nchoosek(1:size(blind_pass_table,2),2);
random_indexes = randi(size(all_possible_combos,1),num_samples,1);
%add the combinable or not column


end