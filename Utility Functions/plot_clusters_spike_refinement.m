function [] = plot_clusters_spike_refinement(before_or_after,cluster_number,peaks,indexes,number_of_channels)

for i=1:number_of_channels
    for j=i+1:number_of_channels
        figure;
        scatter(peaks(indexes,i),peaks(indexes,j));
        xlabel("Channel "+string(i))
        ylabel("Channel "+string(j));
        title("Cluster Number: "+string(cluster_number)+ " " + before_or_after);
        subtitle("Num. of DPS:" + string(size(peaks(indexes,i),1)))
    end
end



end