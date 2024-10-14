function [] = find_how_many_unique_clusters_there_are(dir_with_nth_pass_results,list_of_tetrodes_to_check)
for i=1:length(list_of_tetrodes_to_check)
    current_tetrode = list_of_tetrodes_to_check(i);
    results_of_current_tetrode = importdata(current_tetrode +" output.mat");
    
end
end