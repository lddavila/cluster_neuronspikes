function [table_of_stats,unit_appearences_table] = get_nn_only_neurons_statistics(table_of_neurons,dir_to_save_results_to,min_accuracy,config)
get_table_of_all_clusters_from_blind_pass();
clc;
sliced_table = cell(size(table_of_neurons,1),1);

%slice the table for parallel processing
for i=1:size(table_of_neurons,1)
    sliced_table{i} = table_of_neurons(i,:);
end

disp("Finished Slicing")
matrix_of_true_positives = cell(size(table_of_neurons,1),1);
matrix_of_true_negatives = cell(size(table_of_neurons,1),1);
matrix_of_false_positives = cell(size(table_of_neurons,1),1);
matrix_of_false_negatives = cell(size(table_of_neurons,1),1);
matrix_of_max_overlap_units = cell(size(table_of_neurons,1),1);
number_of_samples = size(table_of_neurons,1);
num_its_to_perform = size(table_of_neurons,1);

%use this for loop to populate desired statistics on our table 
nn_struct = importdata("D:\cluster_neuronspikes\Predict Accuracy Category Based On Grades NN\accuracy score 0.86647number of acc cats 3 num layers 6 num neurons per layer35 grades neural network.mat");
nn = nn_struct.net;
for i=1:size(table_of_neurons,1)
    current_data = sliced_table{i};
    current_accuracy = current_data{1,"accuracy"};
    current_grades = current_data{1,"grades"}{1};
    current_max_overlap_unit = current_data{1,"Max Overlap Unit"};
    is_neuron_per_nn = current_grades{60};

    predicted_acc_cat = use_grades_nn_to_get_accuracy_cat(nn,current_data{1,"grades"},config);
    % predicted_acc_cat = 0;
    if current_accuracy >= min_accuracy && (is_neuron_per_nn || predicted_acc_cat==2)
        matrix_of_true_positives{i} = 1;
        matrix_of_max_overlap_units{i} = current_max_overlap_unit;
    elseif current_accuracy >= min_accuracy && ~is_neuron_per_nn
        matrix_of_false_negatives{i} = 1;    
    elseif current_accuracy < min_accuracy && is_neuron_per_nn
        matrix_of_false_positives{i} =1;
    elseif current_accuracy < min_accuracy && ~is_neuron_per_nn
        matrix_of_true_negatives{i} = 1;
    end

    disp("get_nn_only_neurons_statistics.m Finished "+string(i)+"/"+string(num_its_to_perform))
end

true_positive_count = sum(cell2mat(matrix_of_true_positives));
true_negative_count = sum(cell2mat(matrix_of_true_negatives));
false_negative_count = sum(cell2mat(matrix_of_false_negatives));
false_positive_count = sum(cell2mat(matrix_of_false_positives));

list_of_units = 1:config.NUM_OF_UNITS;

list_of_missing_units = setdiff(list_of_units,cell2mat(matrix_of_max_overlap_units));

table_of_stats = table(number_of_samples,true_positive_count,true_negative_count,false_negative_count,false_positive_count,list_of_missing_units);
unit_table = table(cell2mat(matrix_of_max_overlap_units),'VariableNames',"Unit");
unit_appearences_table = groupcounts(unit_table,"Unit");
disp(table_of_stats)
disp(unit_appearences_table)
end