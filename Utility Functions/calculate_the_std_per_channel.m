function [channel_wise_std] = calculate_the_std_per_channel(recordings)
channel_wise_std = std(recordings,0,1);
end