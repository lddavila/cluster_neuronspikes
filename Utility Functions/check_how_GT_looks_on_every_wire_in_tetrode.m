function [] = check_how_GT_looks_on_every_wire_in_tetrode(tetrode_to_check,art_tetr_array,dir_with_og_recordings,ground_truth,ground_truth_modifier,num_dpts_bef_aft_spike)
channels_of_current_tetr = art_tetr_array(str2double(strrep(tetrode_to_check,"t","")),:);
ground_truth = ground_truth + ground_truth_modifier;
%import the channel_data
array_of_channel_data = cell(1,length(channels_of_current_tetr));
for i=1:length(channels_of_current_tetr)
    array_of_channel_data{i} = importdata(dir_with_og_recordings+"\c"+string(channels_of_current_tetr(i)+".mat"));
    array_of_channel_data{i} = array_of_channel_data{i} *-1;
end
for i=1:length(ground_truth)
    figure;
    legend_string = repelem("",1,length(channels_of_current_tetr)*2);
    for j=1:length(channels_of_current_tetr)
        beginning_index = ground_truth(i) - num_dpts_bef_aft_spike;
        ending_index  = ground_truth(i) + num_dpts_bef_aft_spike;
        if beginning_index < 0
            beginning_index = 1;
        end
        if ending_index > length(array_of_channel_data{j})
            ending_index = length(array_of_channel_data);
        end
        plot(beginning_index:ending_index,array_of_channel_data{j}(beginning_index:ending_index));
         hold on;
        [~,pk_location] = findpeaks(array_of_channel_data{j}(beginning_index:ending_index));

        updated_pk_location = double(pk_location) + (double(beginning_index)-1);
        [~, index_of_max_peak] = max(array_of_channel_data{j}(updated_pk_location));
        %scatter(updated_pk_location,array_of_channel_data{j}(updated_pk_location));
        scatter(updated_pk_location(index_of_max_peak),array_of_channel_data{j}(updated_pk_location(index_of_max_peak)),'r')
        offset_from_gt = double(ground_truth(i)) - double(updated_pk_location(index_of_max_peak));
       
        legend_string(j+(j-1)) = "c"+string(channels_of_current_tetr(j) + " Offset From GT"+ string(offset_from_gt));
        legend_string(j+j) = "Max Peak In Interval";
    end
    legend(legend_string);
    xline(ground_truth(i),'-',{'GT Real Location'});
    close all;
   
end
end