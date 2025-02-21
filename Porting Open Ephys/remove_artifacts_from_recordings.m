function [] = remove_artifacts_from_recordings(dir_with_raw_recordings,dir_to_save_filtered_recordings_to,ordered_lists_of_channels,bit_volts)
%saves it in inverted format
%remove every 200 milliseconds where we find a z score
%greater that 10
for i=1:length(ordered_lists_of_channels)
    filtered_data = importdata(dir_with_raw_recordings+"\"+ordered_lists_of_channels(i)+".mat");
    filtered_data_og_indexes = int8(1:length(filtered_data));
    filtered_data = double(filtered_data);
    filtered_data = filtered_data * bit_volts(i) *-1;

    current_z_score_data = zscore(filtered_data);
    all_artifacts = find(abs(current_z_score_data)>9);
    all_beginnings_and_ends = [];
    for k=1:length(all_artifacts)
        beginning_of_envelope = all_artifacts(k);
        end_of_envelope = beginning_of_envelope+ 600; %approximately 200 milliseconds infront
        beginning_of_envelope = beginning_of_envelope-600; %approximately 200 milliseconds behind

        filtered_data(beginning_of_envelope:end_of_envelope) =nan;
        filtered_data_og_indexes(beginning_of_envelope:end_of_envelope) = nan;
        all_beginnings_and_ends = [all_beginnings_and_ends;beginning_of_envelope,end_of_envelope];
    end
    filtered_data(isnan(filtered_data)) = [];
    filtered_data_og_indexes(isnan(filtered_data_og_indexes)) = [];
    save(dir_to_save_filtered_recordings_to+"\"+ordered_lists_of_channels(i)+".mat","filtered_data");
    save(dir_to_save_filtered_recordings_to+"\"+ordered_lists_of_channels(i)+" OG indexes.mat","filtered_data_og_indexes");
    disp("remove_artifacts_from_recordings.m Finished "+string(i)+"\"+string(length(ordered_lists_of_channels)));
end
end