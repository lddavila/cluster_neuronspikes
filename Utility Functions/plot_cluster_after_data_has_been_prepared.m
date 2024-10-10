function [cluster_filters] = plot_cluster_after_data_has_been_prepared(U,weighted_data,number_of_clusters,place,dimension_names)
cluster_filters = cell(1,number_of_clusters);
maxU = max(U);
base_cluster_filters = repmat(maxU, [number_of_clusters, 1]) == U;
base_cluster_filters = base_cluster_filters.';
colors = distinguishable_colors(number_of_clusters);
for first_dimension =1:size(weighted_data,2)
    for second_dimension=first_dimension+1:size(weighted_data,2)
        figure;
        legend_string = cell(1,number_of_clusters);
        for current_cluster = 1:number_of_clusters
            cluster_filters{current_cluster} = find(base_cluster_filters(:,current_cluster));
            legend_string{current_cluster} = "C"+string(current_cluster)+" # dps: " +string(sum(base_cluster_filters(:,current_cluster)));
            scatter(weighted_data(base_cluster_filters(:,current_cluster),first_dimension), ...
                weighted_data(base_cluster_filters(:,current_cluster),second_dimension), ...
                "filled",...
                MarkerEdgeColor=colors(current_cluster,:),MarkerFaceColor=colors(current_cluster,:));
            hold on;
        end
        legend(legend_string);
        xlabel(dimension_names(first_dimension));
        ylabel(dimension_names(second_dimension));
        title([place,"total DPS: "+string(size(weighted_data,1))])
    end
end
end