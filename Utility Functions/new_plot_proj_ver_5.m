function new_plot_proj_ver_5(cluster_filters, aligned, x_axis, y_axis,channels,current_tetrode,z_score,the_number,category_of_clusters)
channel_string = "";
for j=1:size(channels,2)
    channel_string = channel_string + " C"+string(channels(j));
end

data = get_peaks(aligned, true)';
colors = distinguishable_colors(length(cluster_filters)*3);
my_gray = [0.5 0.5 0.5];
myplot = @(x, y, c, m, s) plot(x, y, 'Color', c, 'LineStyle', 'none', 'Marker', m, 'MarkerSize', s,'MarkerFaceColor',c,'MarkerEdgeColor',c);

hold on
legend_string = ["Unclustered"];
myplot(data(:, x_axis), data(:, y_axis), my_gray, 'o', 2)
for c = 1:length(cluster_filters)
    peaks_in_cluster = cluster_filters{c};
    if isempty(peaks_in_cluster)
        continue;
    end
    peaks_in_cluster(peaks_in_cluster > size(aligned,2)) = [];
    cluster = data(peaks_in_cluster, :);
    cluster_x = cluster(:, x_axis);
    cluster_y = cluster(:, y_axis);
    if strcmpi(category_of_clusters(c),"No category")
        myplot(cluster_x, cluster_y, colors(2,:), 'o', 2)
    else
        myplot(cluster_x, cluster_y, colors(c+length(cluster_filters),:), 'o', 2)
    end

    legend_string =[legend_string, "c"+string(c) + " "+category_of_clusters(c)];
end
xlabel(sprintf('Channel %d Peaks', channels(x_axis)))
ylabel(sprintf('Channel %d Peaks', channels(y_axis)))
title(string(z_score));
if the_number==1
    legend(legend_string,'Location','best');
end
hold off
end