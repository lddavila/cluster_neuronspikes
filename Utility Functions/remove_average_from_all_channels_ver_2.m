function [recording_matrix_with_mean_removed] = remove_average_from_all_channels_ver_2(dir_with_channel_data,ordered_list_of_channels,channel_wise_means,dir_to_save_recordings_with_averagesremoved)
    recording_matrix_with_mean_removed = recording_matrix - channel_wise_means;
end