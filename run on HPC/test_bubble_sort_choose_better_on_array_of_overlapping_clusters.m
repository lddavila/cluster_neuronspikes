function [] = test_bubble_sort_choose_better_on_array_of_overlapping_clusters(array_of_overlapping_clusters,config,dir_to_save_files_to)
% return_best_conf_for_cluster_ver_5_using_nn
if config.ON_HPC
    nn_struct = importdata(config.FP_TO_COMPLEX_CHOOSE_BETTER_NN_ON_HPC);
else
    nn_struct = importdata(config.FP_TO_COMPLEX_CHOOSE_BETTER_NN);
end
nn = nn_struct.net;
tp = 0;
for i=21:size(array_of_overlapping_clusters,2)
    current_data = array_of_overlapping_clusters{i};
    [predicted_max_value_index,current_data_sorted_by_max_accuracy ]= bubble_sort_overlapping_clusters(current_data,config,nn);
    current_data_sorted_by_max_accuracy =current_data_sorted_by_max_accuracy(:,["Z Score","Tetrode","Cluster","Max Overlap Unit","accuracy"]) ;
    predicted_max_accuracy = current_data{predicted_max_value_index,"accuracy"};
    actual_max_accuracy = max(current_data{:,"accuracy"});
    if actual_max_accuracy==predicted_max_accuracy
        tp = tp+1;
    end
    % disp(current_data_sorted_by_max_accuracy(:,["Z Score","Tetrode","Cluster","Max Overlap Unit","accuracy"]))
    print_status_iter_message("test_bubble_sort_choose_better_on_array_of_overlapping_clusters.m",i,size(array_of_overlapping_clusters,2));
    filename = string(i)+".xlsx";
    writetable(current_data_sorted_by_max_accuracy,fullfile(dir_to_save_files_to,filename))
end
fprintf("Number Of times NN Chose Best:%d/%d",tp,size(array_of_overlapping_clusters,2));
end