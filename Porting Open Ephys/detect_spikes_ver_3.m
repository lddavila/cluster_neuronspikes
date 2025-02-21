function [spikes_matrix] = detect_spikes_ver_3(ordered_list_of_channels,dir_with_channel_recordings,dir_with_masks)
%it should come in inverted and leave inverted
spikes_matrix = cell(1,length(ordered_list_of_channels));

for i=1:length(ordered_list_of_channels)
    current_channel = ordered_list_of_channels(i);
    channel_data = importdata(dir_with_channel_recordings+"\"+current_channel+".mat");
    current_channel_masks = importdata(dir_with_masks+"\"+current_channel+" Original Indexes.mat");
    channel_data = double(channel_data);
    
    [pk_vals,pk_locs] = findpeaks(channel_data,'MinPeakHeight',40);

    % non_noise_spikes = pk_vals > 50;
    % all_noise_spikes = pk_vals < 50;
    % indexes_of_first_thousand_noise_spikes = find(all_noise_spikes,ceil(length(non_noise_spikes)*1.5));
    % indexes_for_all_noise_spikes = 1:length(all_noise_spikes);
    % 
    % 
    % 
    % 
    % 
    % all_noise_spikes(setdiff(indexes_for_all_noise_spikes,indexes_of_first_thousand_noise_spikes)) = false;
    % 
    % 
    % 
    % 
    % final_pks = all_noise_spikes | non_noise_spikes;
    % 
    % pk_locs(~final_pks) = nan;
    pk_locs(isnan(pk_locs)) = [];
    
    spikes_matrix{i} = pk_locs(ismember(pk_locs,current_channel_masks));
    disp("Finished detect_spikes_ver_3.mat " + string(i)+"/"+string(length(ordered_list_of_channels)));
end
end