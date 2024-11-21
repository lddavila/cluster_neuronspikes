function [] = plot_the_clusters_ver_3(names_of_clusters,channels_of_curr_tetr,idx,before_or_after,grades,aligned,relevant_grades,relevant_grade_names,cluster_categories)
%plot all the configurations of the clusters
figure;
panel_counter = 1;
for first_dimension = 1:length(channels_of_curr_tetr)
    for second_dimension = first_dimension+1:length(channels_of_curr_tetr)
        subplot(2,3,panel_counter);
        new_plot_proj_ver_5(idx,aligned,first_dimension,second_dimension,channels_of_curr_tetr,"","",panel_counter,cluster_categories);
        panel_counter = panel_counter+1;
    end
end
sgtitle(before_or_after +" Filtering")

%plot a heat map of the relevant grades

% [overlap_percentage,which_cluster] = find_each_clusters_max_overlap(names_of_clusters,idx,reg_timestamps,ground_truth,timestamps);
%disp(which_cluster);
relevant_grades_of_current_tetrode = grades(names_of_clusters,relevant_grades);
x_values = relevant_grade_names;
y_values = strcat("c",string(names_of_clusters));
if contains(before_or_after,"before","IgnoreCase",true)
    if ~isempty(y_values)
        figure;
        heatmap(x_values,y_values,relevant_grades_of_current_tetrode,'ColorbarVisible','off','CellLabelFormat','%0.2f');
        title(before_or_after + " Filtering")
    end
end

%plot the average waveform per cluster
if contains(before_or_after,"Before","IgnoreCase",true)
    plot_mean_waveform_per_cluster(aligned,idx,names_of_clusters,before_or_after)
end
end