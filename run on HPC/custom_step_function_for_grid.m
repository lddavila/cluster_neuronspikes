function [next_observation,reward,is_done,info] = custom_step_function_for_grid(action,info)
disp(action);
all_possible_permutations_of_grades=info.all_possible_permutations_of_grades;
loc_of_current_step = info.loc_of_current_step;
terminal_state_row =info.row_of_terminal_state;

state = info.initial_state;
% disp(info.initial_state)


terminal_state_2_index= size(all_possible_permutations_of_grades,1);

%first we must ask what action is being performed
if action==0 %stay
    if loc_of_current_step{1} == terminal_state_row %staying on the correct accuracy
        reward = 100;
        is_done = true;
    else %stopping on the inccorect row
        reward = -10;
        is_done = false;
    end
    next_observation = state;
    info.initial_state = next_observation;

elseif action==1 %move down
    if loc_of_current_step{1} == terminal_state_2_index %have reached the bottom boundry of your world and are trying to move down, cannot be done
        reward = -10;
        is_done = false;
        next_observation = state;
        info.initial_state = next_observation;
        info.loc_of_current_step = {loc_of_current_step{1},loc_of_current_step{2}};

    elseif loc_of_current_step{1} < terminal_state_row %move down, towards the correct terminal row
        reward = 1;
        is_done = false;
        next_observation = all_possible_permutations_of_grades{loc_of_current_step{1}+1,loc_of_current_step{2}};
        info.initial_state = next_observation;
        info.loc_of_current_step = {loc_of_current_step{1}+1,loc_of_current_step{2}};

    elseif loc_of_current_step{1} > terminal_state_row %move down, away from correct terminal row
        reward = -1;
        is_done = false;
        next_observation = all_possible_permutations_of_grades{loc_of_current_step{1}+1,loc_of_current_step{2}};
        info.initial_state = next_observation;
        info.loc_of_current_step = {loc_of_current_step{1}+1,loc_of_current_step{2}};
    elseif loc_of_current_step{1} == terminal_state_row %trying to move off the correct row will cause further penalties
        reward = -5;
        is_done = false;
        next_observation = all_possible_permutations_of_grades{loc_of_current_step{1}+1,loc_of_current_step{2}};
        info.initial_state = next_observation;
        info.loc_of_current_step = {loc_of_current_step{1}+1,loc_of_current_step{2}};
    end

elseif action==-1 %move up
    if loc_of_current_step{1} == 1 %trying to move up while already at the top, is impossible
        reward = -10;
        is_done = false;
        next_observation = state;
        info.initial_state = next_observation;
        info.loc_of_current_step =loc_of_current_step;
    elseif loc_of_current_step{1} < terminal_state_row %moving up, away from your terminal row is penalized
        reward = -1;
        next_observation = all_possible_permutations_of_grades{loc_of_current_step{1}-1,loc_of_current_step{2}};
        info.initial_state = next_observation;
        info.loc_of_current_step = {loc_of_current_step{1}-1,loc_of_current_step{2}};
        is_done = false;
    elseif loc_of_current_step{1} > terminal_state_row %moving up, toward your terminal row is rewarded
        reward = 1;
        next_observation = all_possible_permutations_of_grades{loc_of_current_step{1}-1,loc_of_current_step{2}};
        info.initial_state = next_observation;
        info.loc_of_current_step = {loc_of_current_step{1}-1,loc_of_current_step{2}};
        is_done = false;
    elseif loc_of_current_step{1} == terminal_state_row %trying to move off the correct row will cause further penalties
        reward = -5;
        is_done = false;
        next_observation = all_possible_permutations_of_grades{loc_of_current_step{1}+1,loc_of_current_step{2}};
        info.initial_state = next_observation;
        info.loc_of_current_step = {loc_of_current_step{1}-1,loc_of_current_step{2}};
    end


elseif action == 2 %move right
    if loc_of_current_step{2}==5 %trying to move right when you're at the boundry is impossible
        reward = -10;
        is_done = false;
        next_observation = state;
        info.initial_state = next_observation;
        info.loc_of_current_step = loc_of_current_step;
    elseif loc_of_current_step{1} == terminal_state_row %moving right on the terminal row incurs no penalty/or reward
        reward = 0;
        is_done = false;
        next_observation = all_possible_permutations_of_grades{loc_of_current_step{1},loc_of_current_step{2}+1};
        info.initial_state = next_observation;
        info.loc_of_current_step = {loc_of_current_step{1},loc_of_current_step{2}+1};
    elseif loc_of_current_step{1} ~= terminal_state_row %moving right on a non terminal row incurs a penalty
        reward = -1;
        is_done = false;
        next_observation = all_possible_permutations_of_grades{loc_of_current_step{1},loc_of_current_step{2}+1};
        info.initial_state = next_observation;
        info.loc_of_current_step = {loc_of_current_step{1},loc_of_current_step{2}+1};
    end

elseif action==-2 %move left
    if loc_of_current_step{2} == 1 %moving left when at the left boundary is prohibited
        reward = -10;
        is_done = false;
        next_observation =state;
        info.initial_state = next_observation;
        info.loc_of_current_step =loc_of_current_step;
    elseif loc_of_current_step{1} == terminal_state_row %moving left on the terminal row incurs no penalty/reward
        reward = 0;
        is_done = false;
        next_observation = all_possible_permutations_of_grades{loc_of_current_step{1},loc_of_current_step{2}-1};
        info.initial_state = next_observation;
        info.loc_of_current_step = {loc_of_current_step{1},loc_of_current_step{2}-1};
    elseif loc_of_current_step{1} ~= terminal_state_row %moving left on the non terminal row incurs a penalty
        reward = -1;
        is_done = false;
        next_observation = all_possible_permutations_of_grades{loc_of_current_step{1},loc_of_current_step{2}-1};
        info.initial_state = next_observation;
        info.loc_of_current_step = {loc_of_current_step{1},loc_of_current_step{2}-1};
    end

end



end