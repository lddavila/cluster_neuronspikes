function [spike_windows] = get_spike_windows(channel_wise_z_score,spikes_per_channel,desired_z_score,desired_number_of_data_points)
spike_windows = cell(1,size(channel_wise_z_score,2));
for i=1:size(channel_wise_z_score,2)
    spike_windows{i} = cell(size(spikes_per_channel,1),1);
    for j=1:size(spikes_per_channel{i},1)
        channel_i_peak_j = spikes_per_channel{i}(j); %get the current peak
        channel_i_peak_j_z_score = channel_wise_z_score(channel_i_peak_j,i); %get the z_score for current spike
        if channel_i_peak_j < fix(desired_number_of_data_points/2) || channel_i_peak_j+fix(desired_number_of_data_points/2) > size(channel_wise_z_score,1) %round towards zero
            %if peak is too early or too late don't use it
            continue;
        else
            if abs(channel_i_peak_j_z_score) >= desired_z_score 
                if channel_i_peak_j - fix(desired_number_of_data_points/2) ~= 0 && channel_i_peak_j + fix(desired_number_of_data_points/2) <= size(channel_wise_z_score,1)
                    spike_windows{i}{j} = [channel_i_peak_j - fix(desired_number_of_data_points/2),...
                        channel_i_peak_j + fix(desired_number_of_data_points/2),...
                        i,...
                        channel_i_peak_j];
                else
                    continue;
                end
                %each  is made up of 4 numbers:
                %the first is the beginning of the spike window
                %the second is the end of the spike_window
                %the third is the original channel of the spike
                %the fourth is the original the peak of the spike according to 

            else
                spike_windows{i}{j} = [NaN,NaN,NaN,NaN];
            end


        end

    end
end
end