function [col_of_merge_increases_accuracy] = get_merge_increase_in_accuracy_col_wrapper(blind_pass_table,config,indexes_to_check)

ground_truth = importdata(config.GT_FP);
timestamps = importdata(config.TIMESTAMP_FP);
number_of_times_that_you_merged = 0;
number_of_merges_that_resulted_in_increases = 0;

col_of_merge_increases_accuracy = zeros(size(indexes_to_check,1),1);

if config.IS_PARALLEL_AVAILABLE && config.USE_PARALLEL
    indexes_to_check = slice_table_for_parallel_processing(indexes_to_check,[]);
    
    parfor index_counter=1:size(indexes_to_check,1)

    end
else
    for index_counter=1:size(indexes_to_check,1)
    end
end
fprintf("Increase Ratio: %d/%d\n",number_of_merges_that_resulted_in_increases,number_of_times_that_you_merged);
end