function [] = plot_around_peaks(channels_per_neuron,dir_with_channel_recordings,neuron_ground_truth,number_of_spikes_per_channel)
for i=1:length(channels_per_neuron)
    current_channel = channels_per_neuron(i);
    current_channel_data = importdata(dir_with_channel_recordings+"\c"+string(current_channel)+".mat");
    figure;
    for j=1:number_of_spikes_per_channel
        current_peak = neuron_ground_truth(i);
        if current_peak - 30 < 1
            beginning_of_window = 1;
        else
            beginning_of_window = current_peak-30;
        end
        if current_peak+30 > length(current_channel_data)
            end_of_window = length(current_channel_data);
        else
            end_of_window = current_peak+30;
        end
        current_data = current_channel_data(beginning_of_window:end_of_window-1) * -1;
        
        subplot(1,number_of_spikes_per_channel,j)
        plot(1:length(current_data),current_data);
        hold on;
        scatter(31,current_channel_data(current_peak) * -1,'filled','o')
        ylabel("Voltage")
        xlabel("# of dps")
        title("Spike #" +string(j))
    end
    sgtitle("c"+string(current_channel));
end