function [graded_contamination_table,neurons_of_graded_contamination_table,group_counts] = grade_the_results_of_cont_table(contamination_table,number_of_units)
home_dir = cd("..");
addpath(genpath(pwd));
cd(home_dir);
contamination_table_as_cell_array = cell(1,size(contamination_table,1));
for i=1:length(contamination_table_as_cell_array)
    contamination_table_as_cell_array{i} = contamination_table(i,:);
end
column_of_classification = table(repelem("",size(contamination_table,1),1),'VariableNames',["Classification"]);
for i=1:length(contamination_table_as_cell_array)
    current_cluster_grades = cell2mat(contamination_table{i,"grades"});
    column_of_classification{i,1} = classify_clusters_based_on_grades_ver_2(current_cluster_grades);
end

graded_contamination_table = [contamination_table,column_of_classification];
neurons_of_graded_contamination_table = graded_contamination_table(contains(graded_contamination_table{:,"Classification"},"Neuron"),:);
disp(string(size(graded_contamination_table,1) - size(neurons_of_graded_contamination_table,1))+" were eliminated of original "+string(size(graded_contamination_table,1)) + " Leaving " +string(size(neurons_of_graded_contamination_table,1))+" identified as neurons")
neurons_that_meet_min_overlap = neurons_of_graded_contamination_table(neurons_of_graded_contamination_table{:,"Max Overlap % With Unit"} > 40,:);

for i=1:size(neurons_that_meet_min_overlap,1)
    unit_with_max_overlap = neurons_that_meet_min_overlap{i,"Max Overlap Unit"};
    number_of_units(unit_with_max_overlap) = nan;
end
disp("Units found: "+string(sum(isnan(number_of_units)))+"/"+string(length(number_of_units)))
group_counts = groupcounts(graded_contamination_table,"Classification");
disp(group_counts);

end
% classify_clusters_as_neurons_based_on_overlap_with_unit