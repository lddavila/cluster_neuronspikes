function [timestamps_of_merged_spikes,spike_slices,chan_of_art_tetrode,t_vals,timing_matrix] = recut_spikes(channels_per_cluster,spike_og_locs_cell_array,idx_cell_array,config,t_vals_cell_array)
merged_spikes = spike_og_locs_cell_array{1}(idx_cell_array{1},:);
[chan_of_art_tetrode,ia,~] = unique(reshape(channels_per_cluster,1,[]),"first");
t_vals = reshape(cell2mat(t_vals_cell_array),1,[]);
t_vals = t_vals(ia);

for combo_counter =2:size(channels_per_cluster,1)
    merged_spikes = union(merged_spikes,spike_og_locs_cell_array{combo_counter}(idx_cell_array{combo_counter},:),"rows");
end

spike_windows = cell(1,size(config.ART_TETR_ARRAY,1));
for channel_counter=chan_of_art_tetrode
    spikes_to_use= merged_spikes(:,3)==channel_counter;
    spike_windows{channel_counter} = mat2cell(merged_spikes(spikes_to_use,:), ones(1, size(merged_spikes(spikes_to_use,:), 1)), size(merged_spikes(spikes_to_use,:), 2)).';
end

%timing_matrix = importdata(config.TIMESTAMP_FP);
if config.ON_HPC
    timing_matrix = importdata(config.TIMESTAMP_FP_ON_HPC);
    dir_with_recordings = config.DIR_WITH_OG_CHANNEL_RECORDINGS_ON_HPC;
else
    timing_matrix = importdata(config.TIMESTAMP_FP);
    dir_with_recordings = config.DIR_WITH_OG_CHANNEL_RECORDINGS;
end

[spike_slices,time_slices,~,~,~] =get_slices_per_artificial_tetrode_ver_2(chan_of_art_tetrode,spike_windows,dir_with_recordings,timing_matrix,config.NUM_DPTS_TO_SLICE,config.SCALE_FACTOR);
timestamps_of_merged_spikes = time_slices(:,31);
end
