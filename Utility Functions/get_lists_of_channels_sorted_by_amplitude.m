function [array_of_channels_sorted_by_amplitude] = get_lists_of_channels_sorted_by_amplitude(united_list,generic_dir_with_grades,generic_dir_with_outputs)
array_of_channels_sorted_by_amplitude = cell(1,length(united_list));
art_tetr_array = build_artificial_tetrode;
for i=2:size(united_list,2)
    current_united_list = united_list{i};
    if current_united_list==" "
        continue
    end
    current_united_list = split(current_united_list," ",2);
    tetrodes = current_united_list(:,1);
    clusters = current_united_list(:,4);
    z_scores = split(current_united_list(:,2),":",2);
    z_scores = z_scores(:,2);
    table_of_only_neurons = table(nan(size(current_united_list,1),1),tetrodes,str2double(clusters),str2double(z_scores),'VariableNames',["category","tetrode","cluster","z-score"]);
    [grades_array,~,aligned_array,~,~]= get_data_of_neurons_identified_as_clusters(table_of_only_neurons,generic_dir_with_grades,generic_dir_with_outputs);
    peaks_array = cell(1,length(aligned_array));
    for j=1:length(aligned_array)
        peaks_array{j} = get_peaks(aligned_array{j},true);
    end
    channels_of_each_tetrode = art_tetr_array(str2double(strrep(tetrodes,"t","")),:);
    means_of_each_channel = nan(size(channels_of_each_tetrode,1),size(channels_of_each_tetrode,2));
    tetrodes_of_each_channel = repelem("",size(channels_of_each_tetrode,1),size(channels_of_each_tetrode,2));
    z_scores_of_each_channel = nan(size(channels_of_each_tetrode,1),size(channels_of_each_tetrode,2));
    snr_of_each_tetrode = cell2mat(grades_array.'); %SNR grade
    snr_of_each_tetrode = snr_of_each_tetrode(:,40);
    SNR = nan(size(channels_of_each_tetrode,1),size(channels_of_each_tetrode,2));
    for j=1:length(aligned_array)
        means_of_each_channel(j,:) = mean(peaks_array{j}.',1);
        tetrodes_of_each_channel(j,:) = repelem(table_of_only_neurons{j,"tetrode"},1,size(means_of_each_channel(j,:),2));
        z_scores_of_each_channel(j,:) = repelem(table_of_only_neurons{j,"z-score"},1,size(means_of_each_channel(j,:),2));
        SNR(j,:) = repelem(snr_of_each_tetrode(j),1,size(means_of_each_channel(j,:),2));
    end
    
    channels = reshape(channels_of_each_tetrode,[],1);
    means = reshape(means_of_each_channel,[],1);
    z_scores_flat = reshape(z_scores_of_each_channel,[],1);
    tetrodes_flat = reshape(tetrodes_of_each_channel,[],1);
    snr_flat = reshape(SNR,[],1);

    table_of_necessary_data = table(channels,means,z_scores_flat,tetrodes_flat,snr_flat,'VariableNames',["channel","mean","z-score","og tetr","SNR"]);
    unique_channels_with_means = unique(table_of_necessary_data,'rows','stable');
    sorted_unique_channels_with_means = sortrows(unique_channels_with_means,["mean","z-score","SNR"],"descend");
    array_of_channels_sorted_by_amplitude{i} = sorted_unique_channels_with_means;
    disp("get_lists_of_channels_sorted_by_amplitude Finished "+string(i)+"/"+string(length(united_list)))
end
end