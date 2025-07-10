function [next_observation,reward,is_done,info] = custom_step_function(action,info)

all_possible_permutations_of_grades=info.all_possible_permutations_of_grades;
loc_of_current_step = info.loc_of_current_step;
terminal_state_1_index =info.terminal_state_1_index;

state = info.initial_state;


terminal_state_2_index= 100;

%set rewards for terminal condition
if action==0 && loc_of_current_step==terminal_state_1_index
    reward = 100; %stopping at the correct location invokes a reward of 10
elseif action==1 && loc_of_current_step+1>terminal_state_1_index
    reward = -10; %moving past the correct state invokes a penalty of -10
    %moving past the correct state should invoke a steeper penalty as I'd prefer to be more conservative than liberal in estimating accuracy
elseif action==0 && loc_of_current_step ~= terminal_state_1_index
    reward = -10; %staying on the correct location invokes a penalty of -10
elseif action==1 && loc_of_current_step ~= terminal_state_1_index
    reward = -1; %movement in general invokes a penalty of -1
end

%check to see if moving down is possible
%it's only ever not possible when your at the bottom of the table
if action==1 && loc_of_current_step==terminal_state_2_index
    reward = -10;
    is_done=true;
    next_observation = state;
    
else

    %now define the reward/punishment based on the true accuracy
    if action ==0
        next_observation = state;
    else
        next_observation = all_possible_permutations_of_grades(loc_of_current_step+1,:);
        info.initial_state = next_observation;
        info.loc_of_current_step = loc_of_current_step+1;
    end
end


%check if you have reached either possible terminal state
if loc_of_current_step == terminal_state_1_index
    is_done=true;
else
    is_done = false;
end

end