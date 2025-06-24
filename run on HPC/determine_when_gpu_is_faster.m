function [] = determine_when_gpu_is_faster()
gt_data = 1:1:10000;
ts_of_cluster = 10000:1:20000;
time_delta = 0.001;
number_of_true_positives = 0;
array_of_normal_computation_times = nan(size(gt_data,2),1);
array_of_gpu_computation_times = nan(size(gt_data,2),1);
for j=1:size(gt_data,2)
    beginning_time_of_basic_comp = tic;
    for i=1:length(gt_data(1:j))
        current_gt_spike_ts = gt_data(i);
        diffs_between_gt_ts_and_clust_ts = abs(current_gt_spike_ts - ts_of_cluster(1:j));
        if any(diffs_between_gt_ts_and_clust_ts< time_delta)
            number_of_true_positives = number_of_true_positives+1;
        end
    end
    array_of_normal_computation_times(j)= toc(beginning_time_of_basic_comp);
    print_status_iter_message("determine_when_gpu_is_faster.m: regular loop",j,size(gt_data,2))
end

number_of_true_positives = 0;
for j=1:size(gt_data,2)
    beginning_time_of_gpu_comp = tic;
    gt_data_IN_GPU = gpuArray(gt_data);
    ts_of_cluster_IN_GPU = gpuArray(ts_of_cluster);
    for i=1:length(gt_data(1:j))
        current_gt_spike_ts = gt_data_IN_GPU(i);
        diffs_between_gt_ts_and_clust_ts = abs(current_gt_spike_ts - ts_of_cluster_IN_GPU(1:j));
        % [smallest_difference,~] = min(abs(diffs_between_gt_ts_and_clust_ts));
        if any(diffs_between_gt_ts_and_clust_ts< time_delta)
            number_of_true_positives = number_of_true_positives+1;
        end
    end
    clear("gt_data_IN_GPU")
    clear("ts_of_cluster_IN_GPU")
    array_of_gpu_computation_times(j) = toc(beginning_time_of_gpu_comp);
    print_status_iter_message("determine_when_gpu_is_faster.m:gpu loop",j,size(gt_data,2))
end
% fprintf("Normal Computation Time:%f",end_time_of_basic_comp)
% fprintf("Normal Computation Time:%f",end_time_of_gpu_comp);
plot(array_of_normal_computation_times);
hold on;
plot(array_of_gpu_computation_times);
legend(["Normal","GPU"])
title("Number of data points in both clusters")
end