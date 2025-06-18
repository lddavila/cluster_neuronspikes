function [] = print_status_iter_message(name_of_function,iteration,number_of_iterations)
disp(name_of_function+" Finished "+strjoin(string(iteration)," ")+"/"+string(number_of_iterations));
end