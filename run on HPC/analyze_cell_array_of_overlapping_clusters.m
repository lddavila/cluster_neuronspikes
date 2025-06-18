function [] = analyze_cell_array_of_overlapping_clusters(array_of_overlapping_clusters,config,table_of_unmerged_clusters)
list_of_units = 1:config.NUM_OF_UNITS;
cluster_groups_that_dont_meet_convergence = {};
for i=1:size(array_of_overlapping_clusters,2)
    current_data = array_of_overlapping_clusters{i};
    group_count_by_unit = groupcounts(current_data,"Max Overlap Unit");
    % disp(group_count_by_unit);
    if any(group_count_by_unit{:,"Percent"}>80,"all")
        [~,max_unit_index] = max(group_count_by_unit{:,"Percent"});
        max_unit = group_count_by_unit{max_unit_index,"Max Overlap Unit"};
        list_of_units = setdiff(list_of_units,[max_unit]);
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
end