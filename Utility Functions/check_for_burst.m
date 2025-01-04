function [likelihood_of_burst] = check_for_burst(cluster_ts,cluster_spikes,debug)
%cluster ts is only the timestamp of the beginning of the spike
%from beginning to end the spike should last 2 milliseconds
%so I need to take all the cluster spikes and see if they are bursting,
%that is are the spikes spiking over shorter intervals and increasing amplitude

%the first step is to take all the spikes in the cluster
%take the timestamps of those spikes
%organize them by channel chronologically

%the cluster ts are in seconds
%the delta between timestamps should be 0.0002 in seconds == 2 milliseconds

%cluster timestamps should already be sorted chronologically so we must
%create a time series from the first timestamp to the last timestamp 

%the tricky part is finding how many timestamps you need
%in theory it should be number of spikes in the cluster * 120 (the number of interpolated data points per spike)

%but this obviously doesn't work in practice because some spikes will start
%before the previous spike ends
%catching this bursting is the entire purpose of grade

likelihood_of_burst = 0; %by default not likely at all




number_of_times_next_spike_started_before_current = 0;

distance_between_dpts = (2/1000)/120;

cell_array_of_spikes = cell(1,size(cluster_spikes,2));
cell_array_of_spikes_by_wire = cell(1,size(cluster_spikes,1));
array_of_bursts = zeros(1,size(cluster_spikes,1));
for current_wire=1:size(cluster_spikes,1)
    for i=1:length(cell_array_of_spikes)
        cell_array_of_spikes{i} =squeeze(cluster_spikes(current_wire,i,:)).';
    end
    for i=1:length(cluster_ts)-1
        current_ts = cluster_ts(i); %the timestamp of the beginning if current spike (in seconds)
        next_ts = cluster_ts(i+1);  %the timestamp of the beginning of the next spike (in seconds)
        current_spike_voltages = cell_array_of_spikes{i}; %voltages of the current spike on the current wire (y_values)
        next_spike_voltages = cell_array_of_spikes{i+1}; %voltages of the next spike on the current wire (y_values)
        if next_ts - (current_ts+0.002) <0 % check if the beginning of the next spike begins within 0.002 seconds of the beginning of the current spike, which indicates that the next spike started before the current spike ends, an indicator of bursting 
            voltages_in_common_between_current_and_next_spike = intersect(current_spike_voltages,next_spike_voltages); %find the voltages in common
            filtered_next_spike_voltages = setdiff(next_spike_voltages,voltages_in_common_between_current_and_next_spike,"stable"); %remove any voltages from next spike which it has in common with current spike
            array_of_bursts(current_wire) = array_of_bursts(current_wire)+1; %increment the number of bursts you found
            cell_array_of_spikes{i} =current_spike_voltages * 1000; %set the current spike to its value
            cell_array_of_spikes{i+1} = filtered_next_spike_voltages; %update the next spike which now has the overlap removed

        else %indicates the spkes are happening sequentially and thus not bursting
            %calculate the number of datapoints between the last spike and
            %the next timestamp so you can fill that space with zeros

            voltages_between_current_ts_and_next_ts = zeros(1,length(current_ts:distance_between_dpts:next_ts));
            padded_current_spike_voltages = [current_spike_voltages,voltages_between_current_ts_and_next_ts];
            cell_array_of_spikes{i} = padded_current_spike_voltages;
            cell_array_of_spikes{i+1} = next_spike_voltages;
        end
    end
    cell_array_of_spikes_by_wire{current_wire} = [cell_array_of_spikes{:}];
end



likelihood_of_burst = array_of_bursts(1) / size(cluster_spikes,2);
if debug
    for i=1:size(cluster_spikes,1)
        figure;
        plot(1:length(cell_array_of_spikes_by_wire{i}),cell_array_of_spikes_by_wire{i});
    end

end
close all;




end