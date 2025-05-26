function [sum] = run_check(current_unit_ts,j,timestamps_of_cluster,time_delta)
sum=0;
diffs_between_unit_ts_and_cluster_ts = current_unit_ts(j) - timestamps_of_cluster;
if any(abs(diffs_between_unit_ts_and_cluster_ts) < time_delta)
    sum = 1;
end
end