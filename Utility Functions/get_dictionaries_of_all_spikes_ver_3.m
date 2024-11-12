function [] = get_dictionaries_of_all_spikes_ver_3(art_tetr_array,spike_windows,dir_with_chan_recordings,timestamps,number_of_dps_per_slice,scale_factor,dictionaries_dir)
%tetrode_dictionary
%keys: "t" + tetrode number
%values: all channels which are part of the current dictionary
%spike_tetrode_dictionary
%keys: "t" + tetrode number
%values: the spikes for the current tetrode organized as follows
%[numwires, numspikes, numdp] = size(raw);
%numwires: number of channels
%numspikes: number of spikes
%numdp: number of datapoints
%timing_tetrode_dictionary
%channel_to_tetrode_dictionary
%keys: "c" + channel number
%values: tetrode which the current channel belongs to
%spiking_channel_tetrode_dictionary
%keys: "t"+ tetrode number
%values: a list of which channel was the actual spiking channel, ordered in the same way as spike_tetrode_dictionary
%spike_tetrode_dictionary_samples_format
%keys: "t"+tetrode number
%values: the spikes for the current tetrode organzied as follows
%[numdp, numspikes, numswires] = size(raw);
%numwires: number of channels
%numspikes: number of spikes
%numdp: number of datapoints
%timing_tetrode_dictionary



for i=1:size(art_tetr_array,1)
    tetrode_dictionary = containers.Map('KeyType','char','ValueType','any');
    spike_tetrode_dictionary = containers.Map('KeyType','char','ValueType','any');
    spike_tetrode_dictionary_samples_format = containers.Map('KeyType','char','ValueType','any');
    timing_tetrode_dictionary = containers.Map('KeyType','char','ValueType','any');
    channel_to_tetrode_dictionary = containers.Map('KeyType','char','ValueType','any');
    spiking_channel_tetrode_dictionary = containers.Map('KeyType','char','ValueType','any');
    channels_in_current_tetrode = art_tetr_array(i,:);
    tetrode_dictionary("t"+string(i)) = channels_in_current_tetrode;
    for j=1:length(channels_in_current_tetrode)
        channel_to_tetrode_dictionary("c"+string(channels_in_current_tetrode(j))) = i;
    end
    [current_slice,current_timing,current_spiking_channels,spike_slices_in_samples_format] = get_slices_per_artificial_tetrode_ver_2(channels_in_current_tetrode,spike_windows,dir_with_chan_recordings,timestamps,number_of_dps_per_slice,scale_factor);



    spike_tetrode_dictionary("t"+string(i)) = current_slice;
    timing_tetrode_dictionary("t"+string(i)) = current_timing;
    spiking_channel_tetrode_dictionary("t"+string(i)) = current_spiking_channels;
    spike_tetrode_dictionary_samples_format("t"+string(i)) = spike_slices_in_samples_format;

    save(dictionaries_dir+"\t"+string(i)+" tetrode_dictionary.mat","tetrode_dictionary");
    save(dictionaries_dir+"\t"+string(i)+" spike_tetrode_dictonary.mat","spike_tetrode_dictionary")
    save(dictionaries_dir+"\t"+string(i)+" timing_tetrode_dictionary.mat","timing_tetrode_dictionary")
    save(dictionaries_dir+"\t"+string(i)+" channel_to_tetrode_dictionary.mat","channel_to_tetrode_dictionary")
    save(dictionaries_dir+"\t"+string(i)+" spiking_channel_tetrode_dictionary.mat","spiking_channel_tetrode_dictionary")
    save(dictionaries_dir+"\t"+string(i)+" spike_tetrode_dictionary_samples_format.mat","spike_tetrode_dictionary_samples_format");

    
    disp("Completed Dictionary " + string(i) + "/"+string(size(art_tetr_array,1)))
end
end