function [meets_min_amp,compare_wire,mean_of_compare_wire] = check_amplitude(dir_with_nth_pass_results,current_cluster,current_tetrode,min_amplitude)
output = importdata(dir_with_nth_pass_results+"\"+current_tetrode+" output.mat");
aligned = importdata(dir_with_nth_pass_results+"\"+current_tetrode+" aligned.mat");
idx = extract_clusters_from_output(output(:,1),output,spikesort_config);

data = get_peaks(aligned, true)';

data_of_only_current_cluster = data(idx{current_cluster});

[~, max_wire_of_current_clsuter] = max(data_of_only_current_cluster, [], 2);
poss_wires = unique(max_wire_of_current_clsuter);
n = histc(max_wire_of_current_clsuter, poss_wires);
[~, max_n] = max(n);
compare_wire = poss_wires(max_n);
mean_of_compare_wire = mean(data(idx{current_cluster},compare_wire));
if mean_of_compare_wire >= min_amplitude
    meets_min_amp = true;
else
    meets_min_amp = false;
end
end