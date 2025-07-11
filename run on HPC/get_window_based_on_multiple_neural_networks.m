function [all_window_beginning,all_window_end] = get_window_based_on_multiple_neural_networks(blind_pass_table,neural_networks_array,presorted_table,cluster_size_col,mean_waveform_array,grades_array,config)

all_window_beginning = nan(size(blind_pass_table,1),1);
all_window_end = nan(size(blind_pass_table,1),1);


parfor i=1:size(blind_pass_table,1)
    %for every sample in the blind_pass_table we must try to minimize the window where its true accuracy might exist
    beginning_time = tic;
    [all_window_beginning(i),all_window_end(i)]= run_all_neural_networks(neural_networks_array,presorted_table,i,blind_pass_table,cluster_size_col,mean_waveform_array,grades_array,config);
    end_time = toc(beginning_time);
    
    print_status_iter_message("get_window_based_on_multiple_neural_networks.m",i,size(blind_pass_table,1));
    % disp([all_window_beginning(i),all_window_end(i)]);
    disp("It Took "+string(end_time)+" Seconds");
end

end