function [] = train_pick_better_between_2_nn()
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
config = spikesort_config();


if config.USE_WHAT_FOR_CHOOSE_BETTER ~= "waveform" || config.USE_WHAT_FOR_CHOOSE_BETTER ~= "images" ||config.USE_WHAT_FOR_CHOOSE_BETTER ~= "grades" ||config.USE_WHAT_FOR_CHOOSE_BETTER ~= "all" 
end
rng(0);

num_layers_to_try = 1:1:50;
num_neurons_to_try = 1:1:50;
num_data_samples_to_create = 10000;

which_nn = config.WHICH_NEURAL_NET;
if config.ON_HPC
    table_of_clusters = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS_ON_HPC);
    dir_to_save_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO_ON_HPC;
    dir_with_og_cluster_plots = config.DIR_TO_SAVE_CLUSTER_IMAGE_PNGS_TO_ON_HPC ;
    parent_save_dir = config.parent_save_dir_ON_HPC;
else
    dir_to_save_results_to = config.DIR_TO_SAVE_ACC_RESULTS_TO;
    dir_with_og_cluster_plots = config.DIR_TO_SAVE_CLUSTER_IMAGE_PNGS_TO;
    table_of_clusters = importdata(config.FP_TO_TABLE_OF_ALL_BP_CLUSTERS);
    parent_save_dir = config.parent_save_dir;
end
all_indexes = 1:size(table_of_clusters,1);
possible_pairs_to_use = nchoosek(all_indexes,2);

random_idxs_to_train_on = randi(size(possible_pairs_to_use,1),[num_data_samples_to_create,1]);

data_samples_to_use =possible_pairs_to_use(random_idxs_to_train_on,:);

%get the images for each pair 
image_data_to_use = cell(num_data_samples_to_create,2);
accuracies = nan(num_data_samples_to_create,2);
template_waveform_array = cell(num_data_samples_to_create,2);
for i=1:num_data_samples_to_create
    img_1_idx = data_samples_to_use(i,1);
    img_2_idx = data_samples_to_use(i,2);
    image_1_grades = table_of_clusters{img_1_idx,"grades"}{1};
    template_waveform_array{i,1} = table_of_clusters{img_1_idx,"Mean Waveform"}{1};
    template_waveform_array{i,2} = table_of_clusters{img_2_idx,"Mean Waveform"}{1};

    image_2_channels = image_1_grades{49};
    image_1_dim_1 = image_2_channels(image_1_grades{42});
    image_1_dim_2 = image_2_channels(image_1_grades{43});

    image_1_z_score = table_of_clusters{img_1_idx,"Z Score"};
    image_1_tetrode = table_of_clusters{img_1_idx,"Tetrode"};
    image_1_cluster = table_of_clusters{img_1_idx,"Cluster"};

    %Z Score 3 Tetrode t1 Cluster 1 Channels1 and 97
    image_1_string = "Z Score "+string(image_1_z_score)+" Tetrode "+image_1_tetrode+" Cluster "+string(image_1_cluster)+" Channels"+string(image_1_dim_1)+" and "+string(image_1_dim_2)+".png";

    image_1_accuracy = table_of_clusters{img_1_idx,"accuracy"};


    
    image_2_grades = table_of_clusters{img_2_idx,"grades"}{1};
    image_2_channels = image_2_grades{49};
    image_2_dim_1 = image_2_channels(image_2_grades{42});
    image_2_dim_2 = image_2_channels(image_2_grades{43});

    image_2_z_score = table_of_clusters{img_2_idx,"Z Score"};
    image_2_tetrode = table_of_clusters{img_2_idx,"Tetrode"};
    image_2_cluster = table_of_clusters{img_2_idx,"Cluster"};


    image_2_string = "Z Score "+string(image_2_z_score)+" Tetrode "+image_2_tetrode+" Cluster "+string(image_2_cluster)+" Channels"+string(image_2_dim_1)+" and " +string(image_2_dim_2)+".png";


    image_2_accuracy = table_of_clusters{img_2_idx,"accuracy"};

    image_2 = imread(fullfile(dir_with_og_cluster_plots,image_2_string));
    image_1 = imread(fullfile(dir_with_og_cluster_plots,image_1_string));


    image_data_to_use{i,1} = normalize(image_1,"range");
    image_data_to_use{i,2} = normalize(image_2,"range");
    accuracies(i,1) = image_1_accuracy;
    accuracies(i,2) = image_2_accuracy;


end
flattened_image_data = nan(num_data_samples_to_create,size(reshape(image_data_to_use{1,1},1,[]),2)*2);
for i=1:size(flattened_image_data,1)
    flattened_image_data(i,:) = [reshape(image_data_to_use{i,1},1,[]),reshape(image_data_to_use{i,2},1,[])];
end






end