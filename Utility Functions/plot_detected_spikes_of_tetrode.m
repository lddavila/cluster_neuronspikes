function [] = plot_detected_spikes_of_tetrode(list_of_tetrodes,number_of_spikes_to_plot,spike_tetrode_dictionary,timing_tetrode_dictionary,tetrode_dictionary,spiking_channel_tetrode_dictionary,dir_to_save_figs_to)

dir_to_save_figs_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_figs_to);
for i=1:length(list_of_tetrodes)
    current_tetrode_data = spike_tetrode_dictionary(list_of_tetrodes(i));
    current_timing_data = timing_tetrode_dictionary(list_of_tetrodes(i));
    current_channels = tetrode_dictionary(list_of_tetrodes(i));
    current_spiking_channel = spiking_channel_tetrode_dictionary(list_of_tetrodes(i));
    for j=1:number_of_spikes_to_plot
        figure;
        for current_channel=1:size(current_tetrode_data,1)
            subplot(1,size(current_tetrode_data,1),current_channel);
            plot(current_timing_data(j,:),squeeze(current_tetrode_data(current_channel,j,:)));
            xlabel("Time");
            ylabel("Voltage");
            if current_channels(current_channel)==current_spiking_channel{j}
                 title("Channel "+string(current_channels(current_channel)) + " (Spiking)")
            else
                title("Channel "+string(current_channels(current_channel)))
            end
        end
        sgtitle(list_of_tetrodes(i) +" Number of DPS "+ string(size(current_tetrode_data,3)))
        figure_name = list_of_tetrodes(i) + " Spike Number " + string(j);
        savefig(dir_to_save_figs_to+"\"+figure_name)
        %close all;
    end
end
end
