function [] = save_spike_sample_plots(fig_obj,beginning_ts,ending_ts,spike_number,dir_to_save_figs_to,channel_number)
file_name = dir_to_save_figs_to+"\Ch "+string(channel_number)+ " Sp "+string(spike_number)+ " TS "+ strrep(string(beginning_ts),".","_") +" "+ strrep(string(ending_ts),".","_")+".svg";
saveas(fig_obj,file_name)
end