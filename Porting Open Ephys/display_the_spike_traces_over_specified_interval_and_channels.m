function [] = display_the_spike_traces_over_specified_interval_and_channels(dir_with_continous_recordings,list_of_channels,dir_with_og_indexes,time_bounds,original_data_size)
%should be built generally enough to take both the raw spike traces
%and the ones with artifacts removed

time_delta = 1/30000;

% tiledlayout("vertical",'TileSpacing','tight');
all_ts = linspace(1*time_delta,original_data_size*time_delta,original_data_size);


indexes_to_keep = all_ts <= time_bounds(2) & all_ts>= time_bounds(1);
% all_ts = all_ts(indexes_to_keep); %remove any ts outside the diesired timebounds
figure('units','normalized','outerposition',[0 0 1 1])
for i=1:length(list_of_channels)
    subplot(size(list_of_channels,2),1,i)
    channel_number = str2double(strrep(list_of_channels(i),"c",""));
    current_channel_data = importdata(dir_with_continous_recordings+"\"+list_of_channels(i)+".mat");
    current_channel_data_og_indexes = importdata(dir_with_og_indexes+"\"+list_of_channels(i)+" Original Indexes.mat");
    current_channel_data_og_indexes = single(current_channel_data_og_indexes);
    current_channel_data_og_indexes(~indexes_to_keep) = 0; %remove anything outside of current time interval 
    current_channel_data_og_indexes(current_channel_data_og_indexes == 0) = [];
    if class(current_channel_data)=="int"
        current_channel_data = double(current_channel_data);
    end
    % current_channel_data = current_channel_data.';
    % current_channel_data = current_channel_data*bit_volts(i);
    %plot(linspace(beginning_time,ending_time,size(current_channel_data,1)),current_channel_data);
    plot(all_ts(current_channel_data_og_indexes),current_channel_data(current_channel_data_og_indexes));
    title(list_of_channels(i))
    %xlim(time_bounds);
    ylim([-100,100])
    hold on;
    
end

end