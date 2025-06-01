function Y = predict_twin(net,fc_params,X_1,X_2)
Y_1 = predict(net,X_1);
Y_1 = sigmoid(dlarray(Y_1));

Y_2 = predict(net,X_2);
Y_2 = sigmoid(dlarray(Y_2));

Y = abs(Y_1 - Y_2);
Y = dlarray(Y);

Y = fullyconnect(Y,fc_params.FcWeights,fc_params.FcBias,'DataFormat','S');

Y = sigmoid(Y);
end