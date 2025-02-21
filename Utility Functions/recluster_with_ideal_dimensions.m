function [] = recluster_with_ideal_dimensions(table_of_overlapping_clusters,load_previous_attempt,save_current_attempt,dir_to_save_data_to,version_name,generic_dir_with_grades,generic_dir_with_outputs,precomputed_dir,min_improvement,number_of_channels_in_new_config,num_dps,dir_with_chan_recordings,timestamps,scale_factor,channel_wise_means,channel_wise_std,min_threshold,refined_pass,min_amp,parent_dir)
if ~exist(dir_to_save_data_to+"\"+version_name,'dir')
    mkdir(dir_to_save_data_to+"\"+version_name);
end
%first combine the lists of overlapping clusters to ensure that you have 1
%comprehensive list per unit (ideally)
load_previous_attempt=true;
if ~load_previous_attempt
    united_list_of_overlap = unite_overlap_data(table_of_overlapping_clusters);
    if save_current_attempt
        save(dir_to_save_data_to+"\"+version_name+"\united_lists_of_overlap.mat","united_list_of_overlap");
    end
else
    load("D:\cluster_neuronspikes\Second Pass Data\1 Channels\0_100Neuron300SecondRecordingWithLevel3Noise\united_lists_of_overlap.mat","united_list_of_overlap");
end
%disp(united_list_of_overlap);
load_previous_attempt=true;
%now for each item in the united list we wish to identify sorted list of
%channel amplitudes
%load_previous_attempt = false;
if ~load_previous_attempt
    list_of_channels_sorted_by_amp = get_lists_of_channels_sorted_by_amplitude(united_list_of_overlap,generic_dir_with_grades,generic_dir_with_outputs,refined_pass);
    if save_current_attempt
        save(dir_to_save_data_to+"\"+version_name+"\list_of_channels_sorted_by_amplitude.mat","list_of_channels_sorted_by_amp");
    end
else
    load("D:\cluster_neuronspikes\Second Pass Data\3 Channels\0_100Neuron300SecondRecordingWithLevel3Noise\list_of_channels_sorted_by_amplitude.mat","list_of_channels_sorted_by_amp");
end

%now recluster based on channels with highest amplitude
%you can run more configurations, but the most basic will always be the
%channels with the highest 4 amplitudes
load_previous_attempt = false;
run_reclustering_with_new_dimensions(list_of_channels_sorted_by_amp,1,min_improvement,number_of_channels_in_new_config,precomputed_dir,num_dps,dir_with_chan_recordings,timestamps,scale_factor,channel_wise_means,channel_wise_std,min_threshold,min_amp,parent_dir);

end