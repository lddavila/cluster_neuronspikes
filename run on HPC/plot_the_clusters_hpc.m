function [] = plot_the_clusters_hpc(channels_of_curr_tetr,idx,before_or_after,aligned,cluster_categories,name_of_tetrode)
%plot all the configurations of the clusters
figure('units','normalized','outerposition',[0 0 1 1]);
panel_counter = 1;
for first_dimension = 1:length(channels_of_curr_tetr)
    for second_dimension = first_dimension+1:length(channels_of_curr_tetr)
        subplot(2,3,panel_counter);
        new_plot_proj_ver_5(idx,aligned,first_dimension,second_dimension,channels_of_curr_tetr,"","",panel_counter,cluster_categories);
        panel_counter = panel_counter+1;
    end
end
sgtitle(name_of_tetrode+" "+before_or_after +" Filtering")
saveas(gcf,name_of_tetrode+".fig");

close all;


end