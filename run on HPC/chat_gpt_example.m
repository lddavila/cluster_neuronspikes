obs_info = rlNumericSpec([2178 1]);
obs_info.Name = "obs_input";

action_info = rlFiniteSetSpec([0 1 -1]);
action_info.Name = "act_input";

% Observation path
obsLayers = [
    featureInputLayer(2178,"Name","obs_input")
    fullyConnectedLayer(5,"Name","fc1_obs")
    reluLayer("Name","relu1_obs")
    fullyConnectedLayer(5,"Name","fc2_obs")
];

% Action path
actLayers = [
    featureInputLayer(1,"Name","act_input") % scalar action input
    fullyConnectedLayer(5,"Name","fc1_act")
    reluLayer("Name","relu1_act")
    fullyConnectedLayer(5,"Name","fc2_act")
];

% Common path
commonLayers = [
    concatenationLayer(1,2,"Name","concat")
    fullyConnectedLayer(5,"Name","fc_common")
    reluLayer("Name","relu_common")
    fullyConnectedLayer(1,"Name","output") % scalar Q-value output
];

% Create layer graph and add layers
lgraph = layerGraph;
lgraph = addLayers(lgraph, obsLayers);
lgraph = addLayers(lgraph, actLayers);
lgraph = addLayers(lgraph, commonLayers);

% Connect obs and act paths to concatenation layer
lgraph = connectLayers(lgraph, "fc2_obs", "concat/in1");
lgraph = connectLayers(lgraph, "fc2_act", "concat/in2");

% Create dlnetwork
net = dlnetwork(lgraph);

% Create the critic with proper input names
critic = rlQValueFunction(net, obs_info, action_info, ...
    "ObservationInputNames","obs_input", ...
    "ActionInputNames","act_input");
