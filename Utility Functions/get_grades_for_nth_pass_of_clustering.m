function [] = get_grades_for_nth_pass_of_clustering(dir_with_timestamps_and_rvals,dir_with_results,list_of_tetrodes,dir_to_save_grades_to,config,min_z_score,debug,relevant_grades,name_of_relevant_grades)
array_of_tetrodes = build_artificial_tetrode();
for i=1:length(list_of_tetrodes)
    current_tetrode = list_of_tetrodes(i);
    tetrode_number = split(current_tetrode,"t");
    tetrode_number = str2double(tetrode_number(2));
    
    channels_of_curr_tetr = array_of_tetrodes(tetrode_number,:);
    try
        load(dir_with_timestamps_and_rvals+"\"+current_tetrode+".mat","timestamps","r_tvals","cleaned_clusters");
        load(dir_with_results+"\"+current_tetrode+" aligned.mat","aligned");
        load(dir_with_results+"\"+current_tetrode+" output.mat","output");
    catch
        continue;
    end
    % load(dir_with_results+"\"+current_tetrode+" output.mat","output");
    % load(dir_with_results+"\"+current_tetrode+" reg_timestamps.mat","reg_timestamps");


    grades = compute_gradings_ver_2(aligned, timestamps, r_tvals, cleaned_clusters, config,debug,relevant_grades,output,name_of_relevant_grades,channels_of_curr_tetr);

    save(dir_to_save_grades_to+"\"+current_tetrode+" Grades.mat","grades");
    disp(string(min_z_score)+" Finished "+string(i)+"/"+string(length(list_of_tetrodes)));
end
end