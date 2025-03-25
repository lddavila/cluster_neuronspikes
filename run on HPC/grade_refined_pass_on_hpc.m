function [] = grade_refined_pass_on_hpc()
home_dir =cd("..");
addpath(genpath(pwd));
cd(home_dir);
config = choose_best_config();
list_of_refinement_passes = config.DIR_TO_SAVE_RECLUSTERING_TO_ON_HPC;
list_of_dimensions_tried = config.NUM_DIMS_TO_USE_FOR_RECLUSTERING_ON_HPC;
for i=1:length(list_of_refinement_passes)
    current_gen_dir = list_of_refinement_passes(i);
    dir_with_results = fullfile(current_gen_dir,"ideal_dims_pass_results Top "+string(list_of_dimensions_tried(i)) + " Channels");
    list_of_tetrodes_unformatted =strtrim(string(ls(fullfile(dir_with_results,"t*output*.mat"))));
    list_of_tetrodes_formatted = split(list_of_tetrodes_unformatted," ");
    list_of_tetrodes = list_of_tetrodes_formatted(:,1);
    for j=1:length(list_of_tetrodes)
        current_tetrode = list_of_tetrodes(j);
        current_z_score_unformatted = strtrim(string(ls(fullfile(dir_with_results,current_tetrode+"*.txt"))));
        if length(current_z_score_unformatted) ~=1
            disp(current_z_score_unformatted);
            disp("Returned too many/few z score files, aborting");
            return;
        end
        current_z_score_formatted = split(current_z_score_unformatted,"_");
        current_z_score = str2double(current_z_score_formatted(end));

        fullfile(initial_tetrode_results_dir,"t"+string(refined_tetrode_idx)+"_z_score_"+z_score_to_use_for_reclustering+".txt")

        name_of_grades = ["Tight","% Short ISI","Inc", "Temp Mat","Min Bhat","Skewness","TM Updated","Sym of Hist","Amp Category"];
        relevant_grades = [2,3,4,8,9,28,29,30,31];
        get_grades_for_nth_pass_of_clustering(dir_with_timestamps_and_rvals,dir_with_output,list_of_tetrodes,dir_to_save_grades_to,config,varying_z_scores(i),debug,relevant_grades,name_of_grades)

    end

end
end