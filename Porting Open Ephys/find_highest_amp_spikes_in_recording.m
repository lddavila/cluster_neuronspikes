function [sorted_table] = find_highest_amp_spikes_in_recording(spike_windows,dir_with_channel_recordings,list_of_channels)
    function [num_rows_to_preallocate] = find_number_of_rows_to_preallocate(spike_windows)
        num_rows_to_preallocate = 0;
        for k=1:size(spike_windows,2)
            num_rows_to_preallocate = num_rows_to_preallocate+(size(spike_windows{k},2));
        end
    end
time_delta = 1/30000;
number_of_preallocated_rows = find_number_of_rows_to_preallocate(spike_windows);
table_to_sort_by = table(nan(number_of_preallocated_rows,1),nan(number_of_preallocated_rows,1),nan(number_of_preallocated_rows,1),cell(number_of_preallocated_rows,1),cell(number_of_preallocated_rows,1),'VariableNames',["Channel","Amplitude","Spike_idx","Waveform","Timestamps"]);
table_row_counter = 1;
for i=1:length(list_of_channels)
    channel_number = str2double(strrep(list_of_channels(i),"c",""));
    current_spike_data = spike_windows{channel_number};%index the for the current channel
    current_channel_data = importdata(dir_with_channel_recordings+"\"+list_of_channels(i)+".mat");
    for j=1:size(current_spike_data,2)%modify this for apprpriate size of current spike data

        current_spike_indexes = current_spike_data{j};

        beginning_index = current_spike_indexes(1);
        beginning_time = time_delta * double(beginning_index);
   

        ending_index = current_spike_indexes(2);
        ending_time_of_spike = time_delta * double(ending_index);

        channel = current_spike_indexes(3);
        peake_location = current_spike_indexes(4);

        if isnan(beginning_index) || isnan(ending_index)
            continue;
        end


        current_spike_amplitudes =current_channel_data(beginning_index:ending_index) ;
        
        ts = linspace(beginning_time,ending_time_of_spike,size(current_spike_amplitudes,2));


        %,["Channel","Amplitude","Spike_idx","Waveform","Timestamps"]
        table_to_sort_by{table_row_counter,"Channel"} = channel;
        table_to_sort_by{table_row_counter,"Amplitude"} = current_channel_data(peake_location);
        table_to_sort_by{table_row_counter,"Spike_Idx"} = peake_location;
        table_to_sort_by{table_row_counter,"Waveform"} = {current_spike_amplitudes};
        table_to_sort_by{table_row_counter,"Timestamps"} = {ts};
        table_row_counter = table_row_counter+1;
        disp("find_highest_amp_spikes_in_recording.m Finished "+string(table_row_counter)+"/"+string(size(table_to_sort_by,1)))
    end



end
sorted_table = sortrows(table_to_sort_by,"Amplitude");




end