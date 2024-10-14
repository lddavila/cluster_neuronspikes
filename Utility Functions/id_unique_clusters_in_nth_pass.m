function [unique_clusters,associated_tetrodes] = id_unique_clusters_in_nth_pass(dir_with_nth_pass_results,min_overlap_percentage)
unique_clusters = {};
associated_tetrodes = {};
list_of_outputs = strtrim(string(ls(dir_with_nth_pass_results+"\*output.mat")));
config = spikesort_config(); %load the config file;
for i=1:length(list_of_outputs)
    current_tetrode_output = importdata(dir_with_nth_pass_results+"\"+list_of_outputs(i));
    name_of_current_tetrode = split(list_of_outputs(i)," ");
    name_of_current_tetrode = name_of_current_tetrode(1);

    cluster_idxs = extract_clusters_from_output(current_tetrode_output(:,1),current_tetrode_output,config);
    %the first column of current tetrode are the timestamps for hte spikes
    %the second column is the cluster associations
    %the remaining columns are the actual data points of the spikes
    if i==1 %if i is equal to 1 then just add all of the clusters to the unique clusters list
        for j=1:length(cluster_idxs)
            unique_clusters{end+1} = current_tetrode_output(cluster_idxs{j},1);
            associated_tetrodes{end+1} = name_of_current_tetrode;
        end
    else
        for unique_cluster_counter=1:length(unique_clusters)
            cluster_to_check_against = unique_clusters{unique_cluster_counter};
            supplemental_clusters = {};
            supplemental_associated_tetrodes = {};
            for possible_new_cluster_counter=1:length(cluster_idxs)
                current_cluster = cluster_idxs{possible_new_cluster_counter};
                if length(intersect(current_cluster,cluster_to_check_against)) >=  min_overlap_percentage * min([length(cluster_to_check_against),length(current_cluster)])
                    unique_clusters{possible_new_cluster_counter} = union(current_cluster,cluster_to_check_against);
                    associated_tetrodes{possible_new_cluster_counter} = [associated_tetrodes{unique_cluster_counter},name_of_current_tetrode];
                else
                    supplemental_clusters{end+1} = current_cluster;
                    supplemental_associated_tetrodes{end+1} = name_of_current_tetrode;
                end
            end
        end

        unique_clusters = [unique_clusters,supplemental_clusters];
        associated_tetrodes = [associated_tetrodes,supplemental_associated_tetrodes];
        % disp("Finished " + string(j) + "/" + string(length(cluster_idxs)));
    end
    disp("Finished " + string(i) + "/" + string(length(list_of_outputs)))
end
end
