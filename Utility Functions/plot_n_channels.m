function [] = plot_n_channels(data,number_of_channels,dir_to_save_figs_to)
    function [hp_filter] = get_a_high_pass_filter()
        %3 is the order of the filter
        %300 is the critical frequency
        %3000 is the sampling frequency
        %the filter type is high
        [b,a] = butter(3,300/(3000/2),"high");
        x = zeros(30122);
        x(floorDiv(30122,2)) = 1;
        hp_filter = filtfilt(b,a,x);
    end
    function [] = plot_without_filter(data,number_of_channels)
        fig = figure;
        for channel=1:number_of_channels
            subplot(number_of_channels,1,channel);
            plot(data(channel,:));
            title(channel)
        end
        han=axes(fig,'visible','off');
        han.XLabel.Visible='on';
        han.YLabel.Visible='on';
        ylabel(han,'Voltage');
        xlabel(han,'Time (in \mus)');
        sgtitle("Data From Kilosort");
    end

plot_without_filter(data,number_of_channels);
hp_filter = get_a_high_pass_filter;


end