function [blind_pass_table] = determine_multiple_under_units(blind_pass_table)
sliced_bp_table = slice_table_for_parallel_processing(blind_pass_table,[]);
has_mulitple_under_units = zeros(size(blind_pass_table,1),1);
for i=1:size(blind_pass_table,1)
    current_data = sliced_bp_table{i};
    overlaps_with_all_units = current_data{1,"overlap % with all units"}{1};
    [sorted_overlap_percentages,indexes_of_overlap] = sort(overlaps_with_all_units,"descend");
    % disp("Cluster Has the following overlap %");
    % disp(sorted_overlap_percentages(1:5));
    % disp("For the Following units:")
    % disp(indexes_of_overlap(1:5))
    % disp("###############################")
    if sum(sorted_overlap_percentages(1:2) > 10)>1 && sorted_overlap_percentages(1) < 60
        has_mulitple_under_units(i) = true;
    elseif sum(sorted_overlap_percentages(1:2) > 10)>1 && sorted_overlap_percentages(1) > 60
        has_mulitple_under_units(i) = false;
    elseif sum(sorted_overlap_percentages(1:2) >10) == 0
        has_mulitple_under_units(i) = true;
    else
        has_mulitple_under_units(i) = true;
    end
end
blind_pass_table.("has_multiple_under_units") = has_mulitple_under_units;
disp("Finished getting under unit data.")
end