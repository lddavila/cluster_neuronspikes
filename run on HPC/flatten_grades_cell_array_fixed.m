function [grade_names,all_grades] = flatten_grades_cell_array_fixed(grades_in_cell_array_format,config)
all_grades = [];
% get_grades_correlation_with_accuracy
array_of_grades_to_check_correlation_for = 1:size(config.NAMES_OF_CURR_GRADES,2);
grade_names = [];
for i=1:size(grades_in_cell_array_format,1)
    current_grades = grades_in_cell_array_format{i};
    flattened_grades = [];
    grade_counter = 0;
    for j=1:size(array_of_grades_to_check_correlation_for,2)
        name_already_set = false;
        singular_grade = current_grades{array_of_grades_to_check_correlation_for(j)};
        if isempty(singular_grade)
            singular_grade = NaN;
            if i==1
                grade_names = [grade_names;config.NAMES_OF_CURR_GRADES(array_of_grades_to_check_correlation_for(j))];
                name_already_set = true;
            end
        end
        if size(singular_grade,2)==1
            flattened_grades = [flattened_grades,singular_grade];
            if i==1 && ~name_already_set
                grade_names = [grade_names;config.NAMES_OF_CURR_GRADES(array_of_grades_to_check_correlation_for(j))];
            end
            grade_counter = grade_counter+1;
        else
            for k=1:size(singular_grade,2)
                flattened_grades = [flattened_grades,singular_grade(k)];
                if i==1 && ~name_already_set
                    grade_names = [grade_names;config.NAMES_OF_CURR_GRADES(array_of_grades_to_check_correlation_for(j))];
                end
                grade_counter = grade_counter+1;
            end
        end

    end
    all_grades = [all_grades;flattened_grades];
end


end