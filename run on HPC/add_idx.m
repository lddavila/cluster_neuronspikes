function [current_rows] = add_idx(current_rows)
output = importdata(current_rows{1,"dir_to_output"});
current_rows.cluster_idx = extract_clusters_from_output(output(:,1),output);
end