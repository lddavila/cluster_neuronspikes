function [updated_table_of_overlap] = update_grades_in_overlap_table(old_table_of_overlap,config)
updated_table_of_overlap = old_table_of_overlap;
unique_z_score_and_tetr_groups =  unique(old_table_of_overlap(:,["Tetrode", "Z Score"]));
for i=1:size(unique_z_score_and_tetr_groups,1)
    current_tetrode = unique_z_score_and_tetr_groups{i,"Tetrode"};
    current_z_score = unique_z_score_and_tetr_groups{i,"Z Score"};
    try
        dir_with_grades = fullfile(config.GENERIC_GRADES_DIR+" "+string(current_z_score)+" grades",current_tetrode+" Grades.mat");

        % disp("entered else condition")
        %this is an unforunate, but necessary step to restore grades to their correct format
        %the grades struct has 1 field per grade and each of these fields is a cell array
        %the running size(grade_struct.Grade_n) will yeld a px1 answer
        %where p corresponds to the number of clusters represented by this grades array
        %grade_struct.Grade_1{1} returns the value set for grade_1 for cluster 1 
        %below we will unpack the struct into a nested cell array for easier formatting 
        grades_as_struct = importdata(dir_with_grades,"grade_struct");
        all_fields = fieldnames(grades_as_struct);
        num_grades_aka_cols = size(all_fields,1);
        num_clusters_aka_rows = size(grades_as_struct.Grade_1,1);
        grades = cell(num_clusters_aka_rows,num_grades_aka_cols);

        for k=1:size(grades,1)
            for p=1:size(grades,2)
                grades{k,p} = grades_as_struct.(all_fields{p}){k};
            end
        end

        for j=1:size(grades,1)
            c1 = updated_table_of_overlap{:,"Z Score"} == current_z_score;
            c2 = updated_table_of_overlap{:,"Tetrode"} == current_tetrode;
            c3 = updated_table_of_overlap{:,"Cluster"} == j;

            index_of_grades_to_replace = c1 & c2 & c3;

            updated_table_of_overlap{index_of_grades_to_replace,"grades"} = {grades(j,:)};
        end
    catch
        disp("Failed to update: Z Score:"+string(current_z_score)+" " +current_tetrode)
    end
    disp("update_grades_in_overlap_table.m "+string(i)+"/"+size(unique_z_score_and_tetr_groups,1));
end
end