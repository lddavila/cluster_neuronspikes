function [] = plot_spikes_nearest_to_each_other(spikes_per_channel,channels_to_plot,time_to_start_plotting,min_amp,lag_in_seconds,number_of_dpts_to_plot,timestamps,dir_with_recordidngs)
all_channel_data = cell(1,length(channels_to_plot));
for i=1:length(channels_to_plot)
    all_channel_data{i} = importdata(dir_with_recordidngs+"\c"+string(channels_to_plot(i))+".mat");
end
for i=1:length(channels_to_plot)
    current_channel = channels_to_plot(i);
    current_spikes = spikes_per_channel{current_channel};
    for j=1:length(current_spikes)
        current_spike_peak_index = current_spikes(j);
        beginning_of_peak = current_spike_peak_index - (number_of_dpts_to_plot /2);
        end_of_peak = current_spike_peak_index + (number_of_dpts_to_plot/2);
        if beginning_of_peak < 1
            beginning_of_peak =1;
        end
        timestamps_of_current_spike = timestamps(beginning_of_peak:end_of_peak);
        voltages_of_current_peaks = all_channel_data{i}(beginning_of_peak:end_of_peak);
        amp_of_current_peak = all_channel_data{i}(current_spike_peak_index);
        if amp_of_current_peak < min_amp ||  timestamps_of_current_spike(1) < time_to_start_plotting
            continue;
        end
        figure;
        plot(timestamps_of_current_spike,voltages_of_current_peaks,LineWidth=5);
        hold on;
        scatter(timestamps(current_spike_peak_index),all_channel_data{i}(current_spike_peak_index));
        legend_string = ["c"+string(channels_to_plot(i)), ""];
        delay_string = [];
        for k=1:length(channels_to_plot)
            if k==i
                continue;
            end
            other_channel = channels_to_plot(k);
            other_channel_spikes = spikes_per_channel{other_channel};
            abs_diff_between_current_spike_and_others = abs(other_channel_spikes - current_spike_peak_index);
            [~,index_of_closest_spike_on_other_channel] = min(abs_diff_between_current_spike_and_others);
            closest_spike_index_on_other_channel = other_channel_spikes(index_of_closest_spike_on_other_channel);
            beginning__of_other_spike = closest_spike_index_on_other_channel- (number_of_dpts_to_plot /2);
            if beginning__of_other_spike < 1
                beginning__of_other_spike = 1;
            end
            end_of_other_spike = closest_spike_index_on_other_channel + (number_of_dpts_to_plot /2 );
            other_spike_ts = timestamps(beginning__of_other_spike:end_of_other_spike);

            if abs(timestamps(closest_spike_index_on_other_channel) - timestamps(current_spike_peak_index)) > lag_in_seconds
                continue;
            end
            voltages_of_other_spike = all_channel_data{k}(beginning__of_other_spike:end_of_other_spike);
            plot(other_spike_ts,voltages_of_other_spike);
            scatter(timestamps(closest_spike_index_on_other_channel),all_channel_data{k}(closest_spike_index_on_other_channel));
            legend_string = [legend_string,"c"+string(channels_to_plot(k)),""];
            delay_string = [delay_string, sprintf("Delay of peak On C%i is %0.3f mills.",channels_to_plot(k),1000 *abs(timestamps(current_spike_peak_index) - timestamps(closest_spike_index_on_other_channel)))] ;

        end
        if length(legend_string)  == 2
            close all;
            continue;
        end
        yline(0);
        legend_string = [legend_string,""];
        legend(legend_string);
        xlabel("Time (seconds)");
        ylabel("Microvolts")
        sgtitle(delay_string)
        close all;
    end

end
end