function [rows_to_use,table_of_ideal_dimensions] = find_ideal_dimensions(current_table_of_channels,min_improvement,number_of_channels_to_use,min_amp)
channel_counter =1;
rows_to_use = nan(1,number_of_channels_to_use);
starting_channel_index =1;
%consecutive_ranges = nan(number_of_channels_to_use,2);
consecutive_ranges = [];
all_consecutive_ranges_found = false;
while ~all_consecutive_ranges_found
    %start by identifying the rows in current_table_of_channels where the
    %first n (number_of_channels_to_use) repeat consecutively
    %it's important to know that a channel might appear in the table non
    %consecutively and we only want to select its first set of consecutive
    %appearences
    for beginning_of_appearences_pointer=starting_channel_index:size(current_table_of_channels,1)
        current_channel = current_table_of_channels{beginning_of_appearences_pointer,"channel"};
        %now id the first time the channel changes
        end_of_consecutive_current_channel_appearences = false;
        for end_of_appearences_pointer=beginning_of_appearences_pointer+1:size(current_table_of_channels,1)
            secondary_channel = current_table_of_channels{end_of_appearences_pointer,"channel"};
            if end_of_appearences_pointer==size(current_table_of_channels,1)
                consecutive_ranges = [consecutive_ranges;[beginning_of_appearences_pointer,size(current_table_of_channels,1)]];
                all_consecutive_ranges_found = true;
                break;
            end
            if secondary_channel ~= current_channel
                consecutive_ranges = [consecutive_ranges;[beginning_of_appearences_pointer,end_of_appearences_pointer-1]];
                channel_counter = channel_counter+1;
                starting_channel_index = end_of_appearences_pointer;
                end_of_consecutive_current_channel_appearences=true;
                
                break;
            end

        end
        if end_of_consecutive_current_channel_appearences || all_consecutive_ranges_found
            break;
        end
    end
end
%with the needed indexes found we can now select the "best" among them to
%defining best and the lowest z score where the imporvement of SNR is less
%than the min_improvement definition
%this indicates a leveling out of SNR
%and continuing to increase will only provide very marginal benefits
index_in_rows_to_use =1;
all_found = false;
already_used_channels = [];
%min_amp =40;
for i=1:size(consecutive_ranges,1)
    original_row_idx_in_current_table_of_channels = consecutive_ranges(i,1):consecutive_ranges(i,2);
    table_of_current_channel = current_table_of_channels(original_row_idx_in_current_table_of_channels,:);
    table_of_current_channel.("og idx") = original_row_idx_in_current_table_of_channels.';
    table_of_current_channel = sortrows(table_of_current_channel,["z-score","mean"],"ascend");
    min_improvement_threshold_met = false;
    for j=1:size(table_of_current_channel,1)-1
        if mean(table_of_current_channel{:,"mean"}) < min_amp
            continue;
        end
        current_z_score = table_of_current_channel{j,"z-score"};
        next_z_score = table_of_current_channel{j+1,"z-score"};
        
        %in the case of the same z-score across different tetrodes you have
        %to pick the min SNR between them, then pick the next SNR that has
        %a different z-score
        if current_z_score == next_z_score
            %find where the consecutive repititons of this z score stop 
            number_of_consecutive_z_scores = 1;
            for p=j+1:size(table_of_current_channel,1)
                if table_of_current_channel{p,"z-score"} == current_z_score
                    number_of_consecutive_z_scores = number_of_consecutive_z_scores+1;
                else
                    break
                end
            end
            [~,current_SNR] = min(table_of_current_channel{j:j+number_of_consecutive_z_scores-1,"SNR"});
            next_index = j+number_of_consecutive_z_scores; 
            if next_index > size(table_of_current_channel,1)
                %in this case the table ends with n consecutive z scores
                %but the fact that you're at the end of the table means
                %that you no longer have higher z scores to check for a
                %leveling out of z score improvement
                %thus this particular channel should not be used
                continue;
            end
            j = j+number_of_consecutive_z_scores-1;
        else
            current_SNR = table_of_current_channel{j,"SNR"};
            next_index = j+1;
        end
        %find the min SNR among these repitions 
        %disp([i,j])
        next_SNR = table_of_current_channel{next_index,"SNR"};
        improvement = next_SNR - current_SNR;
        if improvement < min_improvement && next_SNR>current_SNR
            if index_in_rows_to_use==length(rows_to_use)+1
                all_found = true;
                break;
            end
            if ~ismember(table_of_current_channel{j,"channel"},already_used_channels)
            rows_to_use(index_in_rows_to_use) = table_of_current_channel{j,"og idx"};
            already_used_channels = [already_used_channels,table_of_current_channel{j,"channel"}];
            index_in_rows_to_use = index_in_rows_to_use+1;
            min_improvement_threshold_met=true;
            break;

            end
        end

    end
    if all_found
        break;
    end


end
rows_to_use(isnan(rows_to_use)) = []; %if you dont find enough dimensions that reach that min improvement threshold then you simply let it go through with fewer dimensions
table_of_ideal_dimensions = current_table_of_channels(rows_to_use,:);
table_of_ideal_dimensions.("og idx") = rows_to_use.';
end