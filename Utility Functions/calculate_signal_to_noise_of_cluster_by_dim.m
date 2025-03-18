function [snr_ratio] = calculate_signal_to_noise_of_cluster_by_dim(aligned,peaks_in_cluster,which_dim)

% all_snr = zeros(1,size(aligned,1)) ./ NaN;
data = get_peaks(aligned, true)';
inner_circle_n_of_std = 3;
outer_circle_n_of_std = 4;
% for i=1:size(aligned,1)


cluster = data(peaks_in_cluster, :);
cluster_x = cluster(:, which_dim);

cluster_mean_x = mean(cluster_x);
cluster_std_x = std(cluster_x);


inner_rim_above = cluster_mean_x + (inner_circle_n_of_std*cluster_std_x);
inner_rim_below = cluster_mean_x - (inner_circle_n_of_std*cluster_std_x);
outer_rim_above = cluster_mean_x + (outer_circle_n_of_std * cluster_std_x);
outer_rim_below = cluster_mean_x - (outer_circle_n_of_std * cluster_std_x);


n_dpts_in_cluster = length(peaks_in_cluster);
n_dpts_in_outer_rim = size(data( (data(:,which_dim) > inner_rim_above & data(:,which_dim) <= outer_rim_above) | (data(:,which_dim) < inner_rim_below & data(:,which_dim) > outer_rim_below )  ,which_dim),1) ;
%n_dpts_in_inner_rim = size(data( (data(:,i) <= inner_rim_above) & (data(:,i) >= inner_rim_below)  ,i),1) ;
snr_ratio = (n_dpts_in_cluster - n_dpts_in_outer_rim )/ (n_dpts_in_cluster + n_dpts_in_outer_rim);

% end

% snr_ratio = all_snr(which_dim);


end