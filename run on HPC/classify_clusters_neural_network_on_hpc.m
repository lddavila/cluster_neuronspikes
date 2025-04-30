function [accuracy,net,layers] = classify_clusters_neural_network_on_hpc(config,num_layers,filter_size)
% disp("Beginning NN Training")
% table_of_clusters(isnan(table_of_clusters{:,"accuracy_category"}),:) = [];
if config.ON_HPC
    imds = imageDatastore(config.DIR_TO_SAVE_CLUSTER_IMAGE_PNGS_TO_ON_HPC);
else
    imds = imageDatastore(config.DIR_WITH_NUMBER_BASED_IMAGES,IncludeSubfolders=true,LabelSource="foldernames");
    spikesort_config
end


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


layers(end+1) = fullyConnectedLayer(num_classes);
layers(end+1)=softmaxLayer;

try
    options = trainingOptions("sgdm", ...
        InitialLearnRate=0.01, ...
        MaxEpochs=20, ...
        Shuffle="every-epoch", ...
        ValidationData=imds_validation, ...
        ValidationFrequency=30, ...
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