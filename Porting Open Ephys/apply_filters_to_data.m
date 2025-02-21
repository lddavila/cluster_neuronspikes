function [] = apply_filters_to_data(dir_with_raw_recordings,dir_to_save_filtered_data_to,filters_to_apply,ordered_list_of_channels,channel_wise_mean,channel_wise_std,plot_before_and_after)
time_delta = 1/30000;
if ~exist(dir_to_save_filtered_data_to,"dir")
    dir_to_save_filtered_data_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_filtered_data_to);
end
beginning_time = 1*time_delta;

sample_rate = 30000;

[b,a] = butter(2,[300 5000]/sample_rate);
for i=1:length(ordered_list_of_channels)
    current_channel_data = importdata(dir_with_raw_recordings+"\"+ordered_list_of_channels(i)+".mat");
    current_channel_z_score_data = zscore(current_channel_data);
    ending_time = size(current_channel_data,2) * time_delta;
    timestamps = linspace(beginning_time,ending_time,size(current_channel_data,2));
    if plot_before_and_after
        figure;
        plot(current_channel_data)
        title("Channel "+string(i) + " Before ANY filtering")
        figure;
        plot(current_channel_z_score_data);
        title("Z Scores")
    end

    for j=1:length(filters_to_apply)
        current_filter= filters_to_apply(j);
        switch current_filter
            case "average"
                beginning_channels = i-7;
                ending_channels = i+7;
                if beginning_channels < 1
                    beginning_channels = 1;
                end
                if ending_channels > length(filters_to_apply)
                    ending_channels = length(ordered_list_of_channels);
                end

                mean_of_neighboring_channels = mean(channel_wise_mean(beginning_channels:ending_channels));
                filtered_data = current_channel_data - mean_of_neighboring_channels;

                if plot_before_and_after
                    figure;
                    plot(filtered_data)
                    title("Channel "+string(i) + " After average filtering")
                end
            case "butterworth"
                filtered_data = filter(b,a,filtered_data);
                if plot_before_and_after
                    figure;
                    plot(filtered_data)
                    title("Channel "+string(i) + " After 2nd order butterworth filtering")
                end
            

        end
        


    end
    close all;
    disp("apply_filtered_to_data.m Finished "+string(i)+"/"+string(length(ordered_list_of_channels)));
    final_save_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_filtered_data_to+"\"+strjoin(filters_to_apply));
    save(final_save_dir+"\"+ordered_list_of_channels(i)+".mat","filtered_data");
end

end
