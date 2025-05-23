function [average_accuracy,net,fc_params] = rate_cluster_quality_nn(number_of_its,mini_batch_size,learning_rate,grad_decay,grad_decay_sq,dir_with_training,dir_with_test,config,num_accuracy_tests,accuracy_batch_size,num_layers,num_neurons,which_loop)
    function [net,fc_params] = get_neural_network(num_layers)
        layers = [
            imageInputLayer([100 100 1],Normalization="none")
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
            reluLayer];

        for w=1:num_layers

            layers(end+1) = convolution2dLayer(3,10,WeightsInitializer="narrow-normal",BiasInitializer="narrow-normal",Padding="same");
            layers(end+1) = batchNormalizationLayer;
            layers(end+1) = reluLayer;
        end

        layers(end+1) = fullyConnectedLayer(4096,WeightsInitializer="narrow-normal",BiasInitializer="narrow-normal");

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
        Y = forward_twin(net,fc_params,X1,X2);

        % Calculate binary cross-entropy loss.
        loss = crossentropy(Y,pair_labels,ClassificationMode="multilabel");

        % Calculate gradients of the loss with respect to the network learnable
        % parameters.
        [gradients_subnet,gradients_params] = dlgradient(loss,net.Learnables,fc_params);

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


executionEnvironment = "auto";

if canUseGPU
    gpu = gpuDevice;
    disp(gpu.Name + " GPU detected and available for training.")
end
trailing_avg_subnet = [];
trailing_avg_sq_subnet = [];
trailing_avg_params = [];
trailing_avg_sq_params = [];

if ~config.ON_HPC
    monitor = trainingProgressMonitor(Metrics="Loss",XLabel="Iteration",Info="ExecutionEnvironment");

    if canUseGPU
        updateInfo(monitor,ExecutionEnvironment=gpu.Name +" GPU");
    else
        updateInfo(monitor,ExecutionEnvironment="CPU");
    end
end




iteration = 0;

[net,fc_params] = get_neural_network(num_layers);
loss = Inf;
last_loss = Inf;
current_loss = Inf;
difference_in_last_two_losses = Inf;


while iteration < number_of_its && loss > 1e-6 && difference_in_last_two_losses > 1e-5
   
    tic;
    iteration = iteration+1;
    [X_1,X_2,pair_labels] = get_similar_and_dissimilar_batches(dir_with_training,config,mini_batch_size);
    if canUseGPU
        X_1 = gpuArray(dlarray(X_1,"SSCB"));
        X_2 = gpuArray(dlarray(X_2,"SSCB"));
    else
        X_1 = dlarray(X_1,"SSCB");
        X_2 = dlarray(X_2,"SSCB");
    end

    %evaluate loss and gradients

    [loss,gradients_subnet,gradients_params] = dlfeval(@model_loss,net,fc_params,X_1,X_2,pair_labels);
    if iteration <1
        current_loss = loss;
    else
        last_loss = current_loss;
        current_loss = loss;
        difference_in_last_two_losses = abs(current_loss - last_loss);
        % fprintf("Difference in last 2 losses: %.6f\n",difference_in_last_two_losses);
    end

    %update the twin subnetwork parameters
    [net,trailing_avg_subnet,trailing_avg_sq_subnet] = adamupdate(net,gradients_subnet,trailing_avg_subnet,trailing_avg_sq_subnet,iteration,learning_rate,grad_decay,grad_decay_sq);

    %update the fully connected layer parameters
    [fc_params,trailing_avg_params,trailing_avg_sq_params] = adamupdate(fc_params,gradients_params,trailing_avg_params,trailing_avg_sq_params,iteration,learning_rate,grad_decay,grad_decay_sq);

    
    if ~config.ON_HPC
        recordMetrics(monitor,iteration,Loss = loss);
        monitor.Progress = 100 * iteration/number_of_its;
    end
    % disp("rate_cluster_quality_nn.m "+which_loop+" Finished "+string(iteration)+"/"+string(number_of_its))
    % elapsedTime = toc;
    % fprintf('Elapsed time: %.2f seconds\n', elapsedTime);
    % fprintf("Loss: %.6f\n",loss);
    
end

if iteration < 10000 
    disp("rate_cluster_quality_nn.m "+strjoin(string(which_loop)," ")+" Finished early on iteration "+string(iteration)+"/"+string(number_of_its));
    disp("Loss:"+string(loss));
    disp("Difference between in between last two losses:"+string(difference_in_last_two_losses));

end

accuracy = zeros(1,num_accuracy_tests);

for i=1:num_accuracy_tests
    [X_1,X_2,pair_labels_acc] = get_similar_and_dissimilar_batches(dir_with_test,config,accuracy_batch_size);

    X_1 = dlarray(X_1,"SSCB");
    X_2 = dlarray(X_2,"SSCB");

    if (executionEnvironment == "auto" && canUseGPU) || executionEnvironment == "gpu"
        X_1 = gpuArray(X_1);
        X_2 = gpuArray(X_2);
    end
    Y_ACCURACY = predict_twin(net,fc_params,X_1,X_2);
    Y_ACCURACY = gather(extractdata(Y_ACCURACY));
    Y_ACCURACY = round(Y_ACCURACY);


    accuracy(i) = sum(Y_ACCURACY==pair_labels_acc)/accuracy_batch_size;
end

average_accuracy = mean(accuracy)*100;



end