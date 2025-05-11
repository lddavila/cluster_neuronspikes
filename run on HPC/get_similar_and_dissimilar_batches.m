function [] = get_similar_and_dissimilar_batches(dir_with_sorted_items,config,dir_to_save_similar_and_dissimilar,names_of_classes,batch_size)
    function [pair_image_1,pair_image_2,pair_label] = get_twin_batches(dir_with_sorted_items,names_of_classes,batch_size,config)
        pair_image_1 = cell(batch_size,1);
        pair_image_2 = cell(batch_size,1);
        pair_label = nan(batch_size,1);
        for i=1:batch_size
            random_first_class = randi(numel(names_of_classes)-1);
            random_second_class = randi(numel(names_of_classes)-1);
            if random_second_class==random_first_class
                pair_label(i) = 1;
            else
                pair_label(i)= 0;
            end
            list_of_first_class_files = strtrim(string(ls(fullfile(dir_with_sorted_items,string(random_first_class),"*.png"))));
            list_of_sec_class_files = strtrim(string(ls(fullfile(dir_with_sorted_items,string(random_second_class),"*.png"))));
            pair_image_1{i} = imread(fullfile(dir_with_sorted_items,string(random_first_class),list_of_first_class_files(randi(numel(list_of_first_class_files)))));
            pair_image_2{i} = imread(fullfile(dir_with_sorted_items,string(random_second_class),list_of_sec_class_files(randi(numel(list_of_sec_class_files)))));

            if config.DEBUG_DAVID
                figure
                subplot(1,2,1)
                imshow(pair_image_1{i});
                title(random_first_class)
                subplot(1,2,2)
                imshow(pair_image_2{i});
                title(random_second_class);
                close all;
            end
        end
    end

    function [net,fc_params] = get_neural_network()
        layers = [
            imageInputLayer([105 105 1],Normalization="none")
            convolution2dLayer(10,64,WeightsInitializer="narrow-normal",BiasInitializer="narrow-normal")
            reluLayer
            maxPooling2dLayer(2,Stride=2)
            convolution2dLayer(7,128,WeightsInitializer="narrow-normal",BiasInitializer="narrow-normal")
            reluLayer
            maxPooling2dLayer(2,Stride=2)
            convolution2dLayer(4,128,WeightsInitializer="narrow-normal",BiasInitializer="narrow-normal")
            reluLayer
            maxPooling2dLayer(2,Stride=2)
            convolution2dLayer(5,256,WeightsInitializer="narrow-normal",BiasInitializer="narrow-normal")
            reluLayer
            fullyConnectedLayer(4096,WeightsInitializer="narrow-normal",BiasInitializer="narrow-normal")];

        net = dlnetwork(layers);

        fc_weights = dlarray(0.01*randn(1,4096));
        fc_bias = dlarray(0.01*randn(1,1));

        fc_params = struct(...
            "FcWeights",fc_weights,...
            "FcBias",fc_bias);

    end
    function Y = forward_twin(net,fcParams,X1,X2)
        % forward_twin accepts the network and pair of training images, and
        % returns a prediction of the probability of the pair being similar (closer
        % to 1) or dissimilar (closer to 0). Use forwardTwin during training.

        % Pass the first image through the twin subnetwork
        Y1 = forward(net,X1);
        Y1 = sigmoid(Y1);

        % Pass the second image through the twin subnetwork
        Y2 = forward(net,X2);
        Y2 = sigmoid(Y2);

        % Subtract the feature vectors
        Y = abs(Y1 - Y2);

        % Pass the result through a fullyconnect operation
        Y = fullyconnect(Y,fcParams.FcWeights,fcParams.FcBias);

        % Convert to probability between 0 and 1.
        Y = sigmoid(Y);

    end
    function [loss,gradients_subnet,gradients_params] = model_loss(net,fc_params,X1,X2,pair_labels)

        % Pass the image pair through the network.
        Y = forwardTwin(net,fc_params,X1,X2);

        % Calculate binary cross-entropy loss.
        loss = crossentropy(Y,pair_labels,ClassificationMode="multilabel");

        % Calculate gradients of the loss with respect to the network learnable
        % parameters.
        [gradients_subnet,gradients_params] = dlgradient(loss,net.Learnables,fcParams);

    end
[net,fc_params] = get_neural_network;
[pair_image_1,pair_image_2,pair_label] = get_twin_batches(dir_with_sorted_items,names_of_classes,batch_size,config);

Y = forward_twin(net,fc_params,pair_image_1,pair_image_2);


disp("Number of Similar Images:"+string(sum(pair_label)))
disp("Number of dissimilar Images:"+string(sum(pair_label==0)))
end