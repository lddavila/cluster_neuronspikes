function [channel_with_max_value,the_max_value] = channel_with_max_value(ordered_list_of_channels,dir_with_channel_recordings)
channel_with_max_value = "";
the_max_value = 0;
for i=1:length(ordered_list_of_channels)
    current_channel_data = importdata(dir_with_channel_recordings+"\"+ordered_list_of_channels(i)+".mat");
    current_channel_data = abs(current_channel_data);
    max_amplitude = max(current_channel_data);
    if max_amplitude > the_max_value
        the_max_value = max_amplitude;
        channel_with_max_value = ordered_list_of_channels(i);
    end
end
end