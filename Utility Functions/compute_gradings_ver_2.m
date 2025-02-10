function grades = compute_gradings_ver_2(aligned, timestamps, tvals, clusters, config,debug,relevant_grades,output,name_of_relevant_grades,channels_of_curr_tetr)
%COMPUTE_GRADINGS Computes grades for each of the clusters.
%   grades = COMPUTE_GRADINGS(aligned, timestamps, tvals, clusters) returns
%   the grades for each of the clusters.
%
%   'aligned' is a 3d array with the dimensions:
%   1) wire number
%   2) spike number
%   3) index in spike samples
%   It is the same as 'raw', but with spikes aligned to have the same peak
%   index.
%
%   'timestamps' are the timestamps for each spike in microseconds.
%   
%   'tvals' are the threshold values for each wire in microvolts.
%
%   'clusters' is a cell array of indices for each of the clusters.
%
%   The grades are:
%   1) LRatio - a measure of isolation of the cluster from the rest of the
%   spikes
%   2) Tightness - a measure of how tight the waveforms are using peaks
%   3) Percent short ISIs - a measure of how much of the cluster has short
        %most neurons don't fire close
        %ISI is interspike interval (distance between spikes
            %small ISI's are very rare, a lot of them could indicate bad clusters
            %interspike intervals (less than 3ms)
%   4) Incompleteness - a measure of how much of the cluster was cut off by the threshold
        %if the threshol is set incorrectly then you won't have smooth round edges to the cluster, instead you'll have sharp cuts
        %sometimes this is necessary because expanding in every dimension isn't possible as it will sometimes overlap with other clusters / destroy your shape
%   5) Isolation Distance - a measure of how far a cluster is from the threshold
        %Similar to LRato and Bhaat distance, like distance for the thresholds
        %the more distant from the threshold the better the grade
        %might not be great because it depends on the thresholds which can change quite a bit

%   6) The number of spikes
        %too many spikes is suspicious
        %too few spikes might also indicate noise
%   7) Stationarity in time (lack thereof) reporting
        %if a cluster's voltage is drifting
        %
%   8) Template matching of the representative wire's mean waveform
        %similarity across channels
        %compare with channels with biggest amplitude
        %might be good for creating better tetrode configurations
        %take a template from the highest spiking channel and compare it to the other channels in the tetrode 
%   9) Bhattacharyya Distance to every cluster
%   10) Bhattacharyya Distance to unsorted spikes

    num_clusters = length(clusters);
    grades = nan(num_clusters, 40);
    total_raw_spikes = 1:size(aligned, 2);
    all_peaks = get_peaks(aligned, true);
    temp = load('template.mat');
    for k = 1:num_clusters
        % Set up cluster-specific vars
        cluster_filter = clusters{k};
        ts = timestamps(cluster_filter);
        spikes = aligned(:, cluster_filter, :);
        peaks = all_peaks(:, cluster_filter);
        
        % Set up the representative wire for the cluster
        [~, max_wire] = max(peaks, [], 1);
        poss_wires = unique(max_wire);
        n = histc(max_wire, poss_wires);
        [~, max_n] = max(n);
        compare_wire = poss_wires(max_n);
        wire_thresh = tvals(compare_wire);
        compare_peaks = peaks(compare_wire, :);
        
        % Rate how good the cluster is based on how far away it is from the
        % rest of the spikes (including unclustered).
        other_good_spikes = setdiff(total_raw_spikes, cluster_filter);
        other_peaks = all_peaks(:, other_good_spikes);
        data_filt = find_singular_cols(other_peaks');
        lratio = compute_lratio(peaks(data_filt, :)', other_peaks(data_filt, :)');
        grades(k, 1) = lratio;
        
        % Peak cv check
        cv = compute_cv(peaks);
        grades(k, 2) = cv;
        
        % ISI check
        isi = diff(ts) * 1e-6; % Convert to seconds
        short_isi_len = config.params.GR_SHORT_ISI_LEN;
        short_isi = sum(isi < short_isi_len)/length(isi); % Fraction of ISI < short_isi_len
        grades(k, 3) = short_isi; %OG
        
        
        % Theoretical fraction below threshold
        below_threshold = compute_incompleteness(compare_peaks, wire_thresh);
        grades(k, 4) = below_threshold;
        
        % Isolation distance
        grades(k, 5) = mahal(double(wire_thresh), compare_peaks');
        
        % Number of spikes
        grades(k, 6) = length(cluster_filter);
        
        % Stationarity
        t_mu = mean(timestamps);
        t_std = std(timestamps);
        cluster_med = median(timestamps(cluster_filter));
        grades(k, 7) = cluster_med < t_mu - t_std || cluster_med > t_mu + t_std;
        
        % Template matching
        if length(cluster_filter) > 1
            mean_waveform = mean(shiftdim(spikes(compare_wire, :, :), 1));
            mean_waveform = mean_waveform - mean(mean_waveform);
            grades(k, 8) = template_match(mean_waveform, temp.nt);
        else
            grades(k, 8) = 0;
        end
        
        % Bhat distance
        dists = inf(num_clusters, 1);
        peaks = peaks';
        for c = 1:num_clusters
            if c == k
                continue
            end
            other_cf = clusters{c};
            other_peaks = all_peaks(:, other_cf)';
            dim_filt = find_singular_cols(peaks) & find_singular_cols(other_peaks);
            if any(dim_filt)
                dists(c) = bhat_dist(peaks(:, dim_filt), other_peaks(:, dim_filt));
            end
        end
        min_bhat = min(dists);
        grades(k, 9) = min_bhat;
        
        % Bhat distance to unsorted
        other_cf = setdiff(1:size(all_peaks, 2), unique(vertcat(clusters{:})));
        other_peaks = all_peaks(:, other_cf)';
        dim_filt = find_singular_cols(peaks) & find_singular_cols(other_peaks);
        if ~isempty(other_peaks) && any(dim_filt)
            grades(k, 10) = bhat_dist(peaks(:, dim_filt), other_peaks(:, dim_filt));
        end
        
        %how much it deviates from the noise
        grades(k, 11) = compute_lratio(peaks(:, dim_filt), other_peaks(:, dim_filt));
        
        rep_wire = shiftdim(spikes(compare_wire, :, :), 1);
        [~, snr] = compute_new_cv(rep_wire, 0.5);
        grades(k, 16) = snr;
        [~, snr] = compute_new_cv(rep_wire, 0.33);
        grades(k, 17) = snr;
        [~, snr] = compute_new_cv(rep_wire, 0.25);
        grades(k, 18) = snr;
        grades(k, 12) = compute_new_cv(rep_wire, 0.5);
        grades(k, 13) = compute_new_cv(rep_wire, 0.33);
        grades(k, 14) = compute_new_cv(rep_wire, 0.25);
        
        isi = isi * 1e3; % milliseconds
        grades(k, 15) = sum(isi < 7.5) / sum(isi < 100);
        
        if isempty(other_cf)
            near_thresh_idx = [];
        else
            near_thresh_idx = other_cf(all(bsxfun(@(x, y) x < y, other_peaks, 1.5 * tvals), 2));
        end
        near_thresh_peaks = all_peaks(:, near_thresh_idx)';
        dim_filt = find_singular_cols(peaks) & find_singular_cols(near_thresh_peaks);
        if sum(dim_filt) > 1 && length(near_thresh_idx) > 0.5*length(cluster_filter)
            grades(k, 19) = bhat_dist(peaks(:, dim_filt), near_thresh_peaks(:, dim_filt));
        end
        
        dim_filt = find_singular_cols(peaks) & find_singular_cols(all_peaks');
        if any(dim_filt) && ~isempty(other_cf)
            m1 = mahal(peaks(:, dim_filt), peaks(:, dim_filt));
            t1 = median(m1) + 5 * std(m1);
            m = mahal(all_peaks', peaks);
            near_clust_idx = intersect(other_cf, find(m < t1));
            near_clust_peaks = all_peaks(:, near_clust_idx)';
            if length(near_clust_idx) > 0.2 * length(cluster_filter)
                dim_filt = find_singular_cols(peaks) & find_singular_cols(near_clust_peaks);
                grades(k, 20) = bhat_dist(peaks(:, dim_filt), near_clust_peaks(:, dim_filt));
            else
                grades(k, 20) = Inf;
            end
            grades(k, 21) = length(near_clust_idx);
        end
        
        cluster_t = timestamps(cluster_filter);
        duration = 2 * std(cluster_t);
        grades(k, 22) = duration / (timestamps(end) - timestamps(1));
        
        mean_spike = shiftdim(mean(spikes(compare_wire, :, :)), 1);
        if length(cluster_filter) > 1
            [~, ~, mpc] = hfcm(peaks, 2, config);
            grades(k, 23) = mpc;
            dim_filt = find_singular_cols(peaks, 0.5);
            grades(k, 24) = sum(dim_filt);
        
            mean_spike_int = spline(1:length(mean_spike), mean_spike, linspace(1, length(mean_spike), 5000));
            [starthalfpk, endhalfpk] = get_halfpeak_range(mean_spike_int, 0.25);
            if isnan(starthalfpk) || isnan(endhalfpk)
                dur = 0;
            else
                dur = 1.25e3 * (endhalfpk - starthalfpk) / length(mean_spike_int);
            end
            grades(k, 25) = dur;
        else
            grades(k, 23) = 0;
            grades(k, 24) = 0;
            grades(k, 25) = 0;
        end

        grades(k, 26) = length(cluster_filter) * 1e6 / (timestamps(end) - timestamps(1));

        pks = find_peaks(mean_spike);
        pks = pks{1};
        [~, idx] = max(mean_spike(pks));
        pkidx = pks(idx);
        vals = find_peaks(mean_spike * (-1));
        vals = vals{1};
        has_valley = any(vals > pkidx);
        grades(k, 27) = has_valley;

        %grade 28 will the measuring completeness with skewness instead of
        %the standard
        the_skewness = skewness(compare_peaks);
        grades(k,28) = the_skewness;

        %grade 29 will be the measure of template matching within the
        %cluster's template instead of the normal template matching
        % Template matching with per cluster template, instead of general
        % template
        if length(cluster_filter) > 1
            mean_waveform = mean(shiftdim(spikes(compare_wire, :, :), 1));
            mean_waveform = mean_waveform - mean(mean_waveform);
            grades(k, 29) = template_match_ver_2(mean_waveform, mean(mean_waveform));
        else
            grades(k, 29) = 0;
        end

        %grade 30 will only be another incompleteness grade based only off of symmetry of the histogram
        %it will be #bins to left of bin with highest bin count / # bins to right of bin with highest bin count
        grades(k,30) = compute_incompleteness_ver_2(compare_peaks);

        %grade 31 will classify the cluster into high medium or low
        %grade of 1 indicates low average amplitude of cluster
        %grade of 2 indicates medium average amplitude of cluster
        %grade of 3 indicates high average amplitude of cluster
        %this grade can be used to interpret the validity of other grades
        low_cutoff = 20;
        medium_cutoff = 50;
        high_cutoff = 100;
        grades(k,31) = category_of_cluster(low_cutoff,medium_cutoff,high_cutoff,peaks);

        %grade 32 will be similar to 31, but instead of the whole cluster
        %it will just be the amplitude of the dominant wire
        grades(k,32) = category_of_cluster(low_cutoff,medium_cutoff,high_cutoff,compare_peaks);

        %grade 33 will be a range of how likely a cluster is to be a multi
        %unit activity cluster
        %this is based on several factors including cluster amplitude,
        %cv, rep wire amplitude
        %1 is definitely multi unit activity
        %3 is definitely NOT multiunit activity
        %2 could go either way
        if cv > 0.25 && grades(k,31) ==1 && grades(k,32) ==1
            grades(k,33) = 1;
        elseif cv < 0.1 && (grades(k,31)>=2 || grades(k,32) >=2) 
            grades(k,33) = 3;
        else
            grades(k,33) = 2;
        end

        %%grade 35 will be a method of measuring tightness of waveform of
        %%the cluster, using Euclidean distance
        %It measures the euc distance of the mean waveform to all spikes in the peak then divides it by the max euc distance
        %thus this gradewill be from 0-1 with closer to 0 being better

        %
        % mean_waveform = mean(shiftdim(spikes(compare_wire, :, :), 1));
        % mean_waveform = mean_waveform - mean(mean_waveform);
        % grades(k, 8) = template_match(mean_waveform, temp.nt);
        mean_waveform_for_cluster_k = mean(shiftdim(spikes(compare_wire, :, :), 1));
        grades(k,35) = calculate_tightness_of_waveform_per_cluster(mean_waveform_for_cluster_k,spikes,debug);

        %%grade 36 will be the same as 35, but only using the rep wire
        %%spikes
        grades(k,36) = calculate_tightness_of_waveform_per_cluster(mean_waveform_for_cluster_k,spikes(compare_wire,:,:),debug);

        %grade 37 will be checking the best possible dimensions for seeing the cluster
        %grade 38 will record which those dimensions are for debugging purposes
        [grades(k,37),grades(k,38)] = find_best_dimensions_for_cluster_visibility(all_peaks,clusters,k);

        %grade 39 will just be a simple boolean to report if the cluster is
        %underpowered (ie has less than 100 spikes
        grades(k,39) = size(clusters{k},2) < 100 ;

        %grade 40 will be a measure of signal to noise ratio, closer to 1
        %is better
        grades(k,40) = calculate_signal_to_noise_of_cluster(aligned,cluster_filter);

        %grade 41 will be some kind of measure of likeliness of a bursting
        %neuron
        grades(k,41) = check_for_burst(ts,spikes,debug);

        


    end

    %bhat distance from possible multi unit activity clusters
    for k=1:num_clusters
        cluster_filter = clusters{k};
        peaks = all_peaks(:, cluster_filter);
        dists = inf(num_clusters, 1);
        peaks = peaks';
        for c = 1:num_clusters
            if c == k || grades(c,1) == 1
                continue
            end
            other_cf = clusters{c};
            other_peaks = all_peaks(:, other_cf)';
            dim_filt = find_singular_cols(peaks) & find_singular_cols(other_peaks);
            if any(dim_filt)
                dists(c) = bhat_dist(peaks(:, dim_filt), other_peaks(:, dim_filt));
            end
        end
        min_bhat = min(dists);
        grades(k,34) = min_bhat;
    end

    if debug
        % creates the mean waveform per cluster
        figure('units','normalized','outerposition',[0 0 1 1])
        colors_to_use = distinguishable_colors(size(aligned,1)*3);
        legend_string = [];
        for i=1:num_clusters
            subplot(1,num_clusters,i);
            cluster_filter = clusters{k};
            spikes = aligned(:, cluster_filter, :);
            for j=1:size(spikes,1)
                current_channels_spikes = squeeze(spikes(j,:,:));
                s = RandStream('mlfg6331_64');
                random_sampling_of_current_channel_spikes = datasample(s,current_channels_spikes,round(size(current_channels_spikes,1)*.10),"Replace",false);
                for p=1:size(random_sampling_of_current_channel_spikes,1)
                    current_spike = random_sampling_of_current_channel_spikes(p,:);
                    plot(1:length(current_spike),current_spike,'Color',colors_to_use(j+(size(aligned,1)*2),:));
                    hold on;

                end

            end
            title("10% Sample of Cluster "+string(i));
        end


        %will only really work for tetrodes of 4 channels
        figure('units','normalized','outerposition',[0 0 1 1])
        plot_counter = 1;
        for first_dimension = 1:length(channels_of_curr_tetr)
            for second_dimension = first_dimension+1:length(channels_of_curr_tetr)
                idx = extract_clusters_from_output(output(:,1),output,spikesort_config);
                subplot(2,6,plot_counter);
                new_plot_proj_ver_4(idx,aligned,first_dimension,second_dimension,channels_of_curr_tetr,"","");
                plot_counter = plot_counter+1;
            end

        end
        subplot(2,6,7:12);
        relevant_grades_of_current_tetrode = grades(:,relevant_grades);

        x_values = name_of_relevant_grades;
        y_values = strcat("c",string(1:size(grades,1)));
        heatmap(x_values,y_values,relevant_grades_of_current_tetrode,'ColorbarVisible','off','CellLabelFormat','%0.10f');

        close all;
    end

end