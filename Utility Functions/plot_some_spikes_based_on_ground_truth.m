function [] = plot_some_spikes_based_on_ground_truth(number_of_channels_to_do,number_of_spikes_to_do_per_channel,neuron_n_ground_truth)
for i=1:number_of_channels_to_do
    for j=1:number_of_spikes_to_do_per_channel
        
        y_data = squeeze(neuron_n_ground_truth(i,j,:)) * -1;
        if all(y_data < 10)
            continue;
        end
        figure;
        x_data = 1:60;
        plot(x_data,y_data);
        hold on;
        title("Channel " + string(i) + " Spike # "+string(j));
    end
    if i==10
        disp("hold on")
        close all;
    end
end
end