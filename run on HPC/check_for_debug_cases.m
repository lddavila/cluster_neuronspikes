function [branches_that_are_not_in_tp,branches_that_are_in_tp] = check_for_debug_cases(tp_table,fp_table)
tp_classification_cases = tp_table{:,"Classification"};
fp_classification_cases = fp_table{:,"Classification"};
branches_that_are_not_in_tp = fp_classification_cases(~ismember(fp_classification_cases,tp_classification_cases));
branches_that_are_in_tp = fp_classification_cases(ismember(fp_classification_cases,tp_classification_cases)); 
end