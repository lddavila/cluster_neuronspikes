function [] = plot_clusters_of_tetrodes_across_z_scores(grades,overlap_percentages,number_of_rows,number_of_cols,names_of_grades,z_scores,current_tetrode,aligned_spike_cluster_data,idx_cluster_data,cluster_names_of_primary_cluster)

%%make a plot of tetrode of various 
figure()
plot_counter =1;
for row=1:number_of_rows
    for first_dimension =1:4
        for second_dimension=first_dimension+1:4
            subplot(number_of_rows,number_of_cols,plot_counter);
            new_plot_proj_ver_6(idx_cluster_data{row},aligned_spike_cluster_data{row},first_dimension,second_dimension,z_scores(row),plot_counter,overlap_percentages(row),cluster_names_of_primary_cluster(row));
            plot_counter = plot_counter+1;
        end
    end
end
sgtitle(current_tetrode)

% %%Plot the heat map of grades
% figure;
% heatmap(names_of_grades,z_scores,grades,'ColorbarVisible','off','CellLabelFormat','%0.2f');
% title(name_of_tetrode+" "+ before_or_after + " Filtering")
end