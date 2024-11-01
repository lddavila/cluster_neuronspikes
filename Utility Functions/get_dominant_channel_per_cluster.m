function [dominant_channel_array] = get_dominant_channel_per_cluster(clusters_from_output,first_pass_tetrode,channel_for_each_spike)
%dominant_channel_array:
    % a nx3 array
    %n represents the amount of clusters found in clusters_from_output 
    %the first column is which channel is dominant per cluster
    %the second column is the size of the cluster
    %the third column is how many of the spikes in the cluster belong to the dominant cluster
dominant_channel_array = zeros(length(clusters_from_output),3);

%now for each cluster determine the dominant channel as well as some other helpful statistics
for i=1:length(clusters_from_output)
    dominant_channel = first_pass_tetrode(1);
    for j=2:length(first_pass_tetrode)
        current_channel = first_pass_tetrode(j);
        if sum(channel_for_each_spike(clusters_from_output{i}) == dominant_channel) < sum(channel_for_each_spike(clusters_from_output{i}) == current_channel)
            dominant_channel = current_channel;
        end
    end
    dominant_channel_array(i,1) = dominant_channel;
    dominant_channel_array(i,2) = size(clusters_from_output{i},1);
    dominant_channel_array(i,3) = sum(channel_for_each_spike(clusters_from_output{i}) == dominant_channel);
    
end
end