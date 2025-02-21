function [peaks_locations,peak_voltages] = limited_spike_finder(channel_data,z_score_data,min_z_score)
    [~,peaks_locations] = findpeaks(channel_data);
    % figure;
    % plot(peaks_locations(500)-1000:peaks_locations(500)+1000,channel_data(peaks_locations(500)-1000:peaks_locations(500)+1000))
    % hold on
    % scatter(peaks_locations(peaks_locations > peaks_locations(500)-1000 & peaks_locations < peaks_locations(500)+1000),channel_data(peaks_locations(peaks_locations > peaks_locations(500)-1000 & peaks_locations < peaks_locations(500)+1000)),'magenta','filled','o')
    peaks_locations= intersect(peaks_locations,find(z_score_data >= min_z_score));
    peak_voltages = channel_data(peaks_locations);
end
