function [number_of_true_positives] = find_number_of_true_positives_given_a_time_delta_hpc(gt_data,ts_of_cluster,time_delta)
number_of_true_positives = 0;
% parpool("Threads",6)
parfor i=1:length(gt_data)
    current_gt_spike_ts = gt_data(i);
    diffs_between_gt_ts_and_clust_ts = ts_of_cluster - current_gt_spike_ts;
    [smallest_difference,~] = min(abs(diffs_between_gt_ts_and_clust_ts));
    if smallest_difference < time_delta
        number_of_true_positives = number_of_true_positives+1;
    end
end
delete(gcp("nocreate"));
end