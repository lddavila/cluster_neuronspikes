function [] = plot_the_peaks(peaks)
for i=1:size(peaks,1)
    for j=i+1:size(peaks,1)
        figure;
        scatter(peaks(:,i),peaks(:,j));
        xlabel("Channel " + string(i))
        ylabel("Channel " + string(j))
    end
end
end