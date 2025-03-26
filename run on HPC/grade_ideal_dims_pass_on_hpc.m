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
    home_dir = cd(dir_with_output);
    struct_of_names = dir("t*output*.mat");
    table_of_names = struct2table(struct_of_names);
    names_of_files = string(table_of_names{:,"name"});
    

    dir_to_save_grades_to = fullfile(current_gen_dir,"ideal_dims_pass Top "+string(list_of_dimensions_tried(i)) + " Channels Grades");
    dir_to_save_grades_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_grades_to);
    num_tetrodes = length(size(names_of_files,1));
    % disp("++++++++++++++++++++++")
    % disp(dir_with_timestamps_and_rvals);
    % disp(dir_with_output)
    % disp(names_of_files)
    % disp("++++++++++++++++++++++++++++++++++++++++")
    parfor j=1:size(names_of_files,1)
        unformatted_tetrode_name = names_of_files(j);
        unformatted_split_tetrode_name = split(unformatted_tetrode_name," ");
        current_tetrode = unformatted_split_tetrode_name(1);
        current_z_score_unformatted = strtrim(string(ls(current_tetrode+"_*.txt")));
        if length(current_z_score_unformatted) ~=1
            disp(current_z_score_unformatted);
            disp("Returned too many/few z score files, aborting, Should always return exactly 1");
        else
            current_z_score_formatted = split(current_z_score_unformatted,"_");
            current_z_score = str2double(strrep(current_z_score_formatted(end),".txt",""));



            % fullfile(initial_tetrode_results_dir,"t"+string(refined_tetrode_idx)+"_z_score_"+z_score_to_use_for_reclustering+".txt")

            name_of_grades = ["Tight","% Short ISI","Inc", "Temp Mat","Min Bhat","Skewness","TM Updated","Sym of Hist","Amp Category"];
            relevant_grades = [2,3,4,8,9,28,29,30,31];
            get_grades_for_ideal_dims_pass(dir_with_timestamps_and_rvals,dir_with_output,current_tetrode,dir_to_save_grades_to,config_og,current_z_score,0,relevant_grades,name_of_grades)
        end
        disp("grade_ideal_dims_pass_on_hpc.m Iteration"+string(i)+": "+string(j)+"/"+string(num_tetrodes)+" Finished")
    end
    cd(home_dir);

end
end