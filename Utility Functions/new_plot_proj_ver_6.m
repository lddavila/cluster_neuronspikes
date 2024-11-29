function new_plot_proj_ver_6(cluster_filters, aligned, x_axis, y_axis,z_score,plot_counter,overlap_percentage,cluster_primary)

data = get_peaks(aligned, true)';
colors = distinguishable_colors(length(cluster_filters)*3);
my_gray = [0.5 0.5 0.5];
myplot = @(x, y, c, m, s) plot(x, y, 'Color', c, 'LineStyle', 'none', 'Marker', m, 'MarkerSize', s,'MarkerFaceColor',c,'MarkerEdgeColor',c);

hold on
legend_string = ["Unclustered"];
myplot(data(:, x_axis), data(:, y_axis), my_gray, 'o', 2)
for c = cluster_primary:cluster_primary+0.5
    peaks_in_cluster = cluster_filters{c};
    if isempty(peaks_in_cluster)
        continue;
    end
    peaks_in_cluster(peaks_in_cluster > size(aligned,2)) = [];
    cluster = data(peaks_in_cluster, :);
    cluster_x = cluster(:, x_axis);
    cluster_y = cluster(:, y_axis);

    myplot(cluster_x, cluster_y, colors(c,:), 'o', 2)


    if plot_counter==1
        legend_string =[legend_string, "c"+string(c) + " Primary"];
    else
        legend_string = [legend_string,"c"+string(c)+"Overlap Percentage:"+string(overlap_percentage)];
    end
end
xlabel(sprintf('Dim %d Peaks', x_axis))
ylabel(sprintf('Dim %d Peaks', y_axis))
title(string(z_score));
if mod(plot_counter-1,6)==0
    legend(legend_string,'Location','best');
    xlabel(sprintf('Dim %d Peaks Overlap Percentage:%s', x_axis,overlap_percentage) )
end
hold off
end