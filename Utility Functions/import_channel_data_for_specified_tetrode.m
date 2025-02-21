function [channel_array] = import_channel_data_for_specified_tetrode(channels_of_tetrode,dir_with_recordings)
channel_array = cell(1,length(channels_of_tetrode));
for i=1:length(channels_of_tetrode)
    channel_array{i} = importdata(dir_with_recordings+"\c"+string(channels_of_tetrode(i))+".mat");
    channel_array{i} = channel_array{i}*-1;
end
end