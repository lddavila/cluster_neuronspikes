function [possible_improvement_channels] = find_ideal_channel_config(spike_windows,first_pass_tetrode,dir_with_channel_recordings,clusters_from_first_pass_output,dominant_channel_array,std_dvn_rng,disp_avg_graphs,dir_to_save_figs_to)
%spike_windows
    %nx1 cell array
    %where n is the number of channels in the probe (384 in our case)
    %each array is made up of 4 numbers:
    %the first is the beginning of the spike window
    %the second is the end of the spike_window
    %the third is the original channel of the spike
    %the fourth is the original the peak of the spike according to find_peaks

%first step is finding valid neighbors for each of your dominant channels
valid_neighbors_per_channel_in_tetrode = cell(1,length(first_pass_tetrode));
possible_improvement_channels = cell(2,length(clusters_from_first_pass_output));
%possible_improvement channels will be a 2xi cell array
    %i is the number of channels
    %the first row are neighboring channels which have a higher amplitude than the current given channel
    %the second row are neighboring channels which have a lower amplitude than the current given channel
for i=1:size(dominant_channel_array,1)
    valid_neighbors_per_channel_in_tetrode{i} = find_valid_neighbors(dominant_channel_array(i,1));
end

dict_of_channel_to_recording = containers.Map('KeyType','char','ValueType','any');
%second step is to load the channel info of all valid neighbors into a dictionary fo easy access

for i=1:length(valid_neighbors_per_channel_in_tetrode)
    current_valid_neighbors = valid_neighbors_per_channel_in_tetrode{i};
    for j=1:length(current_valid_neighbors)
        dict_of_channel_to_recording("c"+string(current_valid_neighbors(j))) =  importdata(dir_with_channel_recordings+"\c"+string(current_valid_neighbors(j))+".mat");
    end
end
%we must also load the recordings of the dominant_channels, which is done below
for i=1:length(first_pass_tetrode)
    current_channel = first_pass_tetrode(i);
    dict_of_channel_to_recording("c"+string(current_channel)) = importdata(dir_with_channel_recordings+"\c"+string(current_channel)+".mat");
end

%now for each dominant channel find which of its valid neighbors have a spike amplitude within some range of the dominant channels spikes at the same location
%this should give us an indication of which direction the neuron is projecting in and thus an idea of where to go from the initial guess
for i=1:size(dominant_channel_array,1)
    current_dominant_channel = dominant_channel_array(i,1);
    current_dominant_channel_recording = dict_of_channel_to_recording("c"+string(current_dominant_channel));
    dominant_channel_spikes = spike_windows{current_dominant_channel};
    dominant_channel_neighbors = valid_neighbors_per_channel_in_tetrode{i};

    dominant_channel_spikes = cell2mat(dominant_channel_spikes.');

    dominant_channel_spikes(any(isnan(dominant_channel_spikes), 2), :) = [];
    dominant_channel_peaks = dominant_channel_spikes(:,3);
    for k=1:length(dominant_channel_neighbors)
        current_neighbor = dominant_channel_neighbors(k);
        current_neighbor_recording = dict_of_channel_to_recording("c"+current_neighbor);
        %number_of_spikes_within_range = 0;
        legend_strings = cell(1,3);
        legend_strings{1,1} = string(current_dominant_channel) +" "+ string(std_dvn_rng * 100) + "% Above";
        legend_strings{1,2} = string(current_dominant_channel) +" Actual";
        legend_strings{1,3} = string(current_dominant_channel) +" "+ string(std_dvn_rng * 100) + " % Below";
        legend_strings{1,4} = string(current_neighbor);

        spikes_for_dominant_channel = zeros(length(dominant_channel_spikes),60);
        spikes_for_current_neighbor=  zeros(length(dominant_channel_spikes),60);
        %extract all spikes_from_both the dominant channel and the current valid neighbor
        for j=1:length(dominant_channel_spikes)
            current_spike = dominant_channel_spikes(j,:);
            spike_beginning = current_spike(1);
            spike_end = current_spike(2);
            spikes_for_dominant_channel(j,:) = current_dominant_channel_recording(spike_beginning:spike_end-1) * -1;
            spikes_for_current_neighbor(j,:) = current_neighbor_recording(spike_beginning:spike_end-1) * -1;
            %spike_peak = current_spike(4);
            % length_of_spike = spike_end - spike_beginning;
            % 
            % figure;
            % plot(1:length_of_spike,current_dominant_channel_recording(spike_beginning:spike_end-1)*-1)
            % hold on;
            % scatter(31,current_dominant_channel_recording(spike_peak)*-1,"magenta",'filled','o');
            % 
            % plot(1:length_of_spike,current_neighbor_recording(spike_beginning:spike_end-1)*-1)
            % title("Current Channel " +string(current_dominant_channel) + " valid neighbor "+string(current_neighbor))
            % legend(legend_strings)
        end

        %now get the col-wise mean of each of these spikes
        mean_of_spikes_for_dominant_channel = mean(spikes_for_dominant_channel,1);
       
        mean_of_spikes_for_neighboring_channel = mean(spikes_for_current_neighbor,1);


        if disp_avg_graphs
            figure;
            plot(1:60,(mean_of_spikes_for_dominant_channel-(mean_of_spikes_for_neighboring_channel * std_dvn_rng)),"LineStyle","--",'Color','r');
            hold on;
            plot(1:60,mean_of_spikes_for_dominant_channel,'LineStyle','--','Color','k');
            plot(1:60,(mean_of_spikes_for_dominant_channel+(mean_of_spikes_for_neighboring_channel * std_dvn_rng)),'LineStyle','--','Color','r');
           % scatter(31,mean_of_spikes_for_dominant_channel(31),"magenta",'filled','o');

            plot(1:60,mean_of_spikes_for_neighboring_channel)
            title("Current Channel " +string(current_dominant_channel) + " valid neighbor "+string(current_neighbor))
            legend(legend_strings,'Location','best')
            saveas(gcf,dir_to_save_figs_to+"\"+"Current Channel " +string(current_dominant_channel) + " valid neighbor "+string(current_neighbor)+".fig")
        end

        %check to see if the average spike of the neighboring channel is withing n std deviations of the current dominant channel dominant spike
        if mean_of_spikes_for_dominant_channel(31) - (mean_of_spikes_for_dominant_channel(31) * std_dvn_rng)< mean_of_spikes_for_neighboring_channel(31)
            %if it is then you add this neighbor as a possible improvement channel for another pass
            possible_improvement_channels{1,i} = [possible_improvement_channels{1,i},current_neighbor];
        elseif mean_of_spikes_for_neighboring_channel(31)  <= (mean_of_spikes_for_dominant_channel(31) +(mean_of_spikes_for_dominant_channel(31) * std_dvn_rng))
            possible_improvement_channels{2,i} = [possible_improvement_channels{2,i},current_neighbor];
        end
    end

end
end