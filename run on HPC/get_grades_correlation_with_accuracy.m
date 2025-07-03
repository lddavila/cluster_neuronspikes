function [correlation_with_accuracy_table] = get_grades_correlation_with_accuracy(blind_pass_table,config)

% update_grades_in_overlap_table
[grade_names,all_grades]= flatten_grades_cell_array(blind_pass_table{:,"grades"},config);
[indexes_of_grades_were_looking_for,~] = find(ismember(grade_names,config.NAMES_OF_CURR_GRADES(config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST)));
grades_array = all_grades(:,indexes_of_grades_were_looking_for);

correlation_with_accuracy_table = table((config.NAMES_OF_CURR_GRADES(config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST)).',nan(size(config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST,2),1),nan(size(config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST,2),1),'VariableNames',["grade","r","p-value"]);
accuracy = blind_pass_table{:,"accuracy"};
for i=1:size(grades_array,2)
    current_grade = grades_array(:,i);
    [r,p] = corrcoef(current_grade,accuracy);
    correlation_with_accuracy_table{i,"r"} = r(1,2);
    correlation_with_accuracy_table{i,"p-value"} = p(1,2);
end

correlation_with_accuracy_table = sortrows(correlation_with_accuracy_table,"r");


disp(correlation_with_accuracy_table)
end