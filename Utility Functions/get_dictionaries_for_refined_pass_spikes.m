function [] = get_dictionaries_for_refined_pass_spikes(art_tetr_array,spike_windows,dir_with_chan_recordings,timestamps,number_of_dps_per_slice,scale_factor,dictionaries_dir,refined_tetrode_idx)
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

tetrode_dictionary = containers.Map('KeyType','char','ValueType','any');
spike_tetrode_dictionary = containers.Map('KeyType','char','ValueType','any');
spike_tetrode_dictionary_samples_format = containers.Map('KeyType','char','ValueType','any');
timing_tetrode_dictionary = containers.Map('KeyType','char','ValueType','any');
channel_to_tetrode_dictionary = containers.Map('KeyType','char','ValueType','any');
spiking_channel_tetrode_dictionary = containers.Map('KeyType','char','ValueType','any');
channels_in_current_tetrode = art_tetr_array;
for j=1:length(channels_in_current_tetrode)
    channel_to_tetrode_dictionary("c"+string(channels_in_current_tetrode(j))) = refined_tetrode_idx;
end
tetrode_dictionary("t"+string(refined_tetrode_idx)) = channels_in_current_tetrode;


[current_slice,current_timing,current_spiking_channels,spike_slices_in_samples_format] = get_slices_for_refined_tetrode(channels_in_current_tetrode,spike_windows,dir_with_chan_recordings,timestamps,number_of_dps_per_slice,scale_factor);

spike_tetrode_dictionary("t"+string(refined_tetrode_idx)) = current_slice;
timing_tetrode_dictionary("t"+string(refined_tetrode_idx)) = current_timing;
spiking_channel_tetrode_dictionary("t"+string(refined_tetrode_idx)) = current_spiking_channels;
spike_tetrode_dictionary_samples_format("t"+string(refined_tetrode_idx)) = spike_slices_in_samples_format;

save(dictionaries_dir+"\t"+string(refined_tetrode_idx)+" tetrode_dictionary.mat","tetrode_dictionary");
save(dictionaries_dir+"\t"+string(refined_tetrode_idx)+" spike_tetrode_dictonary.mat","spike_tetrode_dictionary")
save(dictionaries_dir+"\t"+string(refined_tetrode_idx)+" timing_tetrode_dictionary.mat","timing_tetrode_dictionary")
save(dictionaries_dir+"\t"+string(refined_tetrode_idx)+" channel_to_tetrode_dictionary.mat","channel_to_tetrode_dictionary")
save(dictionaries_dir+"\t"+string(refined_tetrode_idx)+" spiking_channel_tetrode_dictionary.mat","spiking_channel_tetrode_dictionary")
save(dictionaries_dir+"\t"+string(refined_tetrode_idx)+" spike_tetrode_dictionary_samples_format.mat","spike_tetrode_dictionary_samples_format");


% disp("Completed Dictionary " + string(refined_tetrode_idx) + "/"+string(size(art_tetr_array,1)))
end