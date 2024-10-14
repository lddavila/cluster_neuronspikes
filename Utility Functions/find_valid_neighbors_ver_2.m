function [flattened_neighboring_channels] = find_valid_neighbors_ver_2(channels_in_current_tetrode)
array_of_channels = [1:96;97:192;193:288;289:384];
array_of_channels = array_of_channels.';
updated_array_of_channels = zeros(96*2,4);
og_array_pointer_for_odd_cols = 1;
for i=1:2:size(updated_array_of_channels,1)
    for j=1:size(updated_array_of_channels,2)
        if j==1 || j==3
            updated_array_of_channels(i,j) = array_of_channels(og_array_pointer_for_odd_cols,j);
        elseif j==2 || j==4
            updated_array_of_channels(i+1,j) = array_of_channels(og_array_pointer_for_odd_cols,j);
        end
    end
    og_array_pointer_for_odd_cols = og_array_pointer_for_odd_cols+1;
end
% disp(updated_array_of_channels)
array_of_channels = updated_array_of_channels;
% array_of_channels = [1:96;97:192;193:288;289:384];
% array_of_channels = array_of_channels.';
neighboring_channels =[] ;
indexes_of_current_tetrode = [];

%get the location of each of the current channels in the probe
for i=1:size(channels_in_current_tetrode,2)
    [row,col] = find(array_of_channels == channels_in_current_tetrode(i));
    indexes_of_current_tetrode = [indexes_of_current_tetrode;row,col];
end
% find all possible neighbors of each channel in the current tetrode
for i=1:size(indexes_of_current_tetrode,1)
    current_row = indexes_of_current_tetrode(i,1);
    current_col = indexes_of_current_tetrode(i,2);

    if current_row+1 > size(array_of_channels,1)
        ch_above_cur_chan = NaN;
    else
        ch_above_cur_chan = array_of_channels(current_row+1,current_col);
    end

    if current_col+1 > 4
        ch_to_the_right_of_cur_chan = NaN;
    else
        ch_to_the_right_of_cur_chan = array_of_channels(current_row,current_col+1);
    end

    if current_row+1 > size(array_of_channels,1) || current_col+1 > 4
        ch_above_and_to_the_right_of_curr_chan = NaN;
    else
        ch_above_and_to_the_right_of_curr_chan = array_of_channels(current_row+1,current_col+1);
    end
    
    if current_col-1 < 1
        ch_to_the_left_of_cur_chan = NaN;
    else
        ch_to_the_left_of_cur_chan = array_of_channels(current_row,current_col-1);
    end

    if current_row-1 < 1 || current_col -1 < 1
        ch_to_the_bottom_left_of_cur_chan = NaN;
    else
        ch_to_the_bottom_left_of_cur_chan = array_of_channels(current_row-1,current_col-1);
    end

    if current_row+1 > size(array_of_channels,1) || current_col-1 < 1
        ch_to_the_top_left_of_cur_chan = NaN;
    else
        ch_to_the_top_left_of_cur_chan = array_of_channels(current_row+1,current_col-1);
    end

    if current_row-1 < 1 || current_col +1 > 4
        ch_to_to_the_top_right_of_cur_chan = NaN;
    else
        ch_to_to_the_top_right_of_cur_chan = array_of_channels(current_row-1,current_col+1);
    end
    
    neighboring_channels = [neighboring_channels;ch_above_cur_chan,ch_to_the_right_of_cur_chan,ch_above_and_to_the_right_of_curr_chan,ch_to_the_left_of_cur_chan,ch_to_the_bottom_left_of_cur_chan,ch_to_the_top_left_of_cur_chan,ch_to_to_the_top_right_of_cur_chan];
end

% remove any invalid neighbors

flattened_neighboring_channels = reshape(neighboring_channels,1,[]);
invalid_neighbors = ismember(flattened_neighboring_channels,channels_in_current_tetrode);

flattened_neighboring_channels(invalid_neighbors) = [];
flattened_neighboring_channels(isnan(flattened_neighboring_channels)) = [];

flattened_neighboring_channels = unique(flattened_neighboring_channels);
flattened_neighboring_channels(flattened_neighboring_channels==0) =[];
end