function [] = check_for_merges_that_increase_accuracy(blind_pass_table,config)
list_of_units = 1:config.NUM_OF_UNITS;
ground_truth = importdata(config.GT_FP);
timestamps = importdata(config.TIMESTAMP_FP);
number_of_times_that_you_merged = 0;
number_of_merges_that_resulted_in_increases = 0;
for i=1:size(list_of_units,2)
    current_unit = list_of_units(i);
    all_examples_of_current_unit = blind_pass_table(blind_pass_table{:,"Max Overlap Unit"}==current_unit,:);
    for j=1:size(all_examples_of_current_unit,1)
        current_cluster_ts = all_examples_of_current_unit{j,"timestamps"}{1};
        current_cluster_tetrode = all_examples_of_current_unit{j,"Tetrode"};
        current_cluster_z_score = all_examples_of_current_unit{j,"Z Score"};
        current_cluster_num = all_examples_of_current_unit{j,"Cluster"};
        current_accuracy = all_examples_of_current_unit{j,"accuracy"};
        for k=j+1:size(all_examples_of_current_unit,1)
            if j==k
                continue;
            end
            compare_cluster_ts = all_examples_of_current_unit{k,"timestamps"}{1};
            compare_cluster_tetrode = all_examples_of_current_unit{k,"Tetrode"};
            compare_cluster_z_score = all_examples_of_current_unit{k,"Z Score"};
            compare_accuracy = all_examples_of_current_unit{k,"accuracy"};
            compare_cluster_num = all_examples_of_current_unit{k,"Cluster"};
            
            if compare_cluster_z_score > current_cluster_z_score && compare_cluster_tetrode==current_cluster_tetrode
                %if this condition is met then it means that the compare cluster and current cluster share a tetrode
                %and that the compare cluster has a higher z score than the current cluster
                %this means that the compare cluster has all the same spikes as the current cluster
                %and a result merging would never result in an increase in accuracy, so we skip it 
                continue;
            end
            combined_ts = union(current_cluster_ts,compare_cluster_ts);

            max_accuracy_before_merge = max(current_accuracy,compare_accuracy);

            new_accuracy = calculate_accuracy(timestamps(ground_truth{i}),{combined_ts},config) *100;

            
            if new_accuracy > max_accuracy_before_merge
                disp("New Accuracy is higher")
                number_of_merges_that_resulted_in_increases = number_of_merges_that_resulted_in_increases+1;
                fprintf("Before Accuracy: %0.2f After Accuracy: %0.2f\n",max_accuracy_before_merge,new_accuracy);
            end
            number_of_times_that_you_merged = number_of_times_that_you_merged+1;
        end
    end
end
end