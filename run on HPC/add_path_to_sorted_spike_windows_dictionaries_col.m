function [blind_pass_table] = add_path_to_sorted_spike_windows_dictionaries_col(blind_pass_table,config)
has_necessesary_cols = check_for_required_cols(blind_pass_table,["Tetrode","Cluster"],"add_path_to_dictionaries_col.m","",1);
if ~has_necessesary_cols
    disp("Cannot Add, missing necessary columns in blind_pass_table")
    return;
end
array_of_fpths = repelem("",size(blind_pass_table,1),1);
for i=1:size(blind_pass_table,1)
    current_z_score = blind_pass_table{i,"Z Score"};
    current_tetrode = blind_pass_table{i,"Tetrode"};
    name_of_file = current_tetrode +"sorted_spike_windows.mat";
    array_of_fpths(i)= fullfile(config.BLIND_PASS_DIR_PRECOMPUTED,"dictionaries min_z_score "+string(current_z_score)+" num_dps "+string(config.NUM_DPTS_TO_SLICE),name_of_file);
end
blind_pass_table.("fp_to_sorted_spike_windows") = array_of_fpths;
end