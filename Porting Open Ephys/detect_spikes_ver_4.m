function [spikes_matrix] = detect_spikes_ver_4(ordered_list_of_channels,dir_with_channel_recordings,dir_with_masks,min_z_score,timestamps,time_interval)
%both timestamps and time interval should be in seconds
%it should come in inverted and leave inverted
spikes_matrix = cell(1,length(ordered_list_of_channels));

number_of_iterations_to_do = ceil(timestamps(end) / time_interval); % how many intervals you will divide the data into
number_of_dpts_per_iterations = ceil(length(timestamps) / number_of_iterations_to_do);


for i=1:length(ordered_list_of_channels)

    current_channel = ordered_list_of_channels(i);
    channel_data = importdata(dir_with_channel_recordings+"\"+current_channel+".mat");
    current_channel_masks = importdata(dir_with_masks+"\"+current_channel+" Original Indexes.mat");
    channel_data = double(channel_data);
    channel_data(current_channel_masks==0) = NaN;
    [~,pk_locs] = findpeaks(channel_data,'MinPeakHeight',40);
    current_channel_peaks = nan(1,10000000); % pre allocated for speed, can be increased in size if more is required
    place_to_begin_saving = 1;
    for j=1:number_of_iterations_to_do
        beginning_index = (number_of_dpts_per_iterations * (j-1))+1;
        ending_index = number_of_dpts_per_iterations * (j);
        if ending_index > length(timestamps)
            ending_index = length(timestamps);
        end
        current_interval = beginning_index:ending_index;
        pk_locations_of_current_interval = pk_locs(ismember(pk_locs,current_interval));
        channel_maks_of_current_interval= current_channel_masks(current_interval);

        z_scores_of_peaks_in_current_interval = zscore(pk_locations_of_current_interval);
       
        pk_locations_of_current_interval = pk_locations_of_current_interval(z_scores_of_peaks_in_current_interval > min_z_score);
        pk_locs(isnan(pk_locs)) = [];
        if j==1
            current_channel_peaks(1:length(pk_locations_of_current_interval)) = pk_locations_of_current_interval;
            place_to_begin_saving = place_to_begin_saving +length(pk_locations_of_current_interval(ismember(pk_locations_of_current_interval,channel_maks_of_current_interval)));
        else
            current_channel_peaks(place_to_begin_saving:place_to_begin_saving-1+length(pk_locations_of_current_interval)) = pk_locations_of_current_interval;
            place_to_begin_saving = place_to_begin_saving +length(pk_locations_of_current_interval(ismember(pk_locations_of_current_interval,channel_maks_of_current_interval)));
   
        end
        fprintf("Wire %i Finished iteration %i out of %i \n",i,j,number_of_iterations_to_do);
    end

    current_channel_peaks(isnan(current_channel_peaks)) = [];

    spikes_matrix{str2double(strrep(current_channel,"c",""))} = current_channel_peaks;
    disp("Finished detect_spikes_ver_4.mat " + string(i)+"/"+string(length(ordered_list_of_channels)));
end
end