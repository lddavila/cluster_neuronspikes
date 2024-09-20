function [array_of_return_dictionaries] = read_json_artificial_tetrodes_into_memory(path_of_json_files)
%array_of_return_items is a 5x1 array, each item is a struct
%the first struct is channel_to_tetrode_dictionary
    %This struct is a library which tells you which channels belong to which artificial tetrode
%the second dictionary is spike_tetrode_dictionary 
    %this dictionary is a library of spikes detected per tetrode, and is formatted to work with run_spikesort_ntt_core
    %the default value is nxmxp
        %n is the number of spikes found on the tetrode (spike number)
        %m is the number of data points for the spike (index in spike samples)
        %p is the number of channels in the tetrode (wire number?????)
    %first we reformat it to be the same as the samples directory in dg_readSpike,m
        %   Samples: spike waveform samples formatted as a 32xMxN matrix of data
        %       points, where M is the number of subchannels (wires) in the spike
        %       file (NTT M = 4, NST M = 2, NSE M = 1). These values are in AD
        %       counts.
    %then this is reformatted again to ensure compatability with run_spikesort_ntt_core.m, which expects an array called raw
            %   'raw' is a 3d array with the dimensions:
            %   1) wire number (channel number)
            %   2) spike number (number of spikes found on the tetrode)
            %   3) index in spike samples ()
    %the important part is that if you run the following code you get the expected output
        %[numwires, numspikes, numdp] = size(raw);
        %numwires: number of channels
        %numspikes: number of spikes
        %numdp: number of datapoints 
%the third dictionary is spike_channel_tetrode_dictionary
    %this dictionary is a map which tells you which channel is spiking for each slice
%the fourth dictionary is tetrode_dictionary
    %this dictionary is a map to which channels belong to which tetrode
%the fifth dictionary is timing_tetrode_dictionary
    %this dictionary is a map to timings which belong to each spike

    function [updated_map_version_of_struct] = permute_every_item_in_the_dictionary(map_version_of_struct)
        %the important part is that if you run the following code you get the expected output
        %[numwires, numspikes, numdp] = size(raw);
        %numwires: number of channels
        %numspikes: number of spikes
        %numdp: number of datapoints 
        updated_map_version_of_struct = containers.Map('KeyType','char','ValueType','any');
        all_keys = keys(map_version_of_struct);
        for current_key_counter =1:length(all_keys)
            the_current_key = all_keys{current_key_counter};
            the_current_value = permute(map_version_of_struct(the_current_key),[3 1 2]);
            updated_map_version_of_struct(the_current_key) = the_current_value;
        end
    end

    function [updated_map_version_of_struct] = permute_every_item_in_the_dictionary_samples_version(map_version_of_struct)
        %   'raw' is a 3d array with the dimensions:
        %   1) wire number (channel number)
        %   2) spike number (number of spikes found on the tetrode)
        %   3) index in spike samples ()

        %   Samples: spike waveform samples formatted as a 32xMxN matrix of data
        %       points, where M is the number of subchannels (wires) in the spike
        %       file (NTT M = 4, NST M = 2, NSE M = 1). These values are in AD
        %       counts.
        updated_map_version_of_struct = containers.Map('KeyType','char','ValueType','any');
        all_keys = keys(map_version_of_struct);
        for current_key_counter =1:length(all_keys)
            the_current_key = all_keys{current_key_counter};
            the_current_value = permute(map_version_of_struct(the_current_key),[3 1 2]);
            updated_map_version_of_struct(the_current_key) = the_current_value;
        end
    end
list_of_json_files = strtrim(string(ls(path_of_json_files+"\*.json")));
json_filename="";
array_of_return_dictionaries = cell(1,5);

for i=1:length(list_of_json_files)
    json_filename = path_of_json_files + "\"+list_of_json_files(i);
    fid = fopen(json_filename);
    raw = fread(fid,inf);
    str = char(raw');
    fclose(fid);
    current_struct = jsondecode(str);
    map_version_of_struct = containers.Map('KeyType','char','ValueType','any');
    list_of_keys = fieldnames(current_struct);
    for j=1:length(list_of_keys)
        current_key = list_of_keys{j};
        if i~=1 && i~=2
            map_version_of_struct(strrep(current_key,"c","t")) = current_struct.(current_key);
        else
            map_version_of_struct(current_key) = current_struct.(current_key);
        end
        
    end

    if i == 3
        map_version_of_struct = permute_every_item_in_the_dictionary(map_version_of_struct);
        samples_format_of_map_version_of_struct = permute_every_item_in_the_dictionary_samples_version(map_version_of_struct);
    end
    array_of_return_dictionaries{i}= map_version_of_struct;
end
array_of_return_dictionaries{end+1} = samples_format_of_map_version_of_struct;
end