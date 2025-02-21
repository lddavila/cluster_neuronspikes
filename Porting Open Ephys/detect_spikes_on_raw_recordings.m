function [spikes_matrix] = detect_spikes_on_raw_recordings(ordered_list_of_channels,dir_with_channel_recordings)
%it should come in inverted and leave inverted
spikes_matrix = cell(1,length(ordered_list_of_channels));
for i=1:length(ordered_list_of_channels)
    current_channel = ordered_list_of_channels(i);
    channel_data = importdata(dir_with_channel_recordings+"\"+current_channel+".mat");

    [~,pk_locs] = findpeaks(channel_data,"MinPeakHeight",80);
    spikes_matrix{i} = pk_locs;
    disp("Finished Find Peaks Of Channel " + string(i)+"/"+string(length(ordered_list_of_channels)));
end
end