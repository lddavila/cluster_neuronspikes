function [recording_matrix_with_mean_removed] = remove_average_from_all_channels(recording_matrix,channel_wise_means)
    recording_matrix_with_mean_removed = recording_matrix - channel_wise_means;
end