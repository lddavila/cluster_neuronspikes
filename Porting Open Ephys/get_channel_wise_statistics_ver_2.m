function [channel_wise_mean,channel_wise_std] = get_channel_wise_statistics_ver_2(ordered_list_of_channels,dir_with_channel_data,dir_with_mask_indexes,dir_to_save_z_score_files_to, save_z_score)
%assumes that the data is alredy inverted and thus performs no inversions
%also assumes that the data is in microvolts, 
%here
z_score_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_z_score_files_to);
channel_wise_mean = zeros(1,length(ordered_list_of_channels));
channel_wise_std = zeros(1,length(ordered_list_of_channels));
 
for i=1:length(ordered_list_of_channels)
    current_channel = ordered_list_of_channels(i);
    current_file = fullfile(dir_with_channel_data,current_channel+".mat");
    channel_data = importdata(current_file);
    channel_mask = importdata(dir_with_mask_indexes+"\"+current_channel+" Original Indexes.mat");
    channel_mask(channel_mask==0) = [];
    channel_wise_mean(i) = mean(channel_data(channel_mask));
    channel_wise_std(i) = std(channel_data(channel_mask),0,"all");

    if save_z_score
        channel_wise_z_score_data = zscore(double(channel_data));
        save(z_score_dir+"\"+current_channel+".mat","channel_wise_z_score_data",'-mat')
    end
    disp("Finished "+string(i) + "/"+string(length(ordered_list_of_channels)) )
end
end