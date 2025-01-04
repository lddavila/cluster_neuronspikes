function new_plot_proj_ver_6(cluster_filters, aligned, x_axis, y_axis,z_score,plot_counter,overlap_percentage,cluster_primary)

%figure;
data = get_peaks(aligned, true)';
colors = distinguishable_colors(length(cluster_filters)*3);
my_gray = [0.5 0.5 0.5];
myplot = @(x, y, c, m, s) plot(x, y, 'Color', c, 'LineStyle', 'none', 'Marker', m, 'MarkerSize', s,'MarkerFaceColor',c,'MarkerEdgeColor',c);

hold on
legend_string = ["Unclustered"];
myplot(data(:, x_axis), data(:, y_axis), my_gray, 'o', 2)
if size(cluster_filters,1) ==0
    return
end
for c = cluster_primary:cluster_primary+0.5
    peaks_in_cluster = cluster_filters{c};
    if isempty(peaks_in_cluster)
        continue;
    end
    peaks_in_cluster(peaks_in_cluster > size(aligned,2)) = [];
    cluster = data(peaks_in_cluster, :);
    cluster_x = cluster(:, x_axis);
    cluster_y = cluster(:, y_axis);



    cluster_mean_x = mean(cluster_x);
    cluster_mean_y = mean(cluster_y);



    cluster_std_x = std(cluster_x);
    cluster_std_y = std(cluster_y);

    cluster_2std_above_mean_x = cluster_mean_x + (3*cluster_std_x);
    cluster_2std_below_mean_x = cluster_mean_x - (3*cluster_std_x);
    cluster_3std_above_mean_x = cluster_mean_x + (4 * cluster_std_x);
    cluster_3std_below_mean_x = cluster_mean_x - (4 * cluster_std_x);

    cluster_2std_above_mean_y = cluster_mean_y + (3*cluster_std_y);
    cluster_2std_below_mean_y = cluster_mean_y - (3*cluster_std_y);
    cluster_3std_above_mean_y = cluster_mean_y + (4 * cluster_std_y);
    cluster_3std_below_mean_y = cluster_mean_y - (4 * cluster_std_y);



    % figure;
    % histogram(cluster_x)
    % hold on;
    % xline(cluster_mean_x);
    % xline(cluster_2std_above_mean_x);
    % xline(cluster_2std_below_mean_x);
    % xline(cluster_3std_below_mean_x);
    % xline(cluster_3std_above_mean_x);
    % title("X values of cluster")
    %
    %
    % figure;
    % histogram(cluster_y)
    % hold on;
    % xline(cluster_mean_y)
    % xline(cluster_2std_below_mean_y);
    % xline(cluster_2std_above_mean_y);
    % xline(cluster_3std_below_mean_y);
    % xline(cluster_3std_above_mean_y)
    % title("Y Values Of Cluster")






    myplot(cluster_x, cluster_y, colors(1,:), 'o', 2)


    if plot_counter==1
        legend_string =[legend_string, "c"+string(c) + " Primary"];
    else
        legend_string = [legend_string,"c"+string(c)+"Overlap Percentage:"+string(overlap_percentage)];
    end
end
pos_1 = [[cluster_mean_x-(3 * cluster_std_x), cluster_mean_y- (3 * cluster_std_y)], (cluster_2std_above_mean_x - cluster_2std_below_mean_x ),(cluster_2std_above_mean_y - cluster_2std_below_mean_y)];
rectangle('Position',pos_1,'Curvature',[1,1],'EdgeColor','y','LineWidth',2);

pos_2 =[[cluster_mean_x - (4 * cluster_std_x),cluster_mean_y - (4 * cluster_std_y)], (cluster_3std_above_mean_x - cluster_3std_below_mean_x ),(cluster_3std_above_mean_y - cluster_3std_below_mean_y)];
rectangle('Position',pos_2,'Curvature',[1,1],'EdgeColor','m','LineWidth',2);

xlabel(sprintf('Dim %d Peaks', x_axis))
ylabel(sprintf('Dim %d Peaks', y_axis))
title(string(z_score));
if mod(plot_counter-1,6)==0
    legend(legend_string,'Location','best');
    xlabel(sprintf('Dim %d Peaks Overlap Percentage:%s', x_axis,overlap_percentage) )
end
hold off
end