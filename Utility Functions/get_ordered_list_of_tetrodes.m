function [ordered_list_of_tetrodes] = get_ordered_list_of_tetrodes(number_of_tetrodes)
ordered_list_of_tetrodes = strcat("t",string(1:number_of_tetrodes),".mat");
end