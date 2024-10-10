function [] = plot_results_of_peak_finding(number_of_dimensions_to_try,peaks)
for i=1:number_of_dimensions_to_try
    for j=i+1:number_of_dimensions_to_try
        figure;
        title("peaks")
        scatter(peaks(i,:),peaks(j,:),'o');
        xlabel("Channel " + string(i));
        ylabel("Channel "+string(j));
    end
end
end