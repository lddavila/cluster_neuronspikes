function [initial_observation,info] =custom_reset_function_for_grid_verbose_states(grades_array,blind_pass_table,array_of_training_idxs,cell_array_of_grades,acc_cat_dividers)



%choose a random grade set for the agent to bring into the environment 
training_set_idx = randi([1,size(array_of_training_idxs,2)],1,1);
random_sample_index = blind_pass_table{array_of_training_idxs(training_set_idx),"OG_IDX"};

%get the accuracy of the random sample to determine the terminal state
random_sample_accuracy = blind_pass_table{array_of_training_idxs(training_set_idx),"accuracy"};

%chose a random starting point
random_starting_point = randi(size(cell_array_of_grades,1),1);

%get the grades of the random sample
random_sample_grades = grades_array(random_sample_index,:);

%append the agent's grade set to the enviornment indexes
for i=1:size(cell_array_of_grades,1)
    cell_array_of_grades{i} = [cell_array_of_grades{i},random_sample_grades];
end

%find the terminal state
for i=1:size(acc_cat_dividers,2)-1
    lower_bound_cond = acc_cat_dividers(i) < random_sample_accuracy; 
    upper_bound_cond = acc_cat_dividers(i+1) >= random_sample_accuracy;
    if lower_bound_cond && upper_bound_cond
        row_of_terminal_state = i;
    end
    
end

initial_state = cell_array_of_grades{random_starting_point};


initial_observation = initial_state;

info.initial_state = initial_state;
info.random_sample_index = random_sample_index;
info.row_of_terminal_state= row_of_terminal_state;
info.loc_of_current_step = random_starting_point;
info.all_possible_permutations_of_grades = cell_array_of_grades;

end