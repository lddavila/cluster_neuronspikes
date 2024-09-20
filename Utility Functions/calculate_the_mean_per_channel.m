function [channel_wise_mean] = calculate_the_mean_per_channel(recording_matrix)
%recording matrix an array of the continuous recordings
%each col. of the array is a channel
    %ex) recording_matrix(:,1) = all voltages of the recording for channel 1
channel_wise_mean = mean(recording_matrix,1);
end