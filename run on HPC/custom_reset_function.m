function [initial_observation,info] =custom_reset_function(beginning_of_environment_index,grades_array,size_of_blind_pass_table,blind_pass_table,presorted_grades_array,presorted_table)

random_sample_index = randi(size_of_blind_pass_table,1);





beginning_of_environment_grades = grades_array(beginning_of_environment_index,:);
random_sample_grades = grades_array(random_sample_index,:);

initial_state = [beginning_of_environment_grades,random_sample_grades];
%define the first terminal step and also the location of the current step as to define rewards
[terminal_state_1_index,loc_of_current_step,all_possible_permutations_of_grades] = find_terminal_state_index_and_current_step_index(presorted_grades_array,random_sample_index,presorted_table,blind_pass_table,initial_state);


initial_observation = initial_state;

info.initial_state = initial_state;
info.random_sample_index = random_sample_index;
info.terminal_state_1_index = terminal_state_1_index;
info.loc_of_current_step = loc_of_current_step;
info.all_possible_permutations_of_grades = all_possible_permutations_of_grades;

end