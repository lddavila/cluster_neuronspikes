function [] = grade_ideal_dims_pass_on_hpc()
home_dir =cd("..");
addpath(genpath(pwd));
cd(home_dir);
config = choose_best_config();
list_of_refinement_passes = config.DIR_TO_SAVE_RECLUSTERING_TO_ON_HPC;
list_of_dimensions_tried = config.NUM_DIMS_TO_USE_FOR_RECLUSTERING_ON_HPC;
config_og = spikesort_config; %load the config file;
config_og = config_og.spikesort;
for i=1:length(list_of_refinement_passes)
    current_gen_dir = list_of_refinement_passes(i);
    dir_with_output = fullfile(current_gen_dir,"ideal_dims_pass_results Top "+string(list_of_dimensions_tried(i)) + " Channels");
    dir_with_timestamps_and_rvals = fullfile(current_gen_dir,"ideal_dims_pass Top "+string(list_of_dimensions_tried(i)) + " Channels");
    list_of_tetrodes_unformatted =strtrim(string(ls(fullfile(dir_with_output,"t*output*.mat"))));
    list_of_tetrodes_formatted = split(list_of_tetrodes_unformatted," ");
    list_of_tetrodes = list_of_tetrodes_formatted(:,1);

    dir_to_save_grades_to = fullfile(current_gen_dir,"ideal_dims_pass Top "+string(list_of_dimensions_tried(i)) + " Channels Grades");
    num_tetrodes = length(list_of_tetrodes);
    disp("++++++++++++++++++++++")
    disp(dir_with_timestamps_and_rvals);
    disp(dir_with_output)
    disp(list_of_tetrodes_unformatted)
    disp("++++++++++++++++++++++++++++++++++++++++")
    for j=1:length(list_of_tetrodes)
        current_tetrode = list_of_tetrodes(j);
        current_z_score_unformatted = strtrim(string(ls(fullfile(dir_with_output,current_tetrode+"*.txt"))));
        if length(current_z_score_unformatted) ~=1
            disp(current_z_score_unformatted);
            disp("Returned too many/few z score files, aborting, Should always return exactly 1");
        else
            current_z_score_formatted = split(current_z_score_unformatted,"_");
            current_z_score = str2double(current_z_score_formatted(end));



            % fullfile(initial_tetrode_results_dir,"t"+string(refined_tetrode_idx)+"_z_score_"+z_score_to_use_for_reclustering+".txt")

            name_of_grades = ["Tight","% Short ISI","Inc", "Temp Mat","Min Bhat","Skewness","TM Updated","Sym of Hist","Amp Category"];
            relevant_grades = [2,3,4,8,9,28,29,30,31];
            get_grades_for_ideal_dims_pass(dir_with_timestamps_and_rvals,dir_with_output,current_tetrode,dir_to_save_grades_to,config_og,current_z_score,0,relevant_grades,name_of_grades)
        end
        disp("grade_ideal_dims_pass_on_hpc.m Iteration"+string(i)+": "+string(j)+"/"+string(num_tetrodes)+" Finished")
    end

end
end