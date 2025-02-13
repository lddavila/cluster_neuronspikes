function [] = plot_the_clusters_hpc(names_of_clusters,channels_of_curr_tetr,idx,before_or_after,grades,aligned,relevant_grades,relevant_grade_names,cluster_categories,dir_to_save_figs_to,name_of_tetrode)
%plot all the configurations of the clusters
figure('units','normalized','outerposition',[0 0 1 1]);
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
relevant_grades_of_current_tetrode = grades(names_of_clusters,relevant_grades);

x_values = relevant_grade_names;
y_values = strcat("c",string(names_of_clusters));

home_dir = cd(dir_to_save_cluster_plots_to);
saveas(gcf,name_of_tetrode+".fig");
cd(home_dir);
close all;


end