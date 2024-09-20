function final_clusters = core_cluster_loop(spike_aligned, extract_features_fn, config)
    level = 1;
    done = false;
    start_cl = struct();
    start_cl.subclust = true;
    start_cl.idx = 1:size(spike_aligned, 2);
    clusters = {start_cl};
    while ~done && level <= config.MAX_SUBCLUSTER_DEPTH
        if level == 1
            cluster_ns = config.CLUSTER_NS;
        else
            cluster_ns = config.SUBCLUSTER_NS;
        end
        next_clusters = {};
        done = true;
        for k = 1:length(clusters)
            cl = clusters{k};
            if cl.subclust
                done = false;
                subclusters = core_cluster(spike_aligned(:, cl.idx, :), cluster_ns, cl.idx, extract_features_fn, config);
                next_clusters = [next_clusters subclusters];
            else
                next_clusters = [next_clusters cl];
            end
        end
        clusters = next_clusters;
        level = level + 1;
    end
    final_clusters = cellmap(@(x) x.idx, clusters);
end