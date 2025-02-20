function [ground_truth_indexes] = load_ground_truth_into_data(dir_with_ground_truth)
list_of_neuron_files = strtrim(string(ls(fullfile(dir_with_ground_truth,"*.mat"))));
ground_truth_indexes = cell(1,size(list_of_neuron_files,1));
for i=1:size(list_of_neuron_files,1)
	ground_truth_indexes{i} = importdata(fullfile(dir_with_ground_truth, list_of_neuron_files(i)));
    for j=1:size(ground_truth_indexes{i},2)
        ground_truth_indexes{i}{j} = ground_truth_indexes{i}{j} +1;
    end
end
end