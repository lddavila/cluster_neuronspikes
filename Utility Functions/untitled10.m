function [] = plot_clusters_of_tetrodes_across_z_scores(grades,overlap_percentages,number_of_rows,number_of_cols,names_of_grades,z_scores,channels_in_current_tetrodes)

%%make a plot of tetrode of various 
figure()
plot_counter =1;
for first_dimension =1:length(channels_in_current_tetrodes)
    for second_dimension=first_dimension+1:length(channels_in_current_tetrodes)
        subplot(number_of_rows,number_of_cols,plot_counter);
        new_plot_proj_ver_5(cluster_filters,aligned,first_dimension,second_dimension,channels,current_tetrode,z_score,the_number,category_of_cluster);
        plot_counter = plot_counter+1;
    end
end

%%Plot the heat map of grades
end