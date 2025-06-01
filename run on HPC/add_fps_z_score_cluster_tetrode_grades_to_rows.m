function [current_rows] = add_fps_z_score_cluster_tetrode_grades_to_rows(ordered_list_of_tetrodes,j,relevant_rows,curr_z_sc)
current_rows = [];
current_tetrode = ordered_list_of_tetrodes(j);
if isempty(relevant_rows{j})
    return;
end

%first element of relevant rows is the file path of "t* output.mat"
%second element ... is ... "t* aligned.mat"
%third element ... is ... "t* reg_timestamps_of_spikes.mat"
%fourth element ... is ... "t* Grades.mat"
%fifth element ... is ... "t*.mat"

fp_to_output = fullfile(string(relevant_rows{j}{1}{1,"folder"}),string(relevant_rows{j}{1}{1,"name"}));
fp_to_aligned = fullfile(string(relevant_rows{j}{2}{1,"folder"}),string(relevant_rows{j}{2}{1,"name"}));
fp_to_ts = fullfile(string(relevant_rows{j}{3}{1,"folder"}),string(relevant_rows{j}{3}{1,"name"}));
fp_to_current_tetrode_grades = fullfile(string(relevant_rows{j}{4}{1,"folder"}),string(relevant_rows{j}{4}{1,"name"}));
fp_to_r_t_vals = fullfile(string(relevant_rows{j}{5}{1,"folder"}),string(relevant_rows{j}{5}{1,"name"}));


grades_struct = importdata(fp_to_current_tetrode_grades);
if isempty(grades_struct)
    return;
end
grades = struct2table(grades_struct);
% Convert rows to plain cell arrays
grades_as_cell_array = arrayfun(@(i) table2cell(grades(i, :)), 1:height(grades), 'UniformOutput', false);



current_rows = table(repelem(curr_z_sc,size(grades,1),1) ...
    ,repelem(current_tetrode,size(grades,1),1), ...
    (1:size(grades,1)).', ...
    grades_as_cell_array.', ...
    repelem(fp_to_output,size(grades,1),1),...
    repelem(fp_to_aligned,size(grades,1),1),...
    repelem(fp_to_ts,size(grades,1),1),...
    repelem(fp_to_current_tetrode_grades,size(grades,1),1),...
    repelem(fp_to_r_t_vals,size(grades,1),1),...
    'VariableNames', ...
    ["Z Score","Tetrode","Cluster","grades","dir_to_output","dir_to_aligned","dir_to_ts","dir_to_grades","dir_to_r_tvals"]);


end