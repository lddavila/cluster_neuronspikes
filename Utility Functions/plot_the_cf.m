function [] = plot_the_cf(cf,aligned,called_by)

number_of_clusters = size(cf,2);
legend_string = cell(1,number_of_clusters);
data = get_peaks(aligned,true);
colors = distinguishable_colors(number_of_clusters+5);
for x_axis_wire=1:size(aligned,1)
    for y_axis_wire=x_axis_wire+1:size(aligned,1)
        figure;
        for i=1:number_of_clusters
            current_cluster_idxs = cf{i};
            legend_string{i} = "C"+string(i);
            scatter(data(x_axis_wire,current_cluster_idxs),data(y_axis_wire,current_cluster_idxs),'filled','o','MarkerFaceColor',colors(i,:),'MarkerEdgeColor',colors(i,:))
            hold on;
        end
        xlabel("Channel" + string(x_axis_wire));
        ylabel("Channel" + string(y_axis_wire));
        legend(legend_string,'Location','best');
        title(["Channel "+string(x_axis_wire) + " vs " + string(y_axis_wire),called_by])
    end
end