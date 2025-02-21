function [] = plot_mean_waveform_per_cluster(aligned,clusters,names_of_clusters,before_or_after)
figure;
colors_to_use = distinguishable_colors(length(clusters)*3);
for i=1:length(clusters)
    subplot(1,length(clusters),i);
    cluster_filter = clusters{i};
    if isempty(cluster_filter)
        continue;
    end
    spikes_in_cluster = aligned(:, cluster_filter, :);

    spikes_in_2d_format = reshape(spikes_in_cluster,[],size(aligned,3));

    mean_of_spikes_in_cluster = mean(spikes_in_2d_format,1);
    std_of_spikes_in_cluster = std(spikes_in_2d_format,1);

    bottom_of_range = mean_of_spikes_in_cluster + std_of_spikes_in_cluster ;
    top_of_range = mean_of_spikes_in_cluster - std_of_spikes_in_cluster ;
    in_between = [bottom_of_range,fliplr(top_of_range)];
    x =1:size(spikes_in_cluster,3);
    x2 = [x,fliplr(x)];
    fill(x2,in_between,colors_to_use(i+length(clusters),:))
    title("Cluster "+string(i));
end
sgtitle(before_or_after + " Filtering");
end