function [] = plot_the_clusters_hpc(channels_of_curr_tetr,idx,before_or_after,aligned,cluster_categories,name_of_tetrode,current_z_score,current_clust,grades_to_check,names_of_grades,current_grades)
%plot all the configurations of the clusters
figure('units','normalized','outerposition',[0 0 1 1]);
panel_counter = 1;
rep_dimensions = current_grades(:,42:43);

for first_dimension = 1:length(channels_of_curr_tetr)
    for second_dimension = first_dimension+1:length(channels_of_curr_tetr)
        subplot(2,3,panel_counter);
        new_plot_proj_ver_5(idx,aligned,first_dimension,second_dimension,channels_of_curr_tetr,"","",panel_counter,cluster_categories,rep_dimensions);
        panel_counter = panel_counter+1;
    end
end
sgtitle(name_of_tetrode+" Z Score:" + string(current_z_score) + " Best Cluster "+string(current_clust))
saveas(gcf,name_of_tetrode+" Z Score "+string(current_z_score)+" Cluster Plots.fig");
close all;

figure('units','normalized','outerposition',[0 0 1 1]);
y_labels = strcat("Cluster",string(1:size(current_grades,1)));
x_labels = names_of_grades;
heatmap(x_labels,y_labels,current_grades(:,grades_to_check));
sgtitle(name_of_tetrode+" Z Score:" + string(current_z_score) + " Best Cluster"+string(current_clust))
saveas(gcf,name_of_tetrode+" Z Score " + string(current_z_score) + " Heatmap.fig");
close all;

end