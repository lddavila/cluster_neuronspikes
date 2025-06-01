function [quality_pred] = predict_accuracy_using_twin_nn(first_dimension,second_dimension,peaks,config,peaks_in_cluster)

    function [predicted_accuracy_cat] = get_comparison_score_against_all_images(dir_with_comparison_images,net,fc_params,imds_1)
        list_of_files = struct2table(dir(dir_with_comparison_images));
        imgSize = size(readimage(imds_1,1));
        X_1 = zeros([imgSize 1 1],"single");
        X_1(:,:,:,1) = imds_1.readimage(1);
        mean_similarity_score_per_class = size(list_of_files,1)-2; %-2 for the "." and ".." directories
        for i=1:size(list_of_files,1)
            if string(list_of_files{i,"name"}) == "."||string(list_of_files{i,"name"}) == ".."
                continue;
            end
            dir_of_current_cat = fullfile(string(list_of_files{i,"folder"}),string(list_of_files{i,"name"}));
            all_files_of_current_cat = struct2table(dir(dir_of_current_cat));
            array_of_similarity_scores_for_current_class =nan(size(all_files_of_current_cat,1)-2,1); %-2 to account for the . and ..

            for j=1:size(all_files_of_current_cat,1)
                if all_files_of_current_cat{j,"name"}=="." || all_files_of_current_cat{j,"name"} == ".."
                    continue;
                end
                location_of_current_compare_image = fullfile(dir_of_current_cat,string(all_files_of_current_cat{j,"name"}));
                imds_2 = imageDatastore(location_of_current_compare_image);
                X_2 = zeros([imgSize 1 1],"single");
                X_2(:,:,:,1) = imds_2.readimage(2);
                % 
                % predict_score = predict_twin(quality_pred_nn_struct,dlarray(single(resized_and_gray_scaled_image)));
                % Y = predictTwin(net,fcParams,X1,X2);
                % 
                % % Convert predictions to binary 0 or 1
                % Y = gather(extractdata(Y));
                % Y = round(Y);
                


                temp_y = predict_twin(net,fc_params,X_1,X_2);
                array_of_similarity_scores_for_current_class(j-2) = gather(extractdata(temp_y));
            end
            mean_similarity_score_per_class(i-2) = mean(array_of_similarity_scores_for_current_class,"all");
        end

        [max_mean_similarity_score,index_of_max_mean_similarity_score] = max(mean_similarity_score_per_class);
        if max_mean_similarity_score < .5
            predicted_accuracy_cat = 0;
        else
            predicted_accuracy_cat = index_of_max_mean_similarity_score-1;
        end
    end

    function Y = predict_twin(net,fc_params,X_1,X_2)
        Y_1 = predict(net,X_1);
        Y_1 = sigmoid(Y_1);

        Y_2 = predict(net,X_2);
        Y_2 = sigmoid(Y_2);

        Y = abs(Y_1 - Y_2);

        Y = fullyconnect(Y,fc_params.FcWeights,fc_params.FcBias);

        Y = sigmoid(Y);
    end

%to ensure that the peaks have the same dimension we ensure that the numer of rows is greater than number of cols
%this should always be true because it's impossible to have more wires than spikes
%if it isn't the case then we transpose it so that it is
if size(peaks,1) < size(peaks,2)
    peaks = peaks.';
end

peaks_in_cluster(peaks_in_cluster > size(peaks,1)) = [];
cluster = peaks(peaks_in_cluster, :);
cluster_x = cluster(:, first_dimension); %column should correspond to the rep wire
cluster_y = cluster(:, second_dimension); %column should correspond to the second rep wire
n = config.NUM_STDS_AROUND_CLUSTER; %number of standard deviations, theres no one right standard deviation, but this one seems to be good for my purposes
cluster_x_mean = mean(cluster_x,'all');
cluster_x_std = std(cluster_x);
n_stds_right_of_cluster = cluster_x_mean+ (n*cluster_x_std);
n_std_left_of_cluster = cluster_x_mean - (n*cluster_x_std);

cluster_y_mean = mean(cluster_y,"all");
cluster_y_std = std(cluster_y);
n_stds_above_cluster = cluster_y_mean+ (n*cluster_y_std);
n_std_below_cluster = cluster_y_mean - (n*cluster_y_std);


c1 = peaks(:,first_dimension) < n_stds_right_of_cluster & peaks(:,first_dimension) > n_std_left_of_cluster;
c2 = peaks(:,second_dimension) < n_stds_above_cluster & peaks(:,second_dimension) > n_std_below_cluster;




colors = distinguishable_colors(1); %will always use the same colors
my_gray = [0.5 0.5 0.5];
hold on
f = figure;




scatter(peaks(c1 & c2, first_dimension), peaks(c1 & c2, second_dimension), 2,my_gray);
%for the above scatter to work the number of cols in peaks must correspond to the number of wires in the current tetrode


if isempty(peaks_in_cluster)
    quality_pred = NaN;
    return
end

if config.ON_HPC
    quality_pred_nn_struct = importdata(config.FP_TO_TWIN_NN_PREDICTOR_ON_HPC);
    dir_with_comparison_images = config.DIR_TO_ACC_CAT_IMAGES_ON_HPC;

else
    quality_pred_nn_struct = importdata(config.FP_TO_TWIN_NN_PREDICTOR);
    dir_with_comparison_images = config.DIR_TO_ACC_CAT_IMAGES;
end

quality_nn = quality_pred_nn_struct.net;
quality_fc_params = quality_pred_nn_struct.fc_params;



hold on;
scatter(cluster_x, cluster_y, 2,colors(1,:))
axis equal;
axis off;

randomized_temp_file_number_sequence = randi(1e9, 1, 10);

file_save_name = strjoin(string(randomized_temp_file_number_sequence))+".png"; %this file will be deleted
% so we just randomly generate 10 numbers between 1 and billion and use this as a file name to avoid a multi threaded process accidentally
%reading the same file
saveas(f,file_save_name);
close(f);
RGB = imread(file_save_name);
grayscaled_image =rgb2gray(RGB);
resized_and_gray_scaled_image = imresize(grayscaled_image,[224,224]);
delete(file_save_name);

imwrite(resized_and_gray_scaled_image,file_save_name);

imds = imageDatastore(fullfile(pwd,file_save_name));

quality_pred = get_comparison_score_against_all_images(dir_with_comparison_images,quality_nn,quality_fc_params,imds);



delete(file_save_name);

end