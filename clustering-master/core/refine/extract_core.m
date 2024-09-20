function cluster_core_idx = extract_core(features, cluster_idx, config)
%EXTRACT_CORE Extracts the core of a cluster in a given feature space.
%   cluster_core_idx = EXTRACT_CORE(features, cluster_idx) returns the
%   indices of the cluster core in the feature space.
%
%   The rows of 'features' are observations, and each column is a different
%   feature.
%
%   'cluster_idx' are the indices of the cluster.
%
%   See also REFINE_CLUSTER, NAIVE_EXPAND_CLUSTER, SMART_EXPAND_CLUSTER.

    cluster_features = features(cluster_idx, :);
    data_filt = find_singular_cols(cluster_features);
    cluster_features = cluster_features(:, data_filt);
    num_spikes = length(cluster_idx);
    
    % Calculates Euclidean distance from each point to the center of the
    % cluster.
    dists = mahal(cluster_features, cluster_features);
    [~, ind] = sort(dists);
    
    % Ideally the cluster core consists of 30% of the spikes in the
    % cluster.
    num_core_spikes = round(config.params.RF_CORE_CLUSTER_PERCENT * num_spikes);
    
    % However, when a cluster is quite small, the cluster core can consist
    % of as many as 60% of the spikes in the cluster.
    upper_bound = min(round(config.params.RF_CORE_UPPER_BOUND_PERCENT * num_spikes), ...
                      max(config.params.RF_CORE_UNTIL_BOUND, num_core_spikes));
    
    core_idx = ind(1:upper_bound);
    cluster_core_idx = cluster_idx(core_idx);
end