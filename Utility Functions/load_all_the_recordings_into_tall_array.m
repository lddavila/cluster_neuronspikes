function [tall_array_of_recordings] = load_all_the_recordings_into_tall_array(dir_with_all_channel_recordings)
all_data_files = strtrim(string(ls(strcat(dir_with_all_channel_recordings,"\*.mat"))));

all_data_files = fullfile(dir_with_all_channel_recordings,all_data_files);
fds = fileDatastore(all_data_files,"ReadFcn",@load,"FileExtensions",".mat");

tall_array_of_recordings = tall(fds);
end