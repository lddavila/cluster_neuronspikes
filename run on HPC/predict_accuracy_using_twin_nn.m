function [quality_pred] = predict_accuracy_using_twin_nn(first_dimension,second_dimension,peaks,config,peaks_in_cluster)

    function Y = predict_twin(net,fc_params,X_1,X_2)
        Y_1 = predict(net,X_1);
        Y_1 = sigmoid(Y_1);

        Y_2 = predict(net,X_2);
        Y_2 = sigmoid(Y_2);

        Y = abs(Y_1 - Y_2);

        Y = fullyconnect(Y,fc_params.FcWeights,fc_params.FcBias);

        Y = sigmoid(Y);
    end
colors = distinguishable_colors(1); %will always use the same colors
my_gray = [0.5 0.5 0.5];
hold on
f = figure;

%to ensure that the peaks have the same dimension we ensure that the numer of rows is greater than number of cols
%this should always be true because it's impossible to have more wires than spikes
%if it isn't the case then we transpose it so that it is
if size(peaks,1) < size(peaks,2)
    peaks = peaks.';
end
scatter(peaks(:, first_dimension), peaks(:, second_dimension), 2,my_gray);
%for the above scatter to work the number of cols in peaks must correspond to the number of wires in the current tetrode


if isempty(peaks_in_cluster)
    quality_pred = NaN;
    return
end

if config.ON_HPC
    quality_pred_nn_struct = importdata(config.FP_TO_TWIN_NN_PREDICTOR_ON_HPC);
    
else
    quality_pred_nn_struct = importdata(config.FP_TO_ACC_PREDICTING_NN);
end

quality_nn = quality_pred_nn_struct.net;
quality_fc_params = quality_pred_nn_struct.fc_params;


peaks_in_cluster(peaks_in_cluster > size(peaks,1)) = [];
cluster = peaks(peaks_in_cluster, :);
cluster_x = cluster(:, first_dimension); %column should correspond to the rep wire
cluster_y = cluster(:, second_dimension); %column should correspond to the second rep wire
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
resized_and_gray_scaled_image = imresize(grayscaled_image,[100,100]);

predict_score = predit_twin(quality_pred_nn_struct,dlarray(single(resized_and_gray_scaled_image)));


end