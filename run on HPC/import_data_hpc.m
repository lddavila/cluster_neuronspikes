function [grades,output,aligned,reg_timestamps_of_the_spikes,idx] = import_data_hpc(dir_with_grades,dir_with_outputs,current_tetrode,refinement_pass)
try
    grades = load(fullfile(dir_with_grades,current_tetrode+" Grades.mat"),"grades");
    grades = grades.grades;
    load(fullfile(dir_with_outputs,current_tetrode+" output.mat"),"output");
    if ~refinement_pass
        load(fullfile(dir_with_outputs,current_tetrode+" aligned.mat"),"aligned");
    else
        aligned = NaN;
    end
    load(fullfile(dir_with_outputs,current_tetrode+" reg_timestamps_of_spikes"),"reg_timestamps_of_the_spikes");
    idx = extract_clusters_from_output(output(:,1),output,spikesort_config);
catch ME
    disp(ME.identifier)
    disp(ME.message)
    disp(ME.cause)
    disp(ME.stack)
    grades = NaN;
    output = NaN;
    aligned = NaN;
    reg_timestamps_of_the_spikes = NaN;
    idx = NaN;
end

end