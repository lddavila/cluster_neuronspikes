function [] = get_grades_for_nth_pass_of_clustering(dir_with_timestamps_and_rvals,dir_with_results,list_of_tetrodes,dir_to_save_grades_to,config,min_z_score,debug,relevant_grades,name_of_relevant_grades)

dir_to_begin_and_end_the_func_in = cd(dir_to_save_grades_to);
number_of_tetrodes = length(list_of_tetrodes);
parfor i=1:length(list_of_tetrodes)
    % disp("Made it into the for loop")
    current_tetrode = list_of_tetrodes(i);
    tetrode_number = split(current_tetrode,"t");
    tetrode_number = str2double(tetrode_number(2));
    array_of_tetrodes = build_artificial_tetrode();
    channels_of_curr_tetr = array_of_tetrodes(tetrode_number,:);
    try
        ts_r_tvals_cc_struct = load(fullfile(dir_with_timestamps_and_rvals,current_tetrode+".mat"),"timestamps","r_tvals","cleaned_clusters");
        timestamps = ts_r_tvals_cc_struct.timestamps;
        r_tvals = ts_r_tvals_cc_struct.r_tvals;
        cleaned_clusters = ts_r_tvals_cc_struct.cleaned_clusters;
        
        aligned_struct = load(fullfile(dir_with_results,current_tetrode+" aligned.mat"),"aligned");
        aligned = aligned_struct.aligned;
        output_struct = load(fullfile(dir_with_results,current_tetrode+" output.mat"),"output");
        output = output_struct.output;
    catch
        disp("Failed To load trying the following")
        disp(fullfile(dir_with_timestamps_and_rvals,current_tetrode+".mat"))
        disp(fullfile(dir_with_results,current_tetrode+" aligned.mat"))
        disp(fullfile(dir_with_results,current_tetrode+" output.mat"))

        continue;
    end
    % load(dir_with_results+"\"+current_tetrode+" output.mat","output");
    % load(dir_with_results+"\"+current_tetrode+" reg_timestamps.mat","reg_timestamps");


    grades = compute_gradings_ver_2(aligned, timestamps, r_tvals, cleaned_clusters, config,debug,relevant_grades,output,name_of_relevant_grades,channels_of_curr_tetr);
    grades = struct("grades",grades);

    % disp(pwd)
    save(current_tetrode+" Grades.mat","-fromstruct",grades);
    % disp(pwd)
    
    
    disp(string(min_z_score)+" Finished "+string(number_of_tetrodes));
    
end
cd(dir_to_begin_and_end_the_func_in);
end
