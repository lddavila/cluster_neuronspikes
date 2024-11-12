function [] = compare_different_cut_thresholds(dir_of_nth_pass_recording,list_of_z_scores_to_check,list_of_tetrodes,relevant_grades,name_of_relevant_grades)
art_tetr_array = build_artificial_tetrode;
for i=1:length(list_of_tetrodes)
    current_tetrode = list_of_tetrodes(i);
    tetrode_and_number = split(current_tetrode,"t");
    tetrode_number = str2double(tetrode_and_number(2));
    channels_in_current_tetrode = art_tetr_array(tetrode_number,:);
    array_of_grades = cell(1,length(list_of_z_scores_to_check));
    array_of_aligned = cell(1,length(list_of_z_scores_to_check));
    array_of_timestamps = cell(1,length(list_of_z_scores_to_check));
    array_of_output = cell(1,length(list_of_z_scores_to_check));
    for z_score_counter=1:length(list_of_z_scores_to_check)
        current_z_score = list_of_z_scores_to_check(z_score_counter);
        dir_with_results= dir_of_nth_pass_recording+"\initial_pass_results min z_score"+string(current_z_score)+"\";
        dir_with_grades = dir_of_nth_pass_recording+"\initial_pass min z_score "+string(current_z_score)+" grades\";
        load(dir_with_results+current_tetrode+" aligned.mat");
        load(dir_with_results+current_tetrode+" reg_timestamps.mat");
        load(dir_with_results+current_tetrode+" output.mat");
        load(dir_with_grades+current_tetrode+" Grades.mat");
        array_of_grades{z_score_counter} = grades;
        array_of_aligned{z_score_counter} = aligned;
        array_of_timestamps{z_score_counter} = reg_timestamps;
        array_of_output{z_score_counter} = output;
    end

    array_of_pannels =[1,4,7;2,5,8;3,6,9];
    array_of_heatmap_panels = [10,13;11, 14;12 15];

    for first_dimension = 1:length(channels_in_current_tetrode)
        figure('units','normalized','outerposition',[0 0 1 1])
        for second_dimension = first_dimension+1:length(channels_in_current_tetrode)
            for z_score_counter=1:length(list_of_z_scores_to_check)
                output = array_of_output{z_score_counter};
                aligned = array_of_aligned{z_score_counter};
                idx = extract_clusters_from_output(output(:,1),output,spikesort_config);
                grades = array_of_grades{z_score_counter};
                current_z_score = list_of_z_scores_to_check(z_score_counter);
                subplot(5,length(list_of_z_scores_to_check),array_of_pannels(z_score_counter,:));
                new_plot_proj_ver_4(idx,aligned,first_dimension,second_dimension,channels_in_current_tetrode,current_tetrode,current_z_score);
                subplot(5,length(list_of_z_scores_to_check),array_of_heatmap_panels(z_score_counter,:));
                relevant_grades_of_current_tetrode = grades(:,relevant_grades);
                x_values = name_of_relevant_grades;
                y_values = strcat("c",string(1:size(grades,1)));
                heatmap(x_values,y_values,relevant_grades_of_current_tetrode,'ColorbarVisible','off','CellLabelFormat','%0.2f');
            
            end
            sgtitle(current_tetrode);
            %close all;
        end

    end
    close all;
end
end