function [] = save_open_ehys_data_by_channel(continuous_recording_object,dir_to_save_samples_to,bit_volts)
    if ~exist(dir_to_save_samples_to,"dir")
        dir_to_save_samples_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_samples_to);
    end
    for i=1:continuous_recording_object.metadata.numChannels
        current_samples_data = continuous_recording_object.samples(i,:);
        current_samples_data = double(current_samples_data);
        current_samples_data = current_samples_data*bit_volts(i);
        save(dir_to_save_samples_to+"\c"+string(i)+".mat",'current_samples_data')
        disp("save_open_ephys_Data_by_channel.m Finished "+string(i)+"/"+string(continuous_recording_object.metadata.numChannels))
    end
end