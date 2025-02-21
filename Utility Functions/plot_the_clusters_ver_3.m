function [] = plot_the_clusters_ver_3(names_of_clusters,channels_of_curr_tetr,idx,before_or_after,grades,aligned,relevant_grades,relevant_grade_names,cluster_categories,dir_to_save_figs_to,name_of_tetrode)
%plot all the configurations of the clusters
figure;
panel_counter = 1;
dir_to_save_cluster_plots_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to+"\Cluster Plots");
for first_dimension = 1:length(channels_of_curr_tetr)
    for second_dimension = first_dimension+1:length(channels_of_curr_tetr)
        subplot(2,3,panel_counter);
        new_plot_proj_ver_5(idx,aligned,first_dimension,second_dimension,channels_of_curr_tetr,"","",panel_counter,cluster_categories);
        panel_counter = panel_counter+1;
    end
end
sgtitle(name_of_tetrode+" "+before_or_after +" Filtering")
%saveas(gcf,dir_to_save_cluster_plots_to+"\"+name_of_tetrode+".fig")
%close all;

%plot a heat map of the relevant grades

% [overlap_percentage,which_cluster] = find_each_clusters_max_overlap(names_of_clusters,idx,reg_timestamps,ground_truth,timestamps);
%disp(which_cluster);
relevant_grades_of_current_tetrode = grades(names_of_clusters,relevant_grades);
dir_to_save_grade_plots_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to+"\Grade Plots");
x_values = relevant_grade_names;
y_values = strcat("c",string(names_of_clusters));

if ~isempty(y_values)
    figure;
    heatmap(x_values,y_values,relevant_grades_of_current_tetrode,'ColorbarVisible','off','CellLabelFormat','%0.2f');
    title(name_of_tetrode+" "+ before_or_after + " Filtering")
end
%saveas(gcf,dir_to_save_grade_plots_to+"\"+name_of_tetrode+".fig");
%close all;

% %plot the average waveform per cluster
% if contains(before_or_after,"Before","IgnoreCase",true)
%     plot_mean_waveform_per_cluster(aligned,idx,names_of_clusters,before_or_after)
% end
end