function [grades,output,aligned,reg_timestamps_of_the_spikes,idx,failed_to_load] = import_data_hpc(dir_with_grades,dir_with_outputs,current_tetrode,refinement_pass)
failed_to_load=false;
try
    
    load(fullfile(dir_with_outputs,current_tetrode+" output.mat"),"output");
    load(fullfile(dir_with_outputs,current_tetrode+" aligned.mat"),"aligned");
    if ~refinement_pass
        disp("reached the if condition")
        grades = load(fullfile(dir_with_grades,current_tetrode+" Grades.mat"),"grades");
        grades = grades.grades;
        disp("finished if condition")
    else
        disp("entered else condition")
        %this is an unforunate, but necessary step to restore grades to their correct format
        %the cell array grades_to_be_parsed has 1 row for each cluster and a col for each grade per cluster
        grades_2 = importdata(fullfile(dir_with_grades,current_tetrode+" Grades.mat"),"grades");
        grades = cell(size(grades_2,1),size(grades_2,2));
        for i=1:size(grades_2,1)
            for j=1:size(grade_2,2)
                grades{i,j} = grades_2(i,j).grades;
            end
        end
        
        disp("finished else condition")
        % aligned = NaN;
    end
    load(fullfile(dir_with_outputs,current_tetrode+" reg_timestamps_of_the_spikes.mat"),"reg_timestamps_of_the_spikes");
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