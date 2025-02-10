function [] = display_the_spike_traces_and_examples(dir_with_continous_recordings,timestamps,list_of_channels,bit_volts)
time_delta = 1/30000;
for i=1:length(list_of_channels)
    current_channel_data = importdata(dir_with_continous_recordings+"\"+list_of_channels(i)+".mat");
    current_channel_data = current_channel_data.';
    current_channel_data = double(current_channel_data);
    current_channel_data = current_channel_data*bit_volts(1);
    figure;
    beginning_time = 1*time_delta;
    ending_time = size(current_channel_data,1) * time_delta;
    plot(linspace(beginning_time,ending_time,size(current_channel_data,1)),current_channel_data);
    hold on;
    title(list_of_channels(i));
    xlabel("Time")
    ylabel("Microvolts (Inverted)")

    close all;
end
end