function [current_rows] = add_ts(current_rows)
ts = importdata(current_rows{1,"dir_to_ts"});
has_idx = check_for_required_cols(current_rows,["cluster_idx"],"add_ts","",1);
if ~has_idx
    output = importdata(current_rows{1,"dir_to_output"});
    cluster_idx = extract_clusters_from_output(output(:,1),output);
else
    cluster_idx = current_rows.cluster_idx;
end
timestamps_of_clusters = cell(size(current_rows,1),1);
for j=1:size(current_rows,1)
    current_cluster_idx = cluster_idx{j};
    timestamps_of_clusters{j} = ts(current_cluster_idx);
end
current_rows.timestamps = timestamps_of_clusters;
end