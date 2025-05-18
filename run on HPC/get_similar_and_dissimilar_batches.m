function [X_1,X_2,pair_labels] = get_similar_and_dissimilar_batches(dir_with_sorted_items,config,mini_batch_size)



    function [X_1,X_2,pair_labels] = get_twin_batch(imds,mini_batch_size)
        pair_labels = zeros(1,mini_batch_size);
        img_size = size(readimage(imds,1));
        X_1 = zeros([img_size 1 mini_batch_size],"single");
        X_2 = zeros([img_size 1 mini_batch_size],"single");

        for i=1:mini_batch_size
            choice = rand(1);

            if choice < 0.5
                [pair_idx_1,pair_idx_2,pair_labels(i)] = get_similar_pair(imds.Labels) ;
            else
                [pair_idx_1,pair_idx_2,pair_labels(i)] = get_dissimilar_pair(imds.Labels);
            end
            X_1(:,:,:,i) = imds.readimage(pair_idx_1);
            X_2(:,:,:,i) = imds.readimage(pair_idx_2);
        end
    end

    function [pair_idx_1,pair_idx_2,pair_label] = get_similar_pair(class_label)
        classes = unique(class_label);
        class_choice = randi(numel(classes));
        idxs = find(class_label == classes(class_choice));
        pair_idx_choice = randperm(numel(idxs),2);
        pair_idx_1 = idxs(pair_idx_choice(1));
        pair_idx_2 = idxs(pair_idx_choice(2));
        pair_label = 1;

    end
    function [pair_idx_1,pair_idx_2,pair_label] = get_dissimilar_pair(class_label)
        classes = unique(class_label);
        classes_choice = randperm(numel(classes),2);

        idxs_1 = find(class_label==classes(classes_choice(1)));
        idxs_2 = find(class_label==classes(classes_choice(2)));

        pair_idx_1_choice = randi(numel(idxs_1));
        pair_idx_2_choice = randi(numel(idxs_2));
        pair_idx_1 = idxs_1(pair_idx_1_choice);
        pair_idx_2 = idxs_2(pair_idx_2_choice);
        pair_label = 0;
    end
imds_train = imageDatastore(dir_with_sorted_items,IncludeSubfolders=true,LabelSource="foldernames");
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
 [X_1,X_2,pair_labels] = get_twin_batch(imds_train,mini_batch_size);

end