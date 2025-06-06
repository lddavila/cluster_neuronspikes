function [X_1,X_2,pair_labels] = get_higher_lower_accuracy_image_pairs(dir_with_cluster_images,config,mini_batch_size,table_of_all_clusters)



    function [X_1,X_2,pair_labels,accuracies] = get_twin_batch(imds,mini_batch_size,table_of_clusters)
        %here pair labels is basically answering the question of
        %if the the left image (X1) has higher accuracy then the right image
        %if it does then the pair_label is 1
        %otherwise it is 0
        pair_labels = zeros(1,mini_batch_size);
        img_size = size(readimage(imds,1));
        X_1 = zeros([img_size 1 mini_batch_size],"single");
        X_2 = zeros([img_size 1 mini_batch_size],"single");

        all_indexes = 1:size(table_of_clusters,1);
        possible_pairs_to_use = nchoosek(all_indexes,2);

        random_idxs_to_train_on = randi(size(possible_pairs_to_use,1),[mini_batch_size,1]);

        data_samples_to_use =possible_pairs_to_use(random_idxs_to_train_on,:);

        image_files_in_readable_format = string(imds.Files);
        [file_path,~,~] = fileparts(image_files_in_readable_format(1));
        accuracies = nan(mini_batch_size,2);
        for i=1:mini_batch_size

            img_1_idx = data_samples_to_use(i,1);
            img_2_idx = data_samples_to_use(i,2);
            image_1_grades = table_of_clusters{img_1_idx,"grades"}{1};
           

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

            [pair_idx_1,~] = find(image_files_in_readable_format==fullfile(file_path,image_1_string));
            [pair_idx_2,~] = find(image_files_in_readable_format==fullfile(file_path,image_2_string));
            accuracies(i,1) = image_1_accuracy;
            accuracies(i,2) = image_2_accuracy;
            X_1(:,:,:,i) = imds.readimage(pair_idx_1);
            X_2(:,:,:,i) = imds.readimage(pair_idx_2);

            if image_1_accuracy > image_2_accuracy
                pair_labels(i) = 1;
            end
        end
    end


imds_train = imageDatastore(dir_with_cluster_images);
% imds_train.Files = strtrim(string(imds_train.Files));
if config.DEBUG_DAVID
    idx = randperm(numel(imds_train.Files),8);
    for p=1:numel(idx)
        subplot(4,2,p)
        imshow(readimage(imds_train,idx(p)));
        title(imds_train.Labels(idx(p)),Interpreter="none");
    end
end
close all;
 [X_1,X_2,pair_labels,accuracies] = get_twin_batch(imds_train,mini_batch_size,table_of_all_clusters);

end