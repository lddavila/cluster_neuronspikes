function [] = analyze_cell_array_of_overlapping_clusters(array_of_overlapping_clusters,config)
% test_choose_best_nn
list_of_units = 1:config.NUM_OF_UNITS;
cluster_groups_that_dont_meet_convergence = {};
unit_counts = zeros(1,size(list_of_units,2));
cell_table_of_max_appearences = cell(size(list_of_units,2),1);
for i=1:size(array_of_overlapping_clusters,2)
    current_data = array_of_overlapping_clusters{i};
    group_count_by_unit = groupcounts(current_data,"Max Overlap Unit");
    max_accuracy = max(current_data{:,"accuracy"});
    % disp(group_count_by_unit);
    [~,max_unit_index] = max(group_count_by_unit{:,"Percent"});
    if group_count_by_unit{max_unit_index,"Percent"}>sum(group_count_by_unit{setdiff(1:size(group_count_by_unit,1),max_unit_index),"Percent"})
        max_unit = group_count_by_unit{max_unit_index,"Max Overlap Unit"};
        list_of_units = setdiff(list_of_units,max_unit);
        unit_counts(max_unit) = unit_counts(max_unit)+1;
        cell_table_of_max_appearences{max_unit} = [cell_table_of_max_appearences{max_unit};max_accuracy];
    else
        cluster_groups_that_dont_meet_convergence{end+1} = current_data;
    end 
    
end
disp("Missing Units")
disp(list_of_units);
disp("cluster groups that have no dominant")
for i=1:size(cluster_groups_that_dont_meet_convergence,2)
    disp(groupcounts(cluster_groups_that_dont_meet_convergence{i},"Max Overlap Unit"))
end

disp("Unit Counts Appearences")
disp([(1:config.NUM_OF_UNITS).',unit_counts.'])

for i=1:size(cell_table_of_max_appearences)
    disp(cell_table_of_max_appearences{i});
end
end