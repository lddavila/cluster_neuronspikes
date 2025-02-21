function [] = check_for_cross_correlation_between_clusters(aligned,cluster_filters,debug,cluster_counter,ts)
%here we'll try to save multi unit activity clusters by checking if the
%cluster time series has high correlation with another cluster in the same
%configuration
%if it doesn't then that indicates true multi unit
%if it does that indicates a possible bursting neuron




peaks = get_peaks(aligned,true);
peaks = peaks.';
for current_wire = 1:size(peaks,2)
    current_cluster_ts = ts(cluster_filters{cluster_counter});
    current_cluster_peaks = peaks(cluster_filters{cluster_counter},current_wire);
    for compare_cluster_counter=1:length(cluster_filters)
        if compare_cluster_counter==cluster_counter
            continue;
        end
        compare_cluster_ts = ts(cluster_filters{compare_cluster_counter});
        compare_cluster_peaks = peaks(cluster_filters{compare_cluster_counter},current_wire);

        if length(compare_cluster_peaks) > length(current_cluster_peaks)
            current_cluster_peaks = [current_cluster_peaks.',zeros(1,length(compare_cluster_peaks) - length(current_cluster_peaks))];
        elseif length(compare_cluster_peaks)< length(current_cluster_peaks)
            compare_cluster_peaks = [compare_cluster_peaks.',zeros(1,length(current_cluster_peaks )- length(compare_cluster_peaks))];
        end

        [r,lags] = xcorr(compare_cluster_peaks,current_cluster_peaks,"normalized");

        mean_cross_correlation = mean(r(r >0));

        if debug %&& mean_cross_correlation > .5
            figure;
            subplot(1,2,1)
            stem(lags,r);
            title("Unfiltered")
            subplot(1,2,2)
            stem(lags(r>mean_cross_correlation),r(r>mean_cross_correlation))
            title("Greater Than Mean Cross Correlation")
            
           

            figure;

            current_cluster_isi = diff(current_cluster_ts);
            title(["Cluster "+ string(cluster_counter), "Differences Between Timestamps"])
            xlabel("times")
            ylabel("")
            histogram(current_cluster_isi,'Normalization','probability');
            hold on;
            compare_cluster_isi = diff(compare_cluster_ts);
            histogram(compare_cluster_isi,'Normalization','probability');
            legend(["Cluster "+string(cluster_counter),"Cluster "+string(compare_cluster_counter)])
            close all;
        end



    end

end

end