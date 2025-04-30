function [] = get_grades_for_nth_pass_of_clustering(dir_with_timestamps_and_rvals,dir_with_results,list_of_tetrodes,dir_to_save_grades_to,config,min_z_score,debug,relevant_grades,name_of_relevant_grades)
%run_grading_script_on_blind_pass
dir_to_begin_and_end_the_func_in = cd(dir_to_save_grades_to);
number_of_tetrodes = length(list_of_tetrodes);
draw_elipse_templates;
for i=1:length(list_of_tetrodes)
    % disp("Made it into the for loop")
    current_tetrode = list_of_tetrodes(i);
    tetrode_number = split(current_tetrode,"t");
    tetrode_number = str2double(tetrode_number(2));
    array_of_tetrodes = build_artificial_tetrode();
    channels_of_curr_tetr = array_of_tetrodes(tetrode_number,:);
    % try
        ts_r_tvals_cc_struct = load(fullfile(dir_with_timestamps_and_rvals,current_tetrode+".mat"),"timestamps","r_tvals","cleaned_clusters");
        timestamps = ts_r_tvals_cc_struct.timestamps;
        r_tvals = ts_r_tvals_cc_struct.r_tvals;
        cleaned_clusters = ts_r_tvals_cc_struct.cleaned_clusters;

        aligned_struct = load(fullfile(dir_with_results,current_tetrode+" aligned.mat"),"aligned");
        aligned = aligned_struct.aligned;
        output_struct = load(fullfile(dir_with_results,current_tetrode+" output.mat"),"output");
        output = output_struct.output;
        %compute_gradings_ver_4(aligned, timestamps, tvals, clusters, config,debug)
        if config.ON_HPC
            dir_of_template_shape_pngs = config.TEMPLATE_CLUSTER_FP_ON_HPC;
        else
            dir_of_template_shape_pngs = config.TEMPLATE_CLUSTER_FP;
        end
        grades = compute_gradings_ver_4(aligned, timestamps, r_tvals, cleaned_clusters, config.spikesort,debug,channels_of_curr_tetr,dir_of_template_shape_pngs,config);
        
        grade_struct = struct();
        for j=1:size(grades,2)
            grade_struct.("Grade_"+string(j)) = grades(:,j);
        end
     


 
        save(current_tetrode+" Grades.mat",'-fromstruct',grade_struct);

    % catch ME
    %     disp(ME.identifier)
    %     disp(ME.message)
    %     % disp("Failed To load trying the following")
    %     % disp(fullfile(dir_with_timestamps_and_rvals,current_tetrode+".mat"))
    %     % disp(fullfile(dir_with_results,current_tetrode+" aligned.mat"))
    %     % disp(fullfile(dir_with_results,current_tetrode+" output.mat"))
    % 
    %     continue;
    % end
    disp(string(min_z_score)+" Finished "+string(i)+"/"+string(number_of_tetrodes));

end
cd(dir_to_begin_and_end_the_func_in);
end
