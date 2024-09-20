function [] = plot_the_spikes(raw,stage,number_of_spikes_to_plot,channels)
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
        scatter(squeeze(raw(j,:,:)),squeeze(raw(k,:,:)));
        title(stage)
        subtitle(string(channels(j)) + " Vs " + string(channels(k)))
        xlabel("Channel "+string(channels(j)))
        ylabel("Channel " + string(channels(k)));
    end
end


end