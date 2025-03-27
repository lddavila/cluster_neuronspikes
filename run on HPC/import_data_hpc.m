function [grades,output,aligned,reg_timestamps_of_the_spikes,idx,failed_to_load] = import_data_hpc(dir_with_grades,dir_with_outputs,current_tetrode,refinement_pass)
failed_to_load=false;
try
    
    load(fullfile(dir_with_outputs,current_tetrode+" output.mat"),"output");
    load(fullfile(dir_with_outputs,current_tetrode+" aligned.mat"),"aligned");
    if ~refinement_pass
        grades = load(fullfile(dir_with_grades,current_tetrode+" Grades.mat"),"grades");
        grades = grades.grades;
        
    else
        %this is an unforunate, but necessary step to restore grades to their correct format
        %the cell array grades_to_be_parsed has 1 row for each cluster and a col for each grade per cluster
        grades = load(fullfile(dir_with_grades,current_tetrode+" Grades.mat"),"grades");
        grades_to_be_parsed = cell(size(grades,1),size(grades,2));
        for i=1:size(grades,1)
            for j=1:size(grades,2)
                grades_to_be_parsed{i,j} = grades(i,j).grades;
            end
        end
        grades = grades_to_be_parsed;
        % aligned = NaN;
    end
    load(fullfile(dir_with_outputs,current_tetrode+" reg_timestamps_of_spikes"),"reg_timestamps_of_the_spikes");
    idx = extract_clusters_from_output(output(:,1),output);
catch ME
    failed_to_load=true;
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