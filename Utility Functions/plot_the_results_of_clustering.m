function [] = plot_the_results_of_clustering(array_of_desired_tetrodes,output_array,aligned_array,reg_timestamps_array)
for i=1:length(output_array)
    load(array_of_desired_tetrodes(i)+".mat");
    idx = extract_clusters_from_output();
    plot_clusters(idx,raw,tvals,ir,grades)
    channel_string = "";
    for j=1:length(channels_in_cuddrent_tetrode)
        channel_string = channel_string + " C"+string(channels_in_current_tetrode(j));
    end
    sgtitle([tetrode,channel_string]);
end

end