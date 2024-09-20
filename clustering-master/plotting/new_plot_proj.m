function new_plot_proj(cluster_filters, aligned, x_axis, y_axis)
    data = get_peaks(aligned, true)';
    
    color_mat = load('colors.mat');
    colors = color_mat.colors;
    my_gray = [0.4 0.4 0.4];
    myplot = @(x, y, c, m, s) plot(x, y, 'Color', c, 'LineStyle', 'none', 'Marker', m, 'MarkerSize', s);
    
    figure
    set(gcf, 'Visible', 'off')
%     set(gca, 'Color', 'k')
    hold on
    myplot(data(:, x_axis), data(:, y_axis), my_gray, '.', 1)
    for c = 1:length(cluster_filters)
        cluster = data(cluster_filters{c}, :);
        cluster_x = cluster(:, x_axis);
        cluster_y = cluster(:, y_axis);
        myplot(cluster_x, cluster_y, colors{c}, '+', 2)
    end
%     xlabel(sprintf('Peak %d', x_axis))
%     ylabel(sprintf('Peak %d', y_axis))
    hold off
%     set(gca, 'TickDir', 'out')
    set(gca, 'box', 'off')
    set(gca, 'xticklabel', [])
    set(gca, 'yticklabel', [])
    set(gcf, 'Visible', 'on')
    set(gcf, 'InvertHardCopy', 'off')
end