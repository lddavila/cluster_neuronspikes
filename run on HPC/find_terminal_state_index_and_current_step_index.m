function [loc_of_terminal_state,loc_of_current_step,all_possible_permutations_of_grades] = find_terminal_state_index_and_current_step_index(presorted_grades_array,loc_of_current_sample_grades,presorted_table,blind_pass_table,current_state)
actual_accuracy = blind_pass_table{loc_of_current_sample_grades,"accuracy"};
[~,loc_of_terminal_state] = min(abs(actual_accuracy - presorted_table{:,"accuracy"}));

all_possible_permutations_of_grades = [presorted_grades_array,repmat(current_state(19:end),size(presorted_table,1),1)];
[loc_of_current_step,~ ]= find(ismember(current_state,all_possible_permutations_of_grades,'rows'));
end