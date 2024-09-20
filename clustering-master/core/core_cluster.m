function clusters = core_cluster(spikes, cluster_ns, cluster_idx_inj, extract_features_fn, config)
%CLUSTER Performs the actual clustering and subclustering (as well as
%feature extraction and selection)
    
    [n, U] = cluster_prepare_data(spikes, cluster_ns, extract_features_fn, config);
    if n == 0
        clusters = {};
    elseif n == 1
        cl = struct();
        cl.subclust = false;
        cl.idx = cluster_idx_inj;
        clusters = {cl};
    else
        maxU = max(U);
        base_cluster_filters = repmat(maxU, [n, 1]) == U;
        clusters = {};
        for k = 1:n
            cluster_filter = base_cluster_filters(k, :);
            subcluster_idx_inj = cluster_idx_inj(cluster_filter);
            if length(subcluster_idx_inj) < config.params.CL_MIN_CLUSTER_SPIKES
                continue
            end
            subcl = struct();
            subcl.subclust = ~isequal(cluster_idx_inj, subcluster_idx_inj);
            subcl.idx = subcluster_idx_inj;
            clusters = [clusters subcl];
%             cluster_spikes = spikes(:, cluster_filter, :);
%             subclusters = core_cluster(cluster_spikes, ...
%                             config.SUBCLUSTER_NS, ...
%                             config, ...
%                             subcluster_idx_inj, ...
%                             level + 1);
%             if ~isempty(subclusters)
%                 clusters = [clusters subclusters];
%             end
        end
    end
end
