function [grades,output,aligned,reg_timestamps,idx] = import_data(dir_with_grades,dir_with_outputs,current_tetrode)
try
    load(dir_with_grades+"\"+current_tetrode+" Grades.mat","grades");
    load(dir_with_outputs+"\"+current_tetrode+" output.mat","output");
    load(dir_with_outputs+"\"+current_tetrode+" aligned.mat","aligned");
    load(dir_with_outputs+"\"+current_tetrode+" reg_timestamps","reg_timestamps");
    idx = extract_clusters_from_output(output(:,1),output,spikesort_config);
catch
    grades = NaN;
    output = NaN;
    aligned = NaN;
    reg_timestamps = NaN;
    idx = NaN;
end
end