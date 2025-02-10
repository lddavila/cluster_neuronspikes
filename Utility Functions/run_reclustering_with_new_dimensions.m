function [] = run_reclustering_with_new_dimensions(list_of_channels_sorted_by_amplitude,how_many_configs_to_do,min_improvement,number_of_channels_to_use,precomputed_dir,num_dps,dir_with_chan_recordings,timestamps,scale_factor,channel_wise_means,channel_wise_std,min_threshold,min_amp,parent_dir)
upper_bound_of_channels = number_of_channels_to_use;
i=1;
while i<=length(list_of_channels_sorted_by_amplitude)
    current_table_of_channels = list_of_channels_sorted_by_amplitude{i};
    if ~isempty(current_table_of_channels)
        %[~,table_of_ideal_dimension]= find_ideal_dimensions(current_table_of_channels,min_improvement,number_of_channels_to_use,min_amp);
        [~,table_of_ideal_dimension]= find_ideal_dimensions_ver_2(current_table_of_channels,min_improvement,min_amp);
    else
        disp("Refined Tetrode "+string(i)+ " Has nothing In it Skipping ...")
        i=i+1;
        continue;
    end
    disp("Cluster "+string(i) + " has " + string(size(table_of_ideal_dimension,1))+ " Good Dimensions with minimum amp:"+string(min_amp) )
    if size(table_of_ideal_dimension,1)==0 
        % disp("Refinement t"+string(i)+ " has no good channels, Skipping ...")
        i=i+1;
        continue;
    end
    if size(table_of_ideal_dimension,1)==1
        % disp("Refinement t"+string(i)+ " has only 1 good channel, Skipping ...")
        i=i+1;
        continue;
    end
    default_channels_to_use = 4;
    ending_index = default_channels_to_use;
    if size(table_of_ideal_dimension,1) < default_channels_to_use
        %disp("Refinement t"+string(i)+ " doesn't have enough channels, Skipping ...")
        ending_index = size(table_of_ideal_dimension,1);
        
    end
    
    
    dictionary_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(precomputed_dir+"\TEST refined spikes Top "+string(default_channels_to_use)+"Channles Used Min Amp "+string(min_amp));
    run_clustering_algorithm_on_refined_tetrodes(table_of_ideal_dimension(1:ending_index,:),precomputed_dir,num_dps,dictionary_dir,dir_with_chan_recordings,timestamps,scale_factor,i,channel_wise_means,channel_wise_std,min_threshold,min_amp);
    [warnMsg, ~] = lastwarn('');
    if ~isempty(warnMsg)
        disp("Refined Tetrode t"+string(i)+ " Threw A Warning with Top " +string(size(table_of_ideal_dimension,1))+" Dimensions ...")

        % number_of_channels_to_use = size(table_of_ideal_dimension,1)-1;
        % if number_of_channels_to_use ==1
        %     disp("Refined Tetrode t"+string(i)+ " Doesn't have enough dimensions for reclustering ... skipping")
        %     i=i+1;
        % end
        % disp("Running Again With Top "+string(size(table_of_ideal_dimension,1)-1)+" Dimensions");
        i=i+1;
        continue;
    end
    % disp("Reclustering Finished "+string(i)+"/"+string(length(list_of_channels_sorted_by_amplitude)) + " Used "+string(size(table_of_ideal_dimension,1))+" Channels")
    number_of_channels_to_use = upper_bound_of_channels;
    i=i+1;
end
end