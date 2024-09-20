function [] = plot_aligned_for_refinment(before_or_after,cluster_number,aligned,indexes,number_of_channels)


for j=1:number_of_channels
    figure;
    raw_aligned_data = squeeze(aligned(j,:,:));
    raw_aligned_data = raw_aligned_data(indexes,:);
    for i=1:size(raw_aligned_data,1)
        plot(1:size(raw_aligned_data,2),raw_aligned_data(i,:));
        hold on;
    end
    xlabel("time")
    ylabel("Channel "+string(j))
    title("Cluster Number: "+string(cluster_number)+ " " + before_or_after);
    subtitle("Num. of DPS:" + string(size(raw_aligned_data,1)))
end




end