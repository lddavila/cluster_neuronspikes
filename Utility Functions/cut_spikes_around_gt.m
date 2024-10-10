function [data_cuts] = cut_spikes_around_gt(ordered_list_of_channels,array_of_ground_truth,min_z_score,channel_recording_dir,number_dps)

data_cuts = zeros(length(ordered_list_of_channels),length(array_of_ground_truth),number_dps);
for i=1:length(ordered_list_of_channels)
    current_channel_data = importdata(channel_recording_dir+"\"+ordered_list_of_channels(i)+".mat");
    for j=1:length(array_of_ground_truth)
        current_peak = array_of_ground_truth(j);
        if current_peak - number_dps/2 < 1
            beginning_of_window = 1;
        else
            beginning_of_window = current_peak - number_dps/2; 
        end
        if current_peak + number_dps/2 > length(current_channel_data)
            end_of_window = length(current_channel_data);
        else
            end_of_window = current_peak+number_dps/2;
        end
        data_cuts(i,j,:) = current_channel_data(beginning_of_window:end_of_window-1);
    end

end

end