function [n, U] = cluster_prepare_data(filtered_raw, cluster_ns, extract_features_fn, config)
%CLUSTER_PREPARE_DATA Prepares the data for clustering.
%   [n, U] = CLUSTER_PREPARE_DATA(filtered_raw, cluster_ns, config) returns
%   the number of clusters (n) and the fuzzy partition matrix (U).
    n = 0;
    U = [];
    
    num_spikes = size(filtered_raw, 2);
    if num_spikes < config.params.CL_MIN_CLUSTER_SPIKES 
        return
    end

    [cluster_data, supp_data] = extract_features_fn(filtered_raw);
    
    % Determine which clustering is best using the MPC validity index
    data = [cluster_data, supp_data];
    weights = calculate_weights(data, config.WEIGHT_NS, config);
    fprintf('%d ', weights)
    fprintf('\n')
    good_weights_idx = find(weights);
    weights = weights(good_weights_idx);
    if isempty(weights)
        n = 1;
        return
    end
    
    if config.USE_DIMENSION_SELECTION
        resized_data = data(:, good_weights_idx);

        % Perform space transformation on normalized data
        weighted_data = resized_data .* repmat(weights, size(resized_data, 1), 1);
    else
        weighted_data = data;
    end
    [n, U] = get_best_configuration(weighted_data, cluster_ns, config);
end