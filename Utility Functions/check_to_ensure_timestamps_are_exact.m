function [] = check_to_ensure_timestamps_are_exact(timestamps,dir_with_nth_pass_timestamps)
%this function will ensure that all timestamps in reg timestamps are in the timestamps array, which they should be
timestamp_in_reg_thats_not_in_timestamps = false;
list_of_all_timestamps = strtrim(string(ls(dir_with_nth_pass_timestamps+"\*reg_timestamps.mat")));
for i=1:length(list_of_all_timestamps)
    current_file = list_of_all_timestamps(i);
    load(dir_with_nth_pass_timestamps+"\"+current_file,'reg_timestamps');
    if ~any(ismember(reg_timestamps,timestamps))
        disp("There's a timestamp in " + list_of_all_timestamps(i) + " that isn't in the associated timestamp array ")
        timestamp_in_reg_thats_not_in_timestamps = true;
    end
    disp("Finished "+string(i) +"/"+length(list_of_all_timestamps));
end
if ~timestamp_in_reg_thats_not_in_timestamps
    disp("There were no timestamps in the reg timestamps which don't appear in the timestamps array")
end
end