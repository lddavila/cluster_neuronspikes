function [] = plot_the_spikes_ver_2(raw,stage,number_of_spikes_to_plot,channels,timestamps)
%   'raw' is a 3d array with the dimensions:
%   1) wire number
%   2) spike number
%   3) index in spike samples
%   It represents the raw spike samples recorded.
%  'stage' a string which will be used as the title of the figure
% 'number_of_spikes_to_plot'

for j=1:size(raw,1)
    for k=j+1:size(raw,1)
        figure;
        raw_spikes = squeeze(raw(j,:,:));
        raw_spikes = raw_spikes(:);
        plot(1:size(raw_spikes,1),raw_spikes);
        hold on;
        raw_spikes = squeeze(raw(k,:,:));
        raw_spikes = raw_spikes(:);
        plot(1:size(raw_spikes,1),raw_spikes);
        title(stage)
        subtitle(string(channels(j)) + " Vs " + string(channels(k)))
        xlabel("Times")
        ylabel("Voltage");
        legend_strings = {strcat("Channel ",string(channels(k))),strcat("Channel ",string(channels(j)))};
        legend(legend_strings);
    end
end


end