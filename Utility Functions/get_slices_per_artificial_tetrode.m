function [spike_slices,time_slices,spiking_channels,spike_slices_in_samples_format] = get_slices_per_artificial_tetrode(chan_of_art_tetrode,spike_windows,recording_matrix,timing_matrix,number_of_dps_per_slice)

spike_slices = {};
time_slices = {};
spiking_channels = {};
spike_slices_in_samples_format = {};

spike_windows_for_current_tetrode = [];
for i=1:length(chan_of_art_tetrode)
    current_channel = chan_of_art_tetrode(i);
    spike_windows_for_current_channel = cell2mat(spike_windows{current_channel}(:));
    if isempty(spike_windows_for_current_channel)
        continue;
    end
    spike_windows_for_current_tetrode = [spike_windows_for_current_tetrode;spike_windows_for_current_channel];
end

if isempty(spike_windows_for_current_tetrode)
    return;
end
sorted_spike_windows_for_current_tetrode = sortrows(spike_windows_for_current_tetrode,[1,3]);
sorted_spike_windows_for_current_tetrode = rmmissing(sorted_spike_windows_for_current_tetrode);

%spike_slices_must_be_sorted_in_such_a_way_that when you run the following code the output matches
%[numwires, numspikes, numdp] = size(raw);
%numwires: number of channels
%numspikes: number of spikes
%numdp: number of datapoints

%
spike_slices = zeros(size(chan_of_art_tetrode,2),size(sorted_spike_windows_for_current_tetrode,1),number_of_dps_per_slice);

%spike_slices_in_samples_format is the same data as in spike_slices, but permutted differently
%   Samples: spike waveform samples formatted as a 32xMxN matrix of data
%       points, where M is the number of subchannels (wires) in the spike
%       file (NTT M = 4, NST M = 2, NSE M = 1). These values are in AD
%       counts.
spike_slices_in_samples_format =zeros(number_of_dps_per_slice,size(chan_of_art_tetrode,2),size(sorted_spike_windows_for_current_tetrode,1));

time_slices = zeros(size(sorted_spike_windows_for_current_tetrode,1),number_of_dps_per_slice);
spiking_channels = cell(1,size(sorted_spike_windows_for_current_tetrode,1));
for i=1:size(sorted_spike_windows_for_current_tetrode,1)
    if size(sorted_spike_windows_for_current_tetrode,2) == 0
        break;
    end
    current_window = sorted_spike_windows_for_current_tetrode(i,:);
    window_beginning = current_window(1);
    window_end = current_window(2);
    
    current_timing_slice = timing_matrix(window_beginning:window_end-1);
    time_slices(i,:) = current_timing_slice;
    
    for j=1:length(chan_of_art_tetrode)
        current_channel = chan_of_art_tetrode(j);
        spike_slices(j,i,:) = recording_matrix(window_beginning:window_end-1,current_channel);
        spike_slices_in_samples_format(:,j,i) = recording_matrix(window_beginning:window_end-1,current_channel);
    end
    spiking_channels{i} = current_window(3);
end
end