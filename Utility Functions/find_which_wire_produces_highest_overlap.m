function [array_of_overlap] = find_which_wire_produces_highest_overlap(tetrode_to_check,gt_data,dir_with_og_recording,art_tetr_array,num_dpts_inf_and_beh,debug)
%import channel data
channels_of_array = art_tetr_array(str2double(strrep(tetrode_to_check,"t","")),:);
channel_data = import_channel_data_for_specified_tetrode(channels_of_array,dir_with_og_recording);


array_of_overlap = nan(1,length(channels_of_array));
%now for each wire see what the overlap percentage is with the unit
for i=1:length(channel_data)
    on_both_wire_and_gt = 0; %record every time the offset matches 
    %for each spike in gt_data find it's offset with the current wire
    for gt_spike_counter=1:length(gt_data)
        beginning_index = gt_data(gt_spike_counter)-num_dpts_inf_and_beh;
        ending_index = gt_data(gt_spike_counter)+num_dpts_inf_and_beh;
        if beginning_index < 1
            beginning_index =1;
        end
        if ending_index > length(channel_data{i})
            ending_index = length(channel_data{i});
        end
        [~,pk_locations] = findpeaks(channel_data{i}(beginning_index:ending_index));
        normalized_pk_locations = double(pk_locations)+(double(beginning_index)-1);
        [~,mx_pk] = max(channel_data{i}(normalized_pk_locations));
        offset_from_wire = gt_data(gt_spike_counter) - normalized_pk_locations(mx_pk);

        if debug
            figure;
            plot(beginning_index:ending_index,channel_data{i}(beginning_index:ending_index));
            hold on;
            scatter(normalized_pk_locations(mx_pk),channel_data{i}(normalized_pk_locations(mx_pk)),'r','filled','o');
            xline(gt_data(gt_spike_counter))
            legend("Wire"+string(channels_of_array(i)),"GT Location","Actual Peak")
            title("Offset:"+string(offset_from_wire));
            close all;
        end
        if abs(offset_from_wire) < 3
            on_both_wire_and_gt = on_both_wire_and_gt+1;
        end
    end
    
    array_of_overlap(i) = on_both_wire_and_gt / length(gt_data);
end
x_values = strcat("Channel ",string(channels_of_array));
y_values = "overlap";
heatmap(x_values,y_values,array_of_overlap);

end