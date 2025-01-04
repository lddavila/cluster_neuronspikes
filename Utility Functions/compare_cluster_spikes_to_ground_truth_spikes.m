function [] = compare_cluster_spikes_to_ground_truth_spikes(best_appearences_of_cluster,ground_truth,dir_with_outputs,dir_with_grades,table_of_accuracy_of_clusters,number_of_units_to_compare_to,dir_with_raw_recordings,dir_of_precomputed)
art_tetr_array = build_artificial_tetrode();

for i=1:size(best_appearences_of_cluster,1)
    current_tetrode = best_appearences_of_cluster{i,"Tetrode"};
    tetrode_and_cluster_code =current_tetrode+"_"+ best_appearences_of_cluster{i,"Cluster"};
    table_of_accuracy_current_tetrode = table_of_accuracy_of_clusters(table_of_accuracy_of_clusters{:,"og_tetr_and_clust_num"}==tetrode_and_cluster_code,:);
    table_of_accuracy_current_tetrode = sortrows(table_of_accuracy_current_tetrode,"overlap_with_unit","descend");


    tetrode_number = str2double(strrep(current_tetrode,"t",""));
    z_score = best_appearences_of_cluster{i,"Z Score"};
    current_channels = art_tetr_array(tetrode_number,:);
    array_of_channel_data = cell(1,length(current_channels));
    array_of_z_score_channel_data = cell(1,length(current_channels));
    ground_truth_peaks = nan(length(ground_truth{1}{table_of_accuracy_current_tetrode{1,2}}),length(current_channels));
    ground_truth_z_scores = nan(length(ground_truth{1}{table_of_accuracy_current_tetrode{1,2}}),length(current_channels));
    for channel_counter=1:length(array_of_channel_data)
        array_of_channel_data{channel_counter} = importdata(dir_with_raw_recordings+"\c"+string(current_channels(channel_counter))+".mat");
        array_of_z_score_channel_data{channel_counter} = importdata(dir_of_precomputed+"\z_score\c"+string(current_channels(channel_counter))+".mat ");
        
        ground_truth_peaks(:,channel_counter) = array_of_channel_data{channel_counter}(ground_truth{1}{table_of_accuracy_current_tetrode{1,2}}).' * -1;
        ground_truth_z_scores(:,channel_counter) = array_of_z_score_channel_data{channel_counter}(ground_truth{1}{table_of_accuracy_current_tetrode{1,2}}).';
    end

    %now plot the data found by the cluster
    [grades,~,aligned,~,idx] = import_data(dir_with_grades,dir_with_outputs,current_tetrode);
    figure;
    plot_counter=1;
    for first_dimension=1:4
        for second_dimension=first_dimension+1:4
            subplot(2,3,plot_counter);
            new_plot_proj_ver_5(idx,aligned,first_dimension,second_dimension,art_tetr_array(tetrode_number,:),current_tetrode,z_score,plot_counter,string(1:size(grades,1)))
            plot_counter= plot_counter+1;
        end
    end
    sgtitle(["From Clustering Algorithm",current_tetrode,strjoin(string(art_tetr_array(tetrode_number,:))),tetrode_and_cluster_code])

    %now create the same plot but using only the ground truth data to
    %compare against
    for unit_to_plot_counter=1:number_of_units_to_compare_to
        figure;
        plot_counter=1;
        for first_dimension=1:4
            for second_dimension=first_dimension+1:4
                subplot(2,3,plot_counter);
                plot_ground_truth_of_neuron({1:size(ground_truth_peaks,1)},ground_truth_peaks,first_dimension,second_dimension,art_tetr_array(tetrode_number,:),current_tetrode,z_score,plot_counter,"Actual Neuron")
                plot_counter= plot_counter+1;
            end
        end
        the_percentage_info ="Unit " + table_of_accuracy_current_tetrode{1,2}+ " Has " +table_of_accuracy_current_tetrode{1,4} +"% overlap with cluster";
        sgtitle(["From Ground Truth",the_percentage_info,tetrode_and_cluster_code]);
    end

end
end