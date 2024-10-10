function [peaks_per_channel] = run_find_peaks_on_every_channel(dir_with_channel_data,ordered_list_of_channels,peaks_already_found,dir_with_peaks_per_channel)
peaks_per_channel = cell(1,length(ordered_list_of_channels));
if peaks_already_found
    peaks_per_channel = importdata(dir_with_peaks_per_channel+"\peaks_per_channel.mat");
    return;
end
for i=1:length(ordered_list_of_channels)
    current_channel = ordered_list_of_channels(i);
    current_channel_data = importdata(dir_with_channel_data+"\"+current_channel+".mat");
    current_channel_data = current_channel_data * -1;
    [~,locs] = findpeaks(current_channel_data,'MinPeakHeight',5);
    peaks_per_channel{i} = locs;
    disp("Finished "+string(i)+"/"+string(length(ordered_list_of_channels)));
end
if ~peaks_already_found
    dir_with_peaks_per_channel = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_with_peaks_per_channel);
    save(dir_with_peaks_per_channel+"\peaks_per_channel.mat","peaks_per_channel");
end
end
