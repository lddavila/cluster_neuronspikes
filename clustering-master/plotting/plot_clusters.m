function plot_clusters(cluster_filters, raw, tvals, inputrange, gradings, together)
%PLOT_CLUSTERS Plots clusters in the peak feature projects
    individually = false;
    plot_all = true;
    if nargin == 4
        gradings = [];
        together = true;
    elseif nargin == 5
        together = false;
        individually = true;
        if strcmpi(gradings, 'all')
            plot_all = true;
        end
    end
    
    color_mat = load('colors.mat');
    colors = color_mat.colors;
    gray = [0.4 0.4 0.4];
    myplot = @(x, y, c) plot(x, y, 'Color', c, 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 5);
    
    if length(cluster_filters) > length(colors)
        warning('plot_clusters:toomanyclusters', 'Need more colors to plot all the clusters')
        cluster_filters = cluster_filters(1:length(colors));
    end
%     peaks = max(raw, [], 3);
    peaks = get_peaks(raw, false, tvals, inputrange);
    data = peaks';
%     peaks = rotatefactors(peaks', 'method', 'promax')';
%     pcs = get_new_pcs(raw);
%     data = pcs(:,:,1)';
%     peaks2 = max(abs(fft(raw, [], 3)), [], 3);
    
    
%     data = zscore(data);
    ratings = rate_clusters(cluster_filters, data);
    
    if plot_all
        pairs = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4];
        ir = max(inputrange);
        figure
        set(gcf, 'Visible', 'off')
        for k = 1:size(pairs, 1)
            subplot(3, 2, k)
            set(gca, 'Color', 'k')
            x_axis = pairs(k, 1);
            y_axis = pairs(k, 2);
            hold on
%             xlim([0 ir]);
%             ylim([0 ir]);
            myplot(data(:, x_axis), data(:, y_axis), gray)
            for c = 1:length(cluster_filters)
                cluster = data(cluster_filters{c}, :);
                cluster_x = cluster(:, x_axis);
                cluster_y = cluster(:, y_axis);
                myplot(cluster_x, cluster_y, colors{c})
            end
            xlabel(sprintf('Peak %d', x_axis))
            ylabel(sprintf('Peak %d', y_axis))
            hold off
        end
        set(gcf, 'Visible', 'on')
        set(gcf, 'InvertHardCopy', 'off')
    elseif individually
        for c = 1:length(cluster_filters)
            rating = ratings(:, c);
            [~, inds] = sort(rating);
            x_axis = inds(1);
            y_axis = inds(2);
            
            figure
            set(gcf, 'Visible', 'off')
            hold on
            
            xlim([0 inputrange(x_axis)]);
            ylim([0 inputrange(y_axis)]);
            data_x = data(:, x_axis);
            data_y = data(:, y_axis);
            myplot(data_x, data_y, gray)
            if together
                cluster_vec = 1:length(cluster_filters);
            else
                cluster_vec = c;
            end
            for d = cluster_vec
                cluster = cluster_filters{d};
                cluster_x = data_x(cluster);
                cluster_y = data_y(cluster);
                myplot(cluster_x, cluster_y, colors{d})
            end
            xlabel(sprintf('Peak %d', x_axis))
            ylabel(sprintf('Peak %d', y_axis))
%             title(sprintf('Cluster %d (%d) [%.3f, %.3f, %.3f %.3f]', c, ...
%                 length(cluster_filters{c}), gradings(c, 1), ...
%                 gradings(c, 2), gradings(c, 3), gradings(c, 4)))
            title(sprintf('Cluster %d (%d)', c, length(cluster_filters{c})))
            hold off
        	set(gcf, 'Visible', 'on')
            set(gcf, 'InvertHardCopy', 'off')
        end
    else
        mean_ratings = mean(ratings, 2);
        [~, inds] = sort(mean_ratings);
        x_axis = inds(1);
        y_axis = inds(2);
        
        figure
        set(gcf, 'Visible', 'off')
        hold on
        
        xlim([0 inputrange(x_axis)]);
        ylim([0 inputrange(y_axis)]);
        myplot(data(:, x_axis), data(:, y_axis), gray)
        for c = 1:length(cluster_filters)
            cluster = data(cluster_filters{c}, :);
            cluster_x = cluster(:, x_axis);
            cluster_y = cluster(:, y_axis);
            myplot(cluster_x, cluster_y, colors{c})
        end
        xlabel(sprintf('Peak %d', x_axis))
        ylabel(sprintf('Peak %d', y_axis))
        title('All clusters')
        hold off
        set(gcf, 'Visible', 'on')
        set(gcf, 'InvertHardCopy', 'off')
    end
    colordef white
end