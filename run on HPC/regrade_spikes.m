function [grades_for_current_combo,new_accuracy,different_max_overlap_unit_flag] = regrade_spikes(combinable_spikes_ts,idx_cell_array,aligned_cell_array,channels_per_cluster,spike_og_locs_cell_array,config,t_vals_cell_array,max_overlap_units)

if ~all(max_overlap_units==max_overlap_units(1))
    different_max_overlap_unit_flag = "*";
else
    different_max_overlap_unit_flag = "";
end
[timestamps_of_merged_spikes,spike_slices,channels_in_current_tetrode,t_vals,timestamps] =recut_spikes(channels_per_cluster,spike_og_locs_cell_array,idx_cell_array,config,t_vals_cell_array);
if config.ON_HPC
    ground_truth_array = importdata(config.FP_TO_GT_FOR_RECORDING_ON_HPC);
    dir_with_channel_recordings = config.DIR_WITH_OG_CHANNEL_RECORDINGS_ON_HPC;
else
    ground_truth_array = importdata(config.GT_FP);
    dir_with_channel_recordings = config.DIR_WITH_OG_CHANNEL_RECORDINGS;
end
ground_truth_idxs = ground_truth_array{max_overlap_units(1)};

gt_ts = timestamps(ground_truth_idxs); %the timestamps of the unit that the current cluster has the most overlap with (in seconds)
cluster_ts = timestamps_of_merged_spikes; %the timestamps of the spikes of the current cluster (in seconds)
new_accuracy=NaN;
wire_filter = find_live_wires(spike_slices);
ir = calculate_input_range_for_raw_by_channel_ver_3(channels_in_current_tetrode,dir_with_channel_recordings);
r_raw = spike_slices(wire_filter, :, :);
r_ir = ir(wire_filter);
r_tvals = t_vals(wire_filter);

interp_raw = interpolate_spikes(r_raw, config);


% Align spikes to peak, each wire independently
aligned = align_to_peak_ver_2(interp_raw, r_tvals, r_ir);
if config.ON_HPC
    dir_of_template_shape_pngs = config.TEMPLATE_CLUSTER_FP_ON_HPC;
else
    dir_of_template_shape_pngs = config.TEMPLATE_CLUSTER_FP;
end


grades_for_current_combo = compute_gradings_ver_4(aligned, timestamps_of_merged_spikes, t_vals, {1:size(timestamps_of_merged_spikes,1)}, config.spikesort,0,channels_in_current_tetrode,dir_of_template_shape_pngs,config);
if size(gt_ts,2) < size(cluster_ts,1)
    tp = find_number_of_true_positives_given_a_time_delta_hpc(gt_ts,cluster_ts.',config.TIME_DELTA); % a spike that is in both the cluster and the unit with some time delta specified in seconds
else
    tp = find_number_of_true_positives_given_a_time_delta_hpc(cluster_ts.',gt_ts,config.TIME_DELTA);
end
fn = length(gt_ts) - tp; % a spike in the unit, but not in the cluster
tn = 0; % this would be a spike in the same configuration ie
%                                   |z score n|tetrode i| cluster a
%but not assigned to this cluster
%we set this equal to 0 because it is not a helpful metric and costly to compute
fp = length(cluster_ts) - tp; % aspike that is in the cluster, but does not have a correlative spike in the unit

new_accuracy = ((tp +tn)/(tp+fn+tn+fp))*100;
if new_accuracy >100
    print("Something is wrong");
end
close all;


end