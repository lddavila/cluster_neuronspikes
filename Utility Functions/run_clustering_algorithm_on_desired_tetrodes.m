function [output_array,aligned_array,reg_timestamps_array] = run_clustering_algorithm_on_desired_tetrodes(list_of_desired_tetrodes,tetrode_dictionary,spike_tetrode_dictionary,spike_tetrode_dictionary_samples_format,channel_wise_means,channel_wise_std,number_of_std_above_means, filenames)
    output_array = cell(1,length(list_of_desired_tetrodes));
    aligned_array = cell(1,length(list_of_desired_tetrodes));
    reg_timestamps_array= cell(1,length(list_of_desired_tetrodes));
    for i=1:length(list_of_desired_tetrodes)
        current_tetrode = list_of_desired_tetrodes(i);
        channels_in_current_tetrode = tetrode_dictionary(current_tetrode);
        raw = spike_tetrode_dictionary(current_tetrode);
        raw = raw*-1;
        raw_in_samples_format = spike_tetrode_dictionary_samples_format(current_tetrode);
        mean_of_relevant_channels = channel_wise_means(channels_in_current_tetrode);
        std_dvns_of_relevant_channels = channel_wise_std(channels_in_current_tetrode);

        wire_filter = findlive_wires(raw);
        nonzero_samples = raw_in_samples_format(:,wire_filter,:);
        minpeaks = shiftdim(min(max(nonzero_samples),[],2),2);
        maxvals = shiftdim(max(min(nonzero_samples),[],2),2);
        admax_val = 32767;
        good_spike_filter = minpeaks < admax_val & maxvals > (-admax_val);
        good_spike_idx = find(good_spike_filter);

        timestamps_for_current_tetrode = timing_tetrode_dictionary(current_tetrode);
        ir = calculateinput_range_for_raw_by_channel(raw);
        ir = abs(ir(:,1) - ir(:,2));
        tvals = mean_of_relevant_channels + (std_dvns_of_relevant_channels * number_of_std_above_means);

        config = spikesort_config(); %load the config file;
        clc;
        [output,aligned,reg_timestamps] = run_spikesort_ntt_core_ver2(raw,timestamps_for_current_tetrode,good_spike_idx,ir,tvals,filenames,config,channels_in_current_tetrode);
        output_array{i} = output;
        aligned_array{i} = aligned;
        reg_timestamps_array{i} = reg_timestamps;
    end
end