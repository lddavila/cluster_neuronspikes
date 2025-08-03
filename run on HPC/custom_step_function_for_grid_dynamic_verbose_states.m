function [next_observation,reward,is_done,info] = custom_step_function_for_grid_dynamic_verbose_states(action,info, ...
    penalty_for_illegal_move, ...
    reward_for_correct_stop, ...
    reward_for_moving_towards_terminal_row, ...
    penalty_for_moving_away_from_terminal_row, ...
    penalty_for_incorrect_stop)
% disp(action);

all_possible_permutations_of_grades=info.all_possible_permutations_of_grades;
loc_of_current_step = info.loc_of_current_step;
terminal_state_row =info.row_of_terminal_state;

state = info.initial_state;

terminal_state_2_index= size(all_possible_permutations_of_grades,1);

%first we must ask what action is being performed
if action==0 %stay
    if loc_of_current_step == terminal_state_row %staying on the correct accuracy
        reward = reward_for_correct_stop;
        is_done = true;
        next_observation = state;
    else %stopping on the incorrect row, a dynamic penalty which is calculated based off distance from terminal row
        reward = penalty_for_incorrect_stop;
        is_done = false;
        %randomly jump to another state as a kind of soft reset
        %soft_reset_loc = randi([1,size(all_possible_permutations_of_grades,1)],1,1);
        %next_observation = all_possible_permutations_of_grades{soft_reset_loc};
        %info.loc_of_current_step = soft_reset_loc;
        next_observation = state;
    end
    
    info.initial_state = next_observation;

elseif action==1 %move down
    if loc_of_current_step == terminal_state_2_index %have reached the bottom boundry of your world and are trying to move down, cannot be done
        reward = penalty_for_illegal_move;
        is_done = false;
        next_observation = state;
        info.initial_state = next_observation;
        info.loc_of_current_step = loc_of_current_step;

    elseif loc_of_current_step < terminal_state_row %move down, towards the correct terminal row
        reward = reward_for_moving_towards_terminal_row;
        is_done = false;
        next_observation = all_possible_permutations_of_grades{loc_of_current_step+1};
        info.initial_state = next_observation;
        info.loc_of_current_step = loc_of_current_step+1;

    elseif loc_of_current_step > terminal_state_row %move down, away from correct terminal row
        reward = penalty_for_moving_away_from_terminal_row;
        is_done = false;
        next_observation = all_possible_permutations_of_grades{loc_of_current_step+1};
        info.initial_state = next_observation;
        info.loc_of_current_step = loc_of_current_step+1;
    elseif loc_of_current_step == terminal_state_row %trying to move off the correct row will cause further penalties
        reward = penalty_for_moving_away_from_terminal_row;
        is_done = false;
        next_observation = all_possible_permutations_of_grades{loc_of_current_step+1};
        info.initial_state = next_observation;
        info.loc_of_current_step = loc_of_current_step+1;
    end

elseif action==-1 %move up
    if loc_of_current_step == 1 %trying to move up while already at the top, is impossible
        reward = penalty_for_illegal_move;
        is_done = false;
        next_observation = state;
        info.initial_state = next_observation;
        info.loc_of_current_step =loc_of_current_step;
    elseif loc_of_current_step < terminal_state_row %moving up, away from your terminal row is penalized
        reward = penalty_for_moving_away_from_terminal_row;
        next_observation = all_possible_permutations_of_grades{loc_of_current_step-1};
        info.initial_state = next_observation;
        info.loc_of_current_step = loc_of_current_step-1;
        is_done = false;
    elseif loc_of_current_step > terminal_state_row %moving up, toward your terminal row is rewarded
        reward = reward_for_moving_towards_terminal_row;
        next_observation = all_possible_permutations_of_grades{loc_of_current_step-1};
        info.initial_state = next_observation;
        info.loc_of_current_step = loc_of_current_step-1;
        is_done = false;
    elseif loc_of_current_step == terminal_state_row %trying to move off the correct row will cause further penalties
        reward = penalty_for_moving_away_from_terminal_row;
        is_done = false;
        next_observation = all_possible_permutations_of_grades{loc_of_current_step-1};
        info.initial_state = next_observation;
        info.loc_of_current_step = loc_of_current_step-1;
    end




end



end