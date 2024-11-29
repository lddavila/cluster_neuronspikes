function [min_b_dist_among_highest_mean_b_dist,which_dim_were_best] = find_best_dimensions_for_cluster_visibility_ver_2(all_peaks,cluster_idx,current_cluster)

all_peaks = all_peaks.';
curr_clust_in_all_dims = all_peaks(cluster_idx{current_cluster},:);
labels_for_curr_clut = boolean(zeros(size(curr_clust_in_all_dims,1),1)+1);
bhat_dist_for_current_dim_cur_clust = [];

for cluster_counter=1:length(cluster_idx)
    for
    if cluster_counter==current_cluster
        continue
    end
    comp_clust_in_curr_dim_comb = all_peaks(cluster_idx{cluster_counter},all_comb_for_k_dimensions(current_combination,:));
    labels_for_com_clust = boolean(zeros(size(comp_clust_in_curr_dim_comb,1),1));
    bhat_dist_from_current_clust_to_comp_clust = bhattacharyyaDistance([curr_clust_in_all_dims;comp_clust_in_curr_dim_comb],[labels_for_curr_clut;labels_for_com_clust]);
    bhat_dist_for_current_dim_cur_clust = [bhat_dist_for_current_dim_cur_clust;bhat_dist_from_current_clust_to_comp_clust];

end



if size(which_dim_were_best,2) > 1
    disp("multi dim is greater")
end
end