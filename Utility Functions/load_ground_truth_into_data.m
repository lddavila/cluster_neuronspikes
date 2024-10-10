function [ground_truth_indexes] = load_ground_truth_into_data(dir_with_ground_truth)
list_of_neuron_files = strtrim(string(ls(dir_with_ground_truth+"\*.mat")));
ground_truth_indexes = cell(1,size(list_of_neuron_files,1));
for i=1:size(list_of_neuron_files,1)
	ground_truth_indexes{i} = importdata(dir_with_ground_truth+"\"+ list_of_neuron_files(i));
end
end