function [table_of_clusters] = add_accuracy_col(ts_array,config,table_of_clusters)
accuracy_array = nan(size(table_of_clusters,1),1);
ground_truth = importdata(config.GT_FP);
timestamps = importdata(config.TIMESTAMP_FP);
accuracy_category = nan(size(table_of_clusters,1),1);
for i=1:size(table_of_clusters,1)
    unit_that_cluster_has_max_overlap_with = table_of_clusters{i,"Max Overlap Unit"};
    gt_indexes =ground_truth{unit_that_cluster_has_max_overlap_with} ;
    gt_ts = timestamps(gt_indexes);
    cluster_spike_ts = ts_array{i};
    accuracy_array(i) = calculate_accuracy(gt_ts,{cluster_spike_ts},config) * 100;
    if accuracy_array(i) <1
        accuracy_category(i)=0;
    elseif accuracy_array(i) <10
        accuracy_category(i)=1;
    elseif accuracy_array(i) <20
        accuracy_category(i)=2;
    elseif accuracy_array(i) <30
        accuracy_category(i)=3;
    elseif accuracy_array(i) <40
        accuracy_category(i)=4;
    elseif accuracy_array(i) <50
        accuracy_category(i)=5;
    elseif accuracy_array(i) <60
        accuracy_category(i)=6;
    elseif accuracy_array(i) <70
        accuracy_category(i)=7;
    elseif accuracy_array(i) <80
        accuracy_category(i)=8;
    elseif accuracy_array(i) <90
        accuracy_category(i)=9;
    elseif accuracy_array(i) <100
        accuracy_category(i)=10;
    end
    disp("add_accuracy_col Finished "+string(i)+"/"+string(size(table_of_clusters,1)));
end
table_of_clusters.accuracy = accuracy_array;
table_of_clusters.accuracy_category = accuracy_category;
end