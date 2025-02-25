function [] = create_a_histogram_for_single_grade_behavior(cont_table,conditions,grade_to_check,branch_level)
close all;
fig1 = openfig("E:\HPC Data\Histograms of grades\Grade "+string(grade_to_check));
set(fig1,'Position',[0 0 1000 2000])
create_histograms_of_grades_by_incrementing_overlap(50,grade_to_check,["Behavior of grade "+grade_to_check+" When branch"+string(branch_level)+" is reached"],cont_table(conditions,:),false,"E:\HPC Data",false);
fig2 = gcf;
set(fig2,'Position',[1000 0 1000 2000]);
end