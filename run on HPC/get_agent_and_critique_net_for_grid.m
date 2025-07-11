function [agent,critic,obs_info,action_info] = get_agent_and_critique_net_for_grid(features,num_neurons_per_layer)
num_features = size(features,2);
obs_info = rlNumericSpec([1,num_features]);
action_info = rlFiniteSetSpec([0,1,-1,2,-2]);

obs_path = [featureInputLayer(prod(obs_info.Dimension)),
    fullyConnectedLayer(num_neurons_per_layer)
    reluLayer
    fullyConnectedLayer(num_neurons_per_layer,Name="obs_out")];

act_path = [featureInputLayer(prod(action_info.Dimension))
    fullyConnectedLayer(num_neurons_per_layer)
    reluLayer
    fullyConnectedLayer(5,Name="action_out")
    ];
common_path = [concatenationLayer(1,2,Name="cct")
    fullyConnectedLayer(num_neurons_per_layer)
    reluLayer
    fullyConnectedLayer(1,Name="output")];

net = dlnetwork;
net=addLayers(net,obs_path);
net=addLayers(net,act_path);
net = addLayers(net,common_path);

net = connectLayers(net,"obs_out","cct/in1");
net = connectLayers(net,"action_out","cct/in2");

net = initialize(net);

critic = rlQValueFunction(net,obs_info,action_info);
agent_options = rlQAgentOptions;

agent = rlQAgent(critic,agent_options);

agent.AgentOptions.EpsilonGreedyExploration.Epsilon = 0.2;
% act = getAction(agent,{randi(numel(obs_info.Elements))});


% env = rlFunctionEnv();

end