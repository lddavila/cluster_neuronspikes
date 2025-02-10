function [correlation_between_accuracy_and_grades,correlation_between_overlap_and_grades] = get_correlation_coeffecients(all_best_accuracies_array,all_best_overlaps_array,all_best_grades_array,grades_to_check,names_of_grades)
correlation_between_accuracy_and_grades = table(nan(size(grades_to_check,2),1),nan(size(grades_to_check,2),1),repelem("default",size(grades_to_check,2),1),'VariableNames',["Corr Coeff of accuracy to grades.","P-Value","Grade"]);
correlation_between_overlap_and_grades = table(nan(size(grades_to_check,2),1),nan(size(grades_to_check,2),1),repelem("default",size(grades_to_check,2),1),'VariableNames',["Corr Coeff of overlap to grades.","P-Value","Grade"]);

for i=1:size(grades_to_check,2)
    [accuracy_corr_coef,accuracy_corr_coeff_p_value] = corrcoef(all_best_accuracies_array,all_best_grades_array(:,i),"Rows","complete");
    [overlap_corr_coef,overlap_corr_coeff_p_value] = corrcoef(all_best_overlaps_array,all_best_grades_array(:,i),"Rows","complete");
    % disp(accuracy_corr_coef);
    % disp(overlap_corr_coef)
    correlation_between_overlap_and_grades{i,1}= overlap_corr_coef(1,2);
    correlation_between_overlap_and_grades{i,2}= overlap_corr_coeff_p_value(1,2);
    correlation_between_overlap_and_grades{i,3}=names_of_grades(i) ;

    correlation_between_accuracy_and_grades{i,1}= accuracy_corr_coef(1,2);
    correlation_between_accuracy_and_grades{i,2}= accuracy_corr_coeff_p_value(1,2);
    correlation_between_accuracy_and_grades{i,3}=names_of_grades(i) ;
end

end