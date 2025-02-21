function [] = plot_individual_spikes_from_open_ephys(dir_with_continuous_recordings,spike_windows,list_of_channels,time_to_start_displaying_spikes_from,single_plot,how_many_spikes,how_many_to_cut)
time_delta = 1/30000;
% all_ts = linspace(1*time_delta,size_of_og_data*time_delta,size_of_og_data);
for i=1:length(list_of_channels)
    channel_number = str2double(strrep(list_of_channels(i),"c",""));
    current_spike_data = spike_windows{channel_number};%index the for the current channel
    current_channel_data = importdata(dir_with_continuous_recordings+"\"+list_of_channels(i)+".mat");
    % current_channel_data_og_idxs = importdata(dir_with_og_idxs+"\"+list_of_channels(i)+" Original Indexes.mat");
    number_of_spikes_plotted=0;
    for j=1:size(current_spike_data,2)%modify this for apprpriate size of current spike data

        current_spike_indexes = current_spike_data{j};

        beginning_index = current_spike_indexes(1) + how_many_to_cut;
        beginning_time = time_delta * double(beginning_index);
        if beginning_time < time_to_start_displaying_spikes_from
            continue;
        end

        ending_index = current_spike_indexes(2) - how_many_to_cut;
        ending_time_of_spike = time_delta * double(ending_index);

        channel = current_spike_indexes(3);
        peake_location = current_spike_indexes(4);

        if isnan(beginning_index) || isnan(ending_index)
            continue;
        end

        
        current_spike_amplitudes =current_channel_data(beginning_index:ending_index) ;
        if ~single_plot
            figure;
            ts = linspace(beginning_time,ending_time_of_spike,size(current_spike_amplitudes,2));
            plot(ts,current_spike_amplitudes) %insert the complete hting here
            hold on;
            scatter(ts(26-how_many_to_cut),current_channel_data(peake_location));
            title("Channel " +string(channel_number)+ " Spike #"+string(j));
       
            xlabel("Time (seconds)");
            ylabel("Microvolts (inverted)")
            % pause(3);
            close all;
        elseif single_plot
            ts = linspace(1,2,length(current_spike_amplitudes));
            plot(ts,current_spike_amplitudes);
            title("Channel " +string(channel_number)+ " Spike #"+string(j));
            xlabel("Time (milliseconds)");
            ylabel("Amplitude (microvolts)");
            hold on;
          
            number_of_spikes_plotted = number_of_spikes_plotted+1;
            
            if number_of_spikes_plotted > how_many_spikes
                close all;
                break;
            end


        end
    end
end
end