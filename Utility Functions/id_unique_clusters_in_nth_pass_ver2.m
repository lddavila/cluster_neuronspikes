function [unique_clusters,associated_tetrodes] = id_unique_clusters_in_nth_pass_ver2(dir_with_nth_pass_results,min_overlap_percentage,min_amplitude)
files_containing_recordings = dir(dir_with_nth_pass_results);
dir_flags = [files_containing_recordings.isdir];
subfolders = files_containing_recordings(dir_flags);
subfolder_names = {subfolders(3:end).name};
%disp(subfolder_names.')
unique_clusters =cell(1,length(subfolder_names));
associated_tetrodes = {1,length(subfolder_names)};
for subfolder_counter=1:length(subfolder_names)
    current_subfolder = subfolder_names{subfolder_counter};

    current_subfolder_clusters= {};
    current_subfolder_associated_tetrodes = {};
    list_of_outputs = strtrim(string(ls(dir_with_nth_pass_results+"\"+current_subfolder+"\initial_pass_results\*output.mat"))); %get list of output files
    list_of_reg_timestamps = strtrim(string(ls(dir_with_nth_pass_results+"\"+current_subfolder+"\initial_pass_results\*reg_timestamps.mat"))); %get the timestamps in seconds
    config = spikesort_config(); %load the config file;
    for i=1:length(list_of_outputs)
        current_tetrode_output = importdata(dir_with_nth_pass_results+"\"+current_subfolder+"\initial_pass_results\"+list_of_outputs(i)); %load all the output from the results of nth pass
        current_tetrode_timestamps = importdata(dir_with_nth_pass_results+"\"+current_subfolder+"\initial_pass_results\"+list_of_reg_timestamps(i));
        name_of_current_tetrode = split(list_of_outputs(i)," "); %get the name of the current tetrode
        name_of_current_tetrode = name_of_current_tetrode(1); %get the name of the current tetrode

        cluster_idxs = extract_clusters_from_output(current_tetrode_output(:,1),current_tetrode_output,config); %get the clusters identified by the current pass
        %the first column of current tetrode are the timestamps for hte spikes
        %the second column is the cluster associations
        %the remaining columns are the actual data points of the spikes
        if i==1 %if i is equal to 1 then just add all of the clusters to the unique clusters list
            for j=1:length(cluster_idxs)
                current_subfolder_clusters{end+1} = current_tetrode_timestamps(cluster_idxs{j},1); %add the current cluster to your list of unique clusters
                current_subfolder_associated_tetrodes{end+1} = name_of_current_tetrode+" " +string(j); %add the name of the tetrodes where this cluster appears
            end
        else
            for unique_cluster_counter=1:length(current_subfolder_clusters) %cycle through all of the already identified clusters
                cluster_to_check_against = current_subfolder_clusters{unique_cluster_counter}; %get the timestamps of the current cluster
                supplemental_clusters = {}; %will contain any new clusters which are found
                supplemental_associated_tetrodes = {}; %will contain the name of which tetrodes the new clusters were found in
                for possible_new_cluster_counter=1:length(cluster_idxs) %cycle through possible new clusters
                    current_cluster = cluster_idxs{possible_new_cluster_counter}; % get the indexes of the potentially new cluster
                    current_cluster_timestamps = current_tetrode_timestamps(current_cluster,1); %get the timestamps for the spikes in the current cluster
                    %the following conditional checks if
                    %the the new potential cluster and the existing cluster have a siginificant number of the same timestamps
                    %significant is defined by the min_overlap_percentage * length of whichever cluster is smaller
                    %increasing the min_overlap_percentage will make overlapping more stringent, and thus give you more unique clusters
                    %length(intersect(current_cluster_timestamps,cluster_to_check_against))
                    %tells you how many timestamps the possible new cluster and the existing cluster have in common
                    %min_overlap_percentage * min([length(cluster_to_check_against),length(current_cluster_timestamps)
                    %gets the number of data points in the smaller cluster
                    %multiplies this number by the min_overlap_percentage
                    %this will be the minimum number of datapoints required to consider these clusters to be the same/connected/something or other
                    %then check if it the overlap of the clusters is greater than the minimum
                    %example
                    %cluster to check against: size: 500
                    %possible unique cluster: size: 100
                    %min_overlap_percentage = .1
                    %length(intersect) = 50 >= 0.1 * 100?
                    %yes
                    %unique_clusters{unique_cluster_counter} =
                    if length(intersect(current_cluster_timestamps,cluster_to_check_against)) >=  min_overlap_percentage * min([length(cluster_to_check_against),length(current_cluster_timestamps)])
                        current_subfolder_clusters{unique_cluster_counter} = union(current_cluster_timestamps,cluster_to_check_against); %overwrite the existing cluster timestamps, by unioning it with the existing cluster
                        current_subfolder_associated_tetrodes{unique_cluster_counter} = [current_subfolder_associated_tetrodes{unique_cluster_counter},name_of_current_tetrode+" " + string(possible_new_cluster_counter)]; %add the tetrode to the association to the associated
                    else
                        the_max_vals_of_each_spike = max(abs(current_tetrode_output(cluster_idxs{possible_new_cluster_counter},3:end)),[],2);
                        if sum(the_max_vals_of_each_spike>= min_amplitude) > sum(the_max_vals_of_each_spike < min_amplitude) %attempt to filter out noise clusters
                            supplemental_clusters{end+1} = current_cluster_timestamps; %if the minimum threshold isn't met then the new cluster is now unique
                            supplemental_associated_tetrodes{end+1} = name_of_current_tetrode+" "+string(possible_new_cluster_counter);
                        end
                    end
                end
            end

            current_subfolder_clusters= [current_subfolder_clusters,supplemental_clusters]; %add supplemental clusters to the list of unique clusters
            current_subfolder_associated_tetrodes = [current_subfolder_associated_tetrodes,supplemental_associated_tetrodes]; %add supplemental associated tetrodes to the list
            % disp("Finished " + string(j) + "/" + string(length(cluster_idxs)));
        end

        disp("Finished " + string(i) + "/" + string(length(list_of_outputs)))
    end
    unique_clusters{subfolder_counter} = current_subfolder_clusters;
    associated_tetrodes{subfolder_counter} =current_subfolder_associated_tetrodes;
end
end
