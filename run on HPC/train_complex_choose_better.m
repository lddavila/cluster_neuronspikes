function [] = train_complex_choose_better()
num_samples = 100000;
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
config = spikesort_config();
which_nn = config.WHICH_NEURAL_NET;
if config.ON_HPC
    blind_pass_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
    parent_save_dir = config.parent_save_dir_ON_HPC;
else
    blind_pass_table = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
    parent_save_dir = config.parent_save_dir;
end

already_done_architectures = [    5 5;
    2 5 ;
    9 5 ;
    1 5 ;
    3 5 ;
    4 5 ;
    7 5 ;
    8 5 ;
    6 5 ;
    1 15 ;
    2 10 ;
    1 10 ;
    2 30 ;
    4 10 ;
    3 10 ;
    2 35 ;
    2 15 ;
    6 10 ;
    1 30 ;
    3 30 ;
    3 15 ;
    1 25 ;
    1 50 ;
    7 10 ;
    3 25 ;
    1 40 ;
    5 10 ;
    1 35 ;
    2 25 ;
    2 20 ;
    8 15 ;
    9 10 ;
    4 15 ;
    3 20 ;
    8 10 ;
    4 30 ;
    1 20 ;
    2 50 ;
    2 40 ;
    8 30 ;
    5 15 ;
    4 20 ;
    7 15 ;
    5 20 ;
    5 30 ;
    9 30 ;
    9 15 ;
    3 35 ;
    9 20 ;
    7 30 ;
    5 25 ;
    8 20 ;
    4 35 ;
    6 15 ;
    7 20 ;
    8 25 ;
    4 40 ;
    6 25 ;
    6 20 ;
    5 50 ;
    6 30 ;
    3 40 ;
    9 25 ;
    9 35 ;
    4 25 ;
    8 35 ;
    3 50 ;
    7 25 ;
    8 50 ;
    6 35 ;
    5 35 ;
    6 40 ;
    7 35 ;
    4 50 ;
    7 40 ;
    5 40 ;
    9 50 ;
    8 40 ;
    6 50 ;
    9 40 ;
    7 50
    ];

disp("Finished Loading Data")
dir_to_save_results_to = fullfile(parent_save_dir,config.DIR_TO_SAVE_RESULTS_TO);
if ~exist(dir_to_save_results_to,"dir")
    dir_to_save_results_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_results_to);
end
disp("Finished Creating directory")

%get grades from each row
[grade_names,all_grades]= flatten_grades_cell_array(blind_pass_table{:,"grades"},config);
[indexes_of_grades_were_looking_for,~] = find(ismember(grade_names,config.NAMES_OF_CURR_GRADES(config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST)));
grades_array = all_grades(:,indexes_of_grades_were_looking_for);

disp("Finished Flattening Grades")

%get the mean waveform from each row
mean_waveform_array = cell2mat(blind_pass_table{:,"Mean Waveform"});

disp("Finished Getting Mean Waveform Array")






%get indexes of combinations
rng(0);
all_possible_combos = nchoosek(1:size(blind_pass_table,1),2);
random_indexes = randi(size(all_possible_combos,1),num_samples,1);
random_sample_indexes = all_possible_combos(random_indexes,:);


%get the is left better col

left_is_better_col = blind_pass_table{all_possible_combos(random_indexes,1),"accuracy"}>blind_pass_table{all_possible_combos(random_indexes,2),"accuracy"};

% assemble the neural network data
data_for_nn = [mean_waveform_array(all_possible_combos(random_indexes,1),:),...
    grades_array(all_possible_combos(random_indexes,1),:),...
    mean_waveform_array(all_possible_combos(random_indexes,2),:),...
    grades_array(all_possible_combos(random_indexes,2),:),...
    random_sample_indexes,...
    left_is_better_col];

s = RandStream('mlfg6331_64');

number_of_positives = sum(data_for_nn(:,end));

equalized_data_for_nn = data_for_nn(data_for_nn(:,end)==true,:);
idxs_of_false_samples = find(data_for_nn(:,end)==false);

random_indexes_of_false = datasample(s,idxs_of_false_samples,number_of_positives,'Replace',false);
equalized_data_for_nn = [equalized_data_for_nn;data_for_nn(random_indexes_of_false,:)];

randomized_indexes = randperm(size(equalized_data_for_nn,1));
shuffled_data_for_nn = equalized_data_for_nn(randomized_indexes,:);

disp("Finished Data Assembly")

number_of_layers = 1:1:50;
filter_sizes = [5 10 15 20 25 30 35 40 50];



remaining_idxs = shuffled_data_for_nn(:,[end-2,end-1]);
shuffled_data_for_nn(:,end-2:end-1) = [];

%get the overlap percentage
overlap_col = get_overlap_percentage_for_nn_training_data(blind_pass_table,remaining_idxs,config);
disp("Finished getting overlap percentage array")

% get the sizes of both accuracy cols
first_size_col = cell2mat(cellfun(@size, blind_pass_table{remaining_idxs(:,1),"timestamps"}, 'UniformOutput', false));
sec_size_col = cell2mat(cellfun(@size, blind_pass_table{remaining_idxs(:,2),"timestamps"}, 'UniformOutput', false));
table_of_nn_data = array2table([shuffled_data_for_nn(:,1:end-1),overlap_col,first_size_col(:,1),sec_size_col(:,1),shuffled_data_for_nn(:,end)]);

home_dir = cd(dir_to_save_results_to);
% train the neural networks
disp(pwd)
for j=1:size(number_of_layers,2)
    num_layers = number_of_layers(j);
    parfor k=1:size(filter_sizes,2)

        num_neurons = filter_sizes(k);
        already_done_row = [num_layers,num_neurons ];
        if any(ismember(already_done_architectures,already_done_row,'rows'))
            continue;
        end
        disp("About to begin Training");
        beginning_time = tic;
        [accuracy_score,net,~]= merge_or_dont_nn(table_of_nn_data,spikesort_config,num_neurons,num_layers);
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