function [] = run_second_pass_of_clustering(dir_with_initial_pass_results,list_of_initial_tetrodes,number_of_channels_to_add,scale_factor,dir_with_channel_recordings,min_z_score,min_threshold,num_dps,timestamps_dir,precomputed_dir,pass_number)
art_tetr_array = build_artificial_tetrode;
for i=1:length(list_of_initial_tetrodes)
    current_tetrode = list_of_initial_tetrodes(i);
    channels_in_current_tetrode = art_tetr_array(str2double(erase(current_tetrode,"t")),:);
    neighbors_of_current_tetrode = find_valid_neighbors(channels_in_current_tetrode);
    run_second_stage_of_clustering_ver2(dir_with_initial_pass_results,neighbors_of_current_tetrode,channels_in_current_tetrode,current_tetrode,dir_with_channel_recordings,scale_factor,min_z_score,num_dps,timestamps_dir,precomputed_dir,min_threshold,number_of_channels_to_add,pass_number)
end
end