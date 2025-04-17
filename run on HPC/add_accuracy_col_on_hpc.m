function [table_of_clusters] = add_accuracy_col_on_hpc(ts_array,config,table_of_clusters,number_of_categories)
accuracy_array = nan(size(table_of_clusters,1),1);
ground_truth = config.FP_TO_GT_FOR_RECORDING_ON_HPC;
timestamps = importdata(config.TIMESTAMP_FP_ON_HPC);

accuracy_category = nan(size(table_of_clusters,1),1);
sliced_table_of_clusters = cell(size(table_of_clusters,1));
sliced_max_overlap_unit = cell(size(table_of_clusters,1));
sliced_ground_truth = cell(size(table_of_clusters,1));

categories = linspace(1,100,number_of_categories);

for i=1:size(table_of_clusters,1)
    sliced_table_of_clusters{i} = table_of_clusters(i,:);
    sliced_max_overlap_unit{i} = {i,"Max Overlap Unit"};
    sliced_ground_truth{i} = ground_truth{sliced_max_overlap_unit{i}};
end


parfor i=1:size(table_of_clusters,1)
    gt_indexes =sliced_ground_truth{i} ;
    gt_ts = timestamps(gt_indexes);
    cluster_spike_ts = ts_array{i};
    accuracy_array(i) = calculate_accuracy(gt_ts,{cluster_spike_ts},config) * 100;
    for j=1:size(categories,2)
        if accuracy_array(i) < categories(j)
            accuracy_category(i) = j-1;
            break;
        end
    end
    disp("add_accuracy_col Finished "+string(i)+"/"+string(size(table_of_clusters,1)));
end
table_of_clusters.accuracy = accuracy_array;
table_of_clusters.accuracy_category = accuracy_category;
end