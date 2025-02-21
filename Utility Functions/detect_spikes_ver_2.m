function [spikes_matrix] = detect_spikes_ver_2(ordered_list_of_channels,dir_with_channel_recordings,dir_with_z_scores,min_z_score,scale_factor)
spikes_matrix = cell(1,length(ordered_list_of_channels));
for i=1:length(ordered_list_of_channels)
    current_channel = ordered_list_of_channels(i);
    channel_data = importdata(dir_with_channel_recordings+"\"+current_channel+".mat");
    channel_data = channel_data * scale_factor;
    z_score_data = importdata(dir_with_z_scores+"\"+current_channel+".mat");

    channel_data(abs(z_score_data) < min_z_score) = 0;

    [~,pk_locs] = findpeaks(channel_data);
    spikes_matrix{i} = pk_locs;
    disp("Finished Find Peaks Of Channel " + string(i)+"/"+string(length(ordered_list_of_channels)));
end
end