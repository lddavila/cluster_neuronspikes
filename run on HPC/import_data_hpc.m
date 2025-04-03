function [grades,output,aligned,reg_timestamps_of_the_spikes,idx,failed_to_load] = import_data_hpc(dir_with_grades,dir_with_outputs,current_tetrode,refinement_pass)
failed_to_load=false;
try

    load(fullfile(dir_with_outputs,current_tetrode+" output.mat"),"output");
    load(fullfile(dir_with_outputs,current_tetrode+" aligned.mat"),"aligned");
    % if ~refinement_pass
    % disp("reached the if condition")
    % grades = load(fullfile(dir_with_grades,current_tetrode+" Grades.mat"),"grades");
    % grades = grades.grades;
    % disp("finished if condition")
    % else
    % disp("entered else condition")
    %this is an unforunate, but necessary step to restore grades to their correct format
    %the cell array grades_to_be_parsed has 1 row for each cluster and a col for each grade per cluster
    grades_as_struct = importdata(fullfile(dir_with_grades,current_tetrode+" Grades.mat"),"grade_struct");
    all_fields = fieldnames(grades_as_struct);
    num_grades_aka_cols = size(all_fields,1);
    num_clusters_aka_rows = size(grades_as_struct.Grade_1,1);
    grades = cell(num_clusters_aka_rows,num_grades_aka_cols);

    for k=1:size(grades,1)
        for p=1:size(grades,2)
            grades{k,p} = grades_as_struct.(all_fields{p}){k};
        end
    end
    % grades = cell(size(grades_as_struct,1),size(grades_as_struct,2));


    % disp("finished else condition")
    % aligned = NaN;
    % end
    load(fullfile(dir_with_outputs,current_tetrode+" reg_timestamps_of_spikes.mat"),"reg_timestamps_of_the_spikes");
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