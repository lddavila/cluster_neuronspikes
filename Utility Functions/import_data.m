function [grades,output,aligned,reg_timestamps_of_the_spikes,idx] = import_data(dir_with_grades,dir_with_outputs,current_tetrode,refinement_pass)

try
    
    load(dir_with_grades+"\"+current_tetrode+" Grades.mat","grades");
    load(dir_with_outputs+"\"+current_tetrode+" output.mat","output");
    load(dir_with_outputs+"\"+current_tetrode+" aligned.mat","aligned");
    load(dir_with_outputs+"\"+current_tetrode+" reg_timestamps_of_spikes","reg_timestamps_of_the_spikes");
    idx = extract_clusters_from_output(output(:,1),output,spikesort_config);
catch
    disp("import_data.mat failed to import from")
    disp("1.)" +dir_with_grades) 
    disp("or")
    disp("2.)" +dir_with_outputs)
    disp("Please check they filepaths are correct")
    grades = NaN;
    output = NaN;
    aligned = NaN;
    reg_timestamps_of_the_spikes = NaN;
    idx = NaN;
end

end