function [normalized_grades] = normalize_grades(array_of_grades_to_be_normalized_by,grades_to_normalize,config)

grades_cols_to_flip = config.IDXS_OF_GRADES_THAT_ARE_BETTER_SMALLER;
grade_cols_to_check = config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST;


%normalize the grades
combined_grades = [grades_to_normalize;array_of_grades_to_be_normalized_by];
normalized_combined_grades = normalize(combined_grades,'range',[0,1]);

%flip the grades which are better smaller
for i=1:size(normalized_combined_grades,2)
    if ismember(i,grades_cols_to_flip)
        normalized_combined_grades(:,i) = 1 -normalized_combined_grades(:,i);
    end
end

normalized_grades = normalized_combined_grades(1:size(grades_to_normalize,1),:);

end