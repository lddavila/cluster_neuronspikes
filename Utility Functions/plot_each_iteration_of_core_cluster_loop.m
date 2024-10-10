function [] = plot_each_iteration_of_core_cluster_loop(iteration_counter,clusters,spike_aligned)
peaks = get_peaks(spike_aligned,true);
colors = distinguishable_colors(length(clusters)+10);
for first_dimension = 1:size(spike_aligned,1)
    for second_dimension=first_dimension+1:size(spike_aligned,1)
        figure;
        legend_string = cell{1,length(clusters)};
        all_clustered_indexes = 
        for current_cluster = 1:length(clusters)
            scatter(peaks(:,first_dimension),peaks(:,second_dimension));
        end
        xlabel("Peaks From Wire "+ string(first_dimension));
        ylabel("Peaks From Wire "+ string(second_dimension));
    end
end
end
