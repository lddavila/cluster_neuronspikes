function [col_of_merge_increases_accuracy] = get_merge_increase_in_accuracy_col(blind_pass_table,config,indexes_to_check)
if config.ON_HPC
    ground_truth = importdata(config.FP_TO_GT_FOR_RECORDING_ON_HPC);
    timestamps = importdata(config.TIMESTAMP_FP_ON_HPC);
else
    ground_truth = importdata(config.GT_FP);
    timestamps = importdata(config.TIMESTAMP_FP);
end
number_of_times_that_you_merged = 0;
number_of_merges_that_resulted_in_increases = 0;

col_of_merge_increases_accuracy = zeros(size(indexes_to_check,1),1);

for index_counter=1:size(indexes_to_check,1)
    j = indexes_to_check(index_counter,1);
    k = indexes_to_check(index_counter,2);
    % if blind_pass_table{j,"Max Overlap Unit"} ~= blind_pass_table{k,"Max Overlap Unit"}
    %     number_of_times_that_you_merged = number_of_times_that_you_merged+1;
    %     continue
    % end
    current_cluster_ts = blind_pass_table{j,"timestamps"}{1};
    current_cluster_tetrode = blind_pass_table{j,"Tetrode"};
    current_cluster_z_score = blind_pass_table{j,"Z Score"};

    current_accuracy = blind_pass_table{j,"accuracy"};

    compare_cluster_ts = blind_pass_table{k,"timestamps"}{1};
    compare_cluster_tetrode = blind_pass_table{k,"Tetrode"};
    compare_cluster_z_score = blind_pass_table{k,"Z Score"};
    compare_accuracy = blind_pass_table{k,"accuracy"};


    if compare_cluster_z_score > current_cluster_z_score && compare_cluster_tetrode==current_cluster_tetrode
        %if this condition is met then it means that the compare cluster and current cluster share a tetrode
        %and that the compare cluster has a higher z score than the current cluster
        %this means that the compare cluster has all the same spikes as the current cluster
        %and a result merging would never result in an increase in accuracy, so we skip it
        number_of_times_that_you_merged = number_of_times_that_you_merged+1;
        continue;
    end
    combined_ts = union(current_cluster_ts,compare_cluster_ts);

    [max_accuracy_before_merge,index_of_max_accuracy]= max([current_accuracy,compare_accuracy]);

    if index_of_max_accuracy==1
        max_overlap_unit = blind_pass_table{j,"Max Overlap Unit"};
    else
        max_overlap_unit = blind_pass_table{k,"Max Overlap Unit"};
    end

    new_accuracy = calculate_accuracy(timestamps(ground_truth{max_overlap_unit}),{combined_ts},config) *100;


    if new_accuracy > max_accuracy_before_merge
        % disp("New Accuracy is higher")
        number_of_merges_that_resulted_in_increases = number_of_merges_that_resulted_in_increases+1;
        % fprintf("Before Accuracy: %0.2f After Accuracy: %0.2f\n",max_accuracy_before_merge,new_accuracy);
        col_of_merge_increases_accuracy(index_counter) = 1;
    end
    number_of_times_that_you_merged = number_of_times_that_you_merged+1;

    print_status_iter_message("get_merge_increase_in_accuracy_col.m",index_counter,size(indexes_to_check,1))

end
fprintf("Increase Ratio: %d/%d\n",number_of_merges_that_resulted_in_increases,number_of_times_that_you_merged);
end