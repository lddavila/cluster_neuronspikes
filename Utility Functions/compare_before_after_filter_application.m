function [] = compare_before_after_filter_application(dir_with_grades,dir_with_outputs,relevant_grades,names_of_relevant_grades,spikesort_config,the_range,ground_truth,timestamps)
art_tetr_array = build_artificial_tetrode();
list_of_tetrodes = strcat("t",string(1:285));
number_of_filters_to_apply = length(relevant_grades)+1;
number_of_panels = 7;
for i=1:length(list_of_tetrodes)
    current_tetrode = list_of_tetrodes(i);
    channels_of_curr_tetr = art_tetr_array(i,:);
    load(dir_with_grades+"\"+current_tetrode+" Grades.mat","grades");
    load(dir_with_outputs+"\"+current_tetrode+" output.mat","output");
    load(dir_with_outputs+"\"+current_tetrode+" aligned.mat","aligned");
    load(dir_with_outputs+"\"+current_tetrode+" reg_timestamps","reg_timestamps");
    %will only really work for tetrodes of 4 channels
    figure('units','normalized','outerposition',[0 0 1 1])
    plot_counter = 1;
    idx = extract_clusters_from_output(output(:,1),output,spikesort_config);
    %plot the data without filters
    for first_dimension = 1:length(channels_of_curr_tetr)
        for second_dimension = first_dimension+1:length(channels_of_curr_tetr)
            subplot(number_of_filters_to_apply,number_of_panels,plot_counter);
            new_plot_proj_ver_4(idx,aligned,first_dimension,second_dimension,channels_of_curr_tetr,"","");
            plot_counter = plot_counter+1;
        end
    end

    names_of_clusters = 1:length(idx);
    [overlap_percentage,which_cluster] = find_each_clusters_max_overlap(names_of_clusters,idx,reg_timestamps,ground_truth,timestamps);
    disp(which_cluster);

    plot_counter = plot_counter+1;
    subplot(number_of_filters_to_apply,number_of_panels,7)
    relevant_grades_of_current_tetrode = [grades(:,relevant_grades),overlap_percentage];
    x_values = names_of_relevant_grades;
    y_values = strcat("c",string(1:size(grades,1)));
    heatmap(x_values,y_values,relevant_grades_of_current_tetrode,'ColorbarVisible','off','CellLabelFormat','%0.2f');

    filtered_idx = cell(1,length(idx));
    clusters_that_passed_the_filter = [];
    plot_counter = 8;
    for current_clust=1:length(filtered_idx)
        if grades(current_clust,relevant_grades) > the_range(1) && grades(current_clust,relevant_grades) <the_range(2)
            filtered_idx{current_clust} = idx{current_clust};
            clusters_that_passed_the_filter = [clusters_that_passed_the_filter,current_clust];
        end
    end

    %plot the data after applying filter
    for first_dimension = 1:length(channels_of_curr_tetr)
        for second_dimension = first_dimension+1:length(channels_of_curr_tetr)
            subplot(number_of_filters_to_apply,number_of_panels,plot_counter);
            new_plot_proj_ver_4(filtered_idx,aligned,first_dimension,second_dimension,channels_of_curr_tetr,current_tetrode,names_of_relevant_grades);
            plot_counter = plot_counter+1;
        end
    end
    plot_counter = plot_counter+1;
    subplot(number_of_filters_to_apply,number_of_panels,14)

    [overlap_percentage,which_cluster] = find_each_clusters_max_overlap(clusters_that_passed_the_filter,idx,reg_timestamps,ground_truth,timestamps);
    disp(which_cluster);
    relevant_grades_of_current_tetrode = [grades(clusters_that_passed_the_filter,relevant_grades),overlap_percentage];
    x_values = names_of_relevant_grades;
    y_values = strcat("c",string(clusters_that_passed_the_filter));
    heatmap(x_values,y_values,relevant_grades_of_current_tetrode,'ColorbarVisible','off','CellLabelFormat','%0.2f');

    sgtitle([current_tetrode, names_of_relevant_grades+"Range "+ string(the_range(1)) + string(the_range(2))])


    close all;

end
end