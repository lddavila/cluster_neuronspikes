function [] = create_2d_peak_plot(dir_with_channel_recordings,channels_to_use,channel_peaks)
figure;

smaller_num_peaks = min([size(channel_peaks{1},1),size(channel_peaks{2},1)]);
peaks_values = nan(smaller_num_peaks,2);
for i=1:length(channels_to_use)
    channel_number = str2double(strrep(channels_to_use(i),"c",""));
    peak_idxs = channel_peaks{i};
    peak_idxs = peak_idxs(1:smaller_num_peaks);
    
    current_channel_data = importdata(dir_with_channel_recordings+"\"+channels_to_use(i)+".mat");
    peaks_values(:,i) = current_channel_data(peak_idxs).';
end
scatter(peaks_values(:,1),peaks_values(:,2));
end