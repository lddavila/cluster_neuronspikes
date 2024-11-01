function [did_it_pass_the_test,test_it_failed_on] = apply_noise_conditions_for_table(table_of_data,condition_names_to_use,conditions,values_to_compare_against,which_row_of_input_table_to_check)
%this function can be used to filter for noise clusters based on the grades they had in the initial pass
%By default the cluster does pass, but if any of the noise qualifications are met then it will be considered a noise cluster regardless of the other grades
%for that reason you should tune your parameters by order of importance
%generally noise clusters are defined by the following
    %low amplitude
    %bad cv 
        %bad cv means a very high coeffecient of variance
        %in a perfect world this will be 0, but that doesn't happen realistically
    %very low bhat distance
        %this is a point of some contention, and might be subject to chance
    %template matching
        %no idea still need to check
    %what can sometimes happen though is that a cluster's amplitude is very high
        %in this case we'll simply assume that it is a good cluster regardless of the other grades
test_it_failed_on = "";
did_it_pass_the_test = true;
for i=1:length(condition_names_to_use)
    current_variable_to_use = condition_names_to_use(i);
    column_of_info = table_of_data.(current_variable_to_use);
    single_value_to_check = column_of_info(which_row_of_input_table_to_check);
    if strcmpi(conditions(i),">")
        did_it_pass_the_test = single_value_to_check > values_to_compare_against(i);
    elseif strcmpi(conditions(i),"<")
        did_it_pass_the_test = single_value_to_check < values_to_compare_against(i);
    elseif strcmpi(conditions(i),">=")
        did_it_pass_the_test = single_value_to_check >= values_to_compare_against(i);
    elseif strcmpi(conditions(i),"<=")
        did_it_pass_the_test = single_value_to_check <= values_to_compare_against(i);
    elseif strcmpi(conditions(i), "=")
        did_it_pass_the_test = single_value_to_check == values_to_compare_against(i);
    else
        disp("The Condition array has an invalid string");
    end
    if ~did_it_pass_the_test
        test_it_failed_on = current_variable_to_use;
        break;
    end
end

end