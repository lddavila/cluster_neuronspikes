function [output_array,aligned_array,reg_timestamps_array] = run_clustering_algorithm_on_desired_tetrodes(list_of_desired_tetrodes,tetrode_dictionary,spike_tetrode_dictionary,spike_tetrode_dictionary_samples_format,channel_wise_means,channel_wise_std,number_of_std_above_means,timing_tetrode_dictionary,dir_with_channel_recordings)
output_array = cell(1,length(list_of_desired_tetrodes));
aligned_array = cell(1,length(list_of_desired_tetrodes));
reg_timestamps_array= cell(1,length(list_of_desired_tetrodes));
filenames = [];
for j=1:length(list_of_desired_tetrodes)
    filenames = [filenames,strcat(list_of_desired_tetrodes(j),".mat")];
end
for i=1:length(list_of_desired_tetrodes)
    current_tetrode = list_of_desired_tetrodes(i);
    channels_in_current_tetrode = tetrode_dictionary(current_tetrode);
    raw = spike_tetrode_dictionary(current_tetrode);
    % raw = raw*-1;
    % raw = raw*100;

    number_of_spikes = size(raw,2);
    %disp("Tetrode #"+ string(current_tetrode)+" has " + string(size(raw,2)) + " spikes")
    raw_in_samples_format = spike_tetrode_dictionary_samples_format(current_tetrode);
    raw_in_samples_format = raw_in_samples_format;
    % raw_in_samples_format = raw_in_samples_format *100;

    mean_of_relevant_channels = channel_wise_means(channels_in_current_tetrode) ;
    std_dvns_of_relevant_channels = channel_wise_std(channels_in_current_tetrode);

    wire_filter = find_live_wires(raw);
    nonzero_samples = raw_in_samples_format(:,wire_filter,:);
    minpeaks = shiftdim(min(max(nonzero_samples),[],2),2);
    maxvals = shiftdim(max(min(nonzero_samples),[],2),2);
    admax_val = 32767;
    good_spike_filter = minpeaks < admax_val & maxvals > (-admax_val);
    good_spike_idx = find(good_spike_filter);
    % good_spike_idx = 1:size(raw,2);

    timestamps_for_current_tetrode = timing_tetrode_dictionary(current_tetrode);
    ir = calculate_input_range_for_raw_by_channel_ver_2(channels_in_current_tetrode,dir_with_channel_recordings);
    ir = ir(:,1) - ir(:,2);
    tvals = mean_of_relevant_channels + (std_dvns_of_relevant_channels * number_of_std_above_means);

    config = spikesort_config(); %load the config file;


    [output,aligned,reg_timestamps] = run_spikesort_ntt_core_ver2(raw,timestamps_for_current_tetrode,good_spike_idx,ir,tvals,filenames,config,channels_in_current_tetrode,i);
    %   - the first column contains the timestamps of the spikes in seconds
    %   - the second column contains the cluster classification of the spikes
    %       E.g., a value of '3' means that the spike belongs to cluster 3.
    if ~isempty(output) && ~isempty(aligned) && ~isempty(reg_timestamps)
        output_array{i} = output;
        aligned_array{i} = aligned;
        reg_timestamps_array{i} = reg_timestamps;
    else
        output_array{i} = NaN;
        aligned_array{i} = NaN;
        reg_timestamps_array{i} = Nan;
        disp("Finished "+ string(i)+"/"+string(length(list_of_desired_tetrodes)))
        continue;
    end

    load(filenames(i));
    idx = extract_clusters_from_output(output(:,1),output,config);
    channel_string = "";

    % plot_clusters(idx,raw,tvals,ir,grades)
    for first_dimension = 1:size(raw,1)
        for second_dimension = first_dimension+1:size(raw,1)
            new_plot_proj(idx,aligned,first_dimension,second_dimension,channels_in_current_tetrode,current_tetrode);
        end
    end
    
    



    disp("Finished "+ string(i)+"/"+string(length(list_of_desired_tetrodes)))
end
end