function [] = train_agent_in_nn_environment(image_array,accuracies)
 
observation_info = rlNumericSpec([1,size(image_array,2)],"Name","both_images");
action_info = rlFiniteSetSpec([1,2],"Name","better_choice");

env = rlNeuralNetworkEnvironment(observation_info,action_info,transitionFcn,rewardFcn,isDoneFcn);
end