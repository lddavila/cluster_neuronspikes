function [updated_table_of_overlap] = update_grades_in_overlap_table(old_table_of_overlap,config)
updated_table_of_overlap = old_table_of_overlap;
unique_z_score_and_tetr_groups =  unique(old_table_of_overlap(:,["Tetrode", "Z Score"]));
for i=1:size(unique_z_score_and_tetr_groups,1)
    current_tetrode = unique_z_score_and_tetr_groups{i,"Tetrode"};
    current_z_score = unique_z_score_and_tetr_groups{i,"Z Score"};
    try
    grades = load(fullfile(config.GENERIC_GRADES_DIR+" "+string(current_z_score)+" grades",current_tetrode+" Grades.mat"),"grades");
    grades = grades.grades;
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