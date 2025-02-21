function [] = remove_peaks_that_appear_on_too_many_channels(spikes_per_channel,dir_with_raw_recordings,dir_to_save_edited_indexes_to,debug,bit_volts,list_of_channels)
%first try and detect peaks that occur on 10+ channels

%flatten peak_indexes into a single row vector
all_peaks = [spikes_per_channel{:}];
all_peaks =[all_peaks,all_peaks(end)+1;];
edges = unique(all_peaks);
counts = histcounts(all_peaks,edges);

time_delta = 1/30000;
beginning_time = 1*time_delta;

all_artifacts_from_appearing_on_too_many_channels = edges(counts>8);

for i=1:length(list_of_channels)
    current_channel = list_of_channels(i);
    
    filtered_data = importdata(dir_with_raw_recordings+"\"+current_channel+".mat");
    filtered_data_og_indexes = int32(1:size(filtered_data,2));
    z_score_of_raw_data = zscore(filtered_data);

    ending_time = size(filtered_data,2) * time_delta;
    ts = linspace(beginning_time,ending_time,size(filtered_data,2));
    if debug
        figure;
        plot(ts,filtered_data)
        title("Raw Data "+current_channel)
    end
    for k=1:length(all_artifacts_from_appearing_on_too_many_channels)
        beginning_of_envelope = all_artifacts_from_appearing_on_too_many_channels(k);
        end_of_envelope = beginning_of_envelope+ 600; %approximately 200 milliseconds infront
        beginning_of_envelope = beginning_of_envelope-600; %approximately 200 milliseconds behind

        % filtered_data(beginning_of_envelope:end_of_envelope) =nan;
        filtered_data_og_indexes(beginning_of_envelope:end_of_envelope) = nan;
        
    end
    all_artifacts_from_z_score = find(abs(z_score_of_raw_data)>10);
    for k=1:length(all_artifacts_from_z_score)
        beginning_of_envelope = all_artifacts_from_z_score(k);
        end_of_envelope = beginning_of_envelope+ 600; %approximately 200 milliseconds infront
        beginning_of_envelope = beginning_of_envelope-600; %approximately 200 milliseconds behind

        % filtered_data(beginning_of_envelope:end_of_envelope) =nan;
        filtered_data_og_indexes(beginning_of_envelope:end_of_envelope) = 0;
        
    end
    %now also remove anything that has a huge z score 
    if debug
        figure;
        plot(ts,filtered_data);
        title("Artifacts Removed "+current_channel);
    end
    % filtered_data(isnan(filtered_data)) = [];
    %filtered_data_og_indexes(filtered_data_og_indexes==0) = [];
    % save(dir_to_save_edited_recordings_to+"\"+current_channel+".mat","filtered_data")
    save(dir_to_save_edited_indexes_to+"\"+current_channel+" Original Indexes.mat","filtered_data_og_indexes")
    disp("remove_peaks_that_appear_on_too_many_channels.m Finished " +string(i)+"/"+string(length(list_of_channels)) )
    close all;

end

end