function [] = get_grades_for_nth_pass_of_clustering(dir_with_timestamps_and_rvals,dir_with_results,list_of_tetrodes,dir_to_save_grades_to,config,min_z_score)
for i=1:length(list_of_tetrodes)
    current_tetrode = list_of_tetrodes(i);
    try
        load(dir_with_timestamps_and_rvals+"\"+current_tetrode+".mat","timestamps","r_tvals","cleaned_clusters")
        load(dir_with_results+"\"+current_tetrode+" aligned.mat","aligned");
    catch
        continue;
    end
    % load(dir_with_results+"\"+current_tetrode+" output.mat","output");
    % load(dir_with_results+"\"+current_tetrode+" reg_timestamps.mat","reg_timestamps");


    grades = compute_gradings_ver_2(aligned, timestamps, r_tvals, cleaned_clusters, config);

    save(dir_to_save_grades_to+"\"+current_tetrode+" Grades.mat","grades");
    disp(string(min_z_score)+" Finished "+string(i)+"/"+string(length(list_of_tetrodes)))
end
end