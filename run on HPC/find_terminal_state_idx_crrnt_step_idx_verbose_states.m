function [row_of_terminal_state,loc_of_current_step,all_possible_permutations_of_grades] = find_terminal_state_idx_crrnt_step_idx_verbose_states(presorted_grades_array,current_state,number_of_accuracy_cats)

differences_between_act_acc_and_presorted_accuracy = abs(actual_accuracy - presorted_table_accuracy);

[~,row_of_terminal_state] = min(mean(differences_between_act_acc_and_presorted_accuracy,2));

all_possible_permutations_of_grades = cell(size(presorted_grades_array,1),1);
for i=1:size(all_possible_permutations_of_grades,1)
    all_possible_permutations_of_grades{i} =[cell2mat(presorted_grades_array(i,:)),current_state(19:end)];
end

for i=1:size(all_possible_permutations_of_grades,1)
    if all(current_state==all_possible_permutations_of_grades{i})
        loc_of_current_step = {i};
    end

end
end