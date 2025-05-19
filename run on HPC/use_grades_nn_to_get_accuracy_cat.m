function [accuracy_category] = use_grades_nn_to_get_accuracy_cat(nn,current_grades,config)



[grade_names,all_grades]= flatten_grades_cell_array(current_grades,config);
[indexes_of_grades_were_looking_for,~] = find(ismember(grade_names,config.NAMES_OF_CURR_GRADES(config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST)));
try
    grades = all_grades(:,indexes_of_grades_were_looking_for);
    predictions_from_nn =predict(nn,grades);
    [~,index_of_max] = max(predictions_from_nn);
    accuracy_category = index_of_max-1;
catch
    accuracy_category = 0;
end
end