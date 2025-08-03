function [blind_pass_table] = add_number_of_overlap_percentages_above_one_col(blind_pass_table)
sliced_bp_table = slice_table_for_parallel_processing(blind_pass_table,[]);
has_mulitple_under_units = zeros(size(blind_pass_table,1),1);
for i=1:size(blind_pass_table,1)
    current_data = sliced_bp_table{i};
    overlaps_with_all_units = current_data{1,"overlap % with all units"}{1};
    has_mulitple_under_units(i) = sum(overlaps_with_all_units>1,"all");

end
blind_pass_table.("num_of_overlap_percentages_over_1") = has_mulitple_under_units;
disp("Finished getting under unit data.")
end