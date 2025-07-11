function [row_of_terminal_state,loc_of_current_step,all_possible_permutations_of_grades] = find_terminal_state_index_and_current_step_index_for_grid(presorted_grades_array,loc_of_current_sample_grades,presorted_table,blind_pass_table,current_state)
actual_accuracy = blind_pass_table{loc_of_current_sample_grades,"accuracy"};
presorted_table_accuracy = presorted_table{:,"accuracy"};
presorted_table_accuracy = reshape(presorted_table_accuracy,5,[]).';
differences_between_act_acc_and_presorted_accuracy = abs(actual_accuracy - presorted_table_accuracy);

[~,row_of_terminal_state] = min(mean(differences_between_act_acc_and_presorted_accuracy,2));

all_possible_permutations_of_grades = cell(size(presorted_grades_array));
for i=1:size(all_possible_permutations_of_grades,1)
    for j=1:size(all_possible_permutations_of_grades,2)
        all_possible_permutations_of_grades{i,j} =[presorted_grades_array{i,j},current_state(19:end)];
    end
end

for i=1:size(all_possible_permutations_of_grades,1)
    for j=1:size(all_possible_permutations_of_grades,2)
        if all(current_state==all_possible_permutations_of_grades{i,j})
            loc_of_current_step = {i,j};
        end
    end
end
end