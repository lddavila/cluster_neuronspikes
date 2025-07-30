clc;
copy_channels_command =sprintf("%s",'scp "D:\spike_gen_data\Recordings By Channel\0_100Neuron300SecondRecordingWithLevel3Noise\*.mat" lddavila@jakar.utep.edu:"/scratch/lddavila/clustering_neuron_spikes_with_deep_learning/Data/0_100/recordings_by_channel"') ;
copy_ground_truth_command = sprintf("%s",'scp "D:\spike_gen_data\Recording By Channel Ground Truth\0_100Neuron300SecondRecordingWithLevel3Noise.h5.mat" lddavila@jakar.utep.edu:"/scratch/lddavila/clustering_neuron_spikes_with_deep_learning/Data/0_100/ground_truth"');
copy_timestamps_command = sprintf("%s",'scp "D:\spike_gen_data\Recordings By Channel Timestamps\0_100Neuron300SecondRecordingWithLevel3Noise\timestamps.mat" lddavila@jakar.utep.edu:"/scratch/lddavila/clustering_neuron_spikes_with_deep_learning/Data/0_100/timestamps"');


recording_names = struct2table(dir("D:\spike_gen_data\Recordings By Channel Timestamps"));
recording_names = recording_names(recording_names{:,"isdir"},:);

for i=4:1:size(recording_names,1)
    current_recording_name = string(recording_names{i,"name"});
    copy_channels_command_edited = char(strrep(copy_channels_command,"0_100Neuron300SecondRecordingWithLevel3Noise",current_recording_name));
    split_current_recording_name = split(current_recording_name,"Neuron");
    dir_name = split_current_recording_name{1};
    loc_of_patterns = strfind(copy_channels_command_edited,"0_100");
    copy_channels_command_edited_again = [copy_channels_command_edited(1: loc_of_patterns(end)-1),char(dir_name),copy_channels_command_edited(loc_of_patterns(end)+5:end) ] ;
    % fprintf("mkdir %s;cd %s; mkdir %s; mkdir %s; mkdir %s; cd ..;\n",dir_name,dir_name,"ground_truth","timestamps","recordings_by_channel");

    copy_ground_truth_command_edited = char(strrep(copy_ground_truth_command,"0_100Neuron300SecondRecordingWithLevel3Noise.h5.mat",current_recording_name+".h5.mat"));
    loc_of_patterns = strfind(copy_ground_truth_command_edited,"0_100");
    copy_ground_truth_edited = [copy_ground_truth_command_edited(1:loc_of_patterns(end)-1),dir_name,copy_ground_truth_command_edited(loc_of_patterns(end)+5:end)];

    copy_timestamps_command_edited = char(strrep(copy_timestamps_command,"0_100Neuron300SecondRecordingWithLevel3Noise",current_recording_name));
    loc_of_patterns = strfind(copy_timestamps_command_edited,"0_100");
    copy_timestamps_command_edited = [copy_timestamps_command_edited(1:loc_of_patterns(end)-1),dir_name,copy_timestamps_command_edited(loc_of_patterns(end)+5:end)];

    fprintf('%s\n',copy_channels_command_edited_again);
    fprintf('%s\n',copy_ground_truth_edited);
    fprintf('%s\n',copy_timestamps_command_edited);

    system(copy_timestamps_command_edited)
    system(copy_ground_truth_edited)
    system(copy_channels_command_edited_again);
    
end