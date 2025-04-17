function [stc] = second_level_tree(first_tree_classifier,grades)
%this second level tree is for datasets which were classified as neurons in the first tree
%this tree will handle each of them based off of that classifier
%it will be a hope to remove any cases that slipped through
%stc = second_tree_classification
stc = "";
if first_tree_classifier=="Neruon c1.1.1.1"
elseif first_tree_classifier=="Neuron c1.10"
    stc = "MUA";
elseif first_tree_classifier=="Neuron c1.2.1"
elseif first_tree_classifier=="Neuron c1.3"
elseif first_tree_classifier=="Neuron c1.4"
elseif first_tree_classifier=="Neuron c1.8"
elseif first_tree_classifier=="Neuron c1.9"
elseif first_tree_classifier=="Neuron c2.10"
elseif first_tree_classifier=="Neuron c2.11"
elseif first_tree_classifier=="Neuron c2.12"
elseif first_tree_classifier=="Neuron c2.3"
elseif first_tree_classifier=="Neuron c2.3.1"
elseif first_tree_classifier=="Neuron c2.3.2"
elseif first_tree_classifier=="Neuron c2.3.3"
elseif first_tree_classifier=="Neuron c2.4"
elseif first_tree_classifier=="Neuron c2.5"
elseif first_tree_classifier=="Neuron c2.6"
    stc = "MUA";
elseif first_tree_classifier=="Neuron c2.7"
elseif first_tree_classifier=="Neuron c2.8"
    stc = "MUA";
elseif first_tree_classifier=="Neuron c2.9"
else
    stc = "Defualt MUA";
end
end