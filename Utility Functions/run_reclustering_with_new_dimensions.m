function [] = run_reclustering_with_new_dimensions(list_of_channels_sorted_by_amplitude,how_many_configs_to_do,min_improvement,number_of_channels_to_use,precomputed_dir,num_dps,dir_with_chan_recordings,timestamps,scale_factor,channel_wise_means,channel_wise_std,min_threshold)
upper_bound_of_channels = number_of_channels_to_use;
i=14;
while i<=length(list_of_channels_sorted_by_amplitude)
    current_table_of_channels = list_of_channels_sorted_by_amplitude{i};
    if ~isempty(current_table_of_channels)
        [~,table_of_ideal_dimension]= find_ideal_dimensions(current_table_of_channels,min_improvement,number_of_channels_to_use);
    else
        disp("Refined Tetrode "+string(i)+ " Has nothing In it Skipping ...")
        i=i+1;
        continue;
    end
    if size(table_of_ideal_dimension,1)==0
        disp("Refinement t"+string(i)+ " has no good channels, Skipping ...")
        i=i+1;
        continue;
    end
    dictionary_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\refined spikes Top "+string(number_of_channels_to_use)+"Channles Used");
    run_clustering_algorithm_on_refined_tetrodes(table_of_ideal_dimension,precomputed_dir,num_dps,dictionary_dir,dir_with_chan_recordings,timestamps,scale_factor,i,channel_wise_means,channel_wise_std,min_threshold)
    [warnMsg, ~] = lastwarn('');
    if ~isempty(warnMsg)
        disp("Refined Tetrode t"+string(i)+ " Threw A Warning with " +string(size(table_of_ideal_dimension,1))+" Dimensions")
        disp("Running Again With "+string(size(table_of_ideal_dimension,1)-1)+" Dimensions");
        number_of_channels_to_use = size(table_of_ideal_dimension,1)-1;
        continue;
    end
    disp("Reclustering Finished "+string(i)+"/"+string(length(list_of_channels_sorted_by_amplitude)) + " Used "+string(size(table_of_ideal_dimension,1))+" Channels")
    number_of_channels_to_use = upper_bound_of_channels;
    i=i+1;
end
end