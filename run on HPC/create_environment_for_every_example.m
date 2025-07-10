function [cell_array_of_environments] = create_environment_for_every_example(presorted_grades,config,blind_pass_grades,obs_info,action_info)
   

cell_array_of_environments = cell(size(blind_pass_grades,1),1);

for i=1:size(blind_pass_grades,1)
    current_enviornment = rlFunctionEnv(obs_info,action_info);
end
end