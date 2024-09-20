function [] = plot_the_spikes_ver_4(raw,stage,which_channel)
%   'raw' is a 3d array with the dimensions:
%   1) wire number
%   2) spike number
%   3) index in spike samples
%   It represents the raw spike samples recorded.
%  'stage' a string which will be used as the title of the figure
% 'number_of_spikes_to_plot'


figure;
for current_spike=1:size(raw,2)

    raw_spikes = squeeze(raw(which_channel,current_spike,:));
    plot(1:size(raw_spikes,1),raw_spikes);
    hold on;

end

title(stage)
xlabel("Times")
ylabel("Voltage");

end