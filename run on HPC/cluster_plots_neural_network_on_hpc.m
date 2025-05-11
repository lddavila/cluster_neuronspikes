function [accuracy,net,layers] = cluster_plots_neural_network_on_hpc(table_of_clusters,config,num_layers,filter_size)
% disp("Beginning NN Training")
table_of_clusters(isnan(table_of_clusters{:,"accuracy_category"}),:) = [];
if config.ON_HPC
    imds = imageDatastore(config.DIR_TO_SAVE_CLUSTER_IMAGE_PNGS_TO_ON_HPC);
else
    imds = imageDatastore(config.DIR_TO_SAVE_CLUSTER_IMAGE_PNGS_TO);
    spikesort_config
end

%find the appropriate accuracy category for each of the images
array_of_accuracy_cats = nan(size(imds.Files,1),1);
for i=1:size(imds.Files,1)
    current_filename = imds.Files{i};
    [~,name,~] = fileparts(current_filename);
    data = split(name);
    z_score = str2double(data{3});
    tetrode = data{5};
    cluster = str2double(data{7});
    c1 = table_of_clusters{:,"Z Score"}==z_score;
    c2 = table_of_clusters{:,"Tetrode"}==tetrode;
    c3 = table_of_clusters{:,"Cluster"}==cluster;
    % if mod(i,500)==0
    %     disp("Finished "+string(i)+"/"+size(imds.Files,1));
    % end
    if sum(c1 & c2 & c3)==0
        array_of_accuracy_cats(i) = 0;
        continue;
    end
    array_of_accuracy_cats(i) = table_of_clusters{c1 & c2 & c3,"accuracy_category"};
end
% disp("Finished Assigning Accuracy Category To Images")
imds.Labels = categorical(array_of_accuracy_cats);

tbl_of_cat_counts = countEachLabel(imds);
min_set_count = min(tbl_of_cat_counts{:,2});

[imds_train,imds_validation] = splitEachLabel(imds,.8,"randomized");

input_size = [224,224,1];
class_names= categories(imds_train.Labels);
num_classes = size(class_names,1);


layers = [
    imageInputLayer(input_size)

    convolution2dLayer(3,8,Padding="same")
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,Stride=2)
    convolution2dLayer(3,16,Padding="same")
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,Stride=2)];

for i=1:num_layers
    layers(end+1) = convolution2dLayer(3,filter_size,Padding="same");
    layers(end+1) = batchNormalizationLayer;
    layers(end+1) = reluLayer;
    if i<5
        layers(end+1) = maxPooling2dLayer(2,Stride=2);
    end
end

% convolution2dLayer(3,16,Padding="same")
% batchNormalizationLayer
% reluLayer
%
% maxPooling2dLayer(2,Stride=2)
%
% convolution2dLayer(3,32,Padding="same")
% batchNormalizationLayer
% reluLayer
%
% maxPooling2dLayer(2,Stride=2)
%
% convolution2dLayer(3,64,Padding="same")
% batchNormalizationLayer
% reluLayer
%
% maxPooling2dLayer(2,Stride=2)
%
% convolution2dLayer(3,128,Padding="same")
% batchNormalizationLayer
% reluLayer
%
% maxPooling2dLayer(2,Stride=2)
%
% convolution2dLayer(3,256,Padding="same")
% batchNormalizationLayer
% reluLayer
%
% maxPooling2dLayer(2,Stride=2)
%
% convolution2dLayer(3,512,Padding="same")
% batchNormalizationLayer
% reluLayer
%
% maxPooling2dLayer(2,Stride=2)

layers(end+1) = fullyConnectedLayer(num_classes);
layers(end+1)=softmaxLayer;

try
    options = trainingOptions("sgdm", ...
        InitialLearnRate=0.5 ,...
        MaxEpochs=20, ...
        Shuffle="every-epoch", ...
        ValidationData=imds_validation, ...
        ValidationFrequency=30, ...
        Plots="training-progress", ...
        Metrics="accuracy", ...
        Verbose=false);

    net = trainnet(imds_train,layers,'crossentropy',options);
    accuracy = testnet(net,imds_validation,"accuracy");
catch ME
    disp("num layers")
    disp(string(num_layers))
    disp("filter size")
    disp(string(filter_size))
    disp(ME.identifier)
    disp(ME.message)
    disp(ME.cause)
    accuracy = NaN;
end

end