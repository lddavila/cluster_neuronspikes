function [] = run_grading_script_on_blind_pass(dir_with_data,parent_dir_to_save_grades_to,name_of_recording)
home_dir =cd("..");
addpath(genpath(pwd));
cd(home_dir);

% compute the grades for the blind pass
config = spikesort_config; %load the config file;
config = config.spikesort;
debug = 0;
varying_z_scores = [3,4,5,6,7,8,9];
home_dir = cd(parent_dir_to_save_grades_to);
dir_all_new_grades_will_be_saved_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(name_of_recording);
cd(dir_all_new_grades_will_be_saved_to);
for i=1:length(varying_z_scores)
    dir_with_output = fullfile(dir_with_data,"initial_pass_results min z_score"+string(varying_z_scores(i)));
    dir_to_save_grades_to = "initial_pass min z_score "+string(varying_z_scores(i))+" grades";
    dir_to_save_grades_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_grades_to);
    list_of_tetrodes = strcat("t",string(1:285));
    dir_with_timestamps_and_rvals =  fullfile(dir_with_data,"initial_pass min z_score"+string(varying_z_scores(i)));
    name_of_grades = ["Tight","% Short ISI","Inc", "Temp Mat","Min Bhat","Skewness","TM Updated","Sym of Hist","Amp Category"];
    relevant_grades = [2,3,4,8,9,28,29,30,31];
    get_grades_for_nth_pass_of_clustering(dir_with_timestamps_and_rvals,dir_with_output,list_of_tetrodes,dir_to_save_grades_to,config,varying_z_scores(i),debug,relevant_grades,name_of_grades)
end
cd(home_dir);
disp("Finished")
end