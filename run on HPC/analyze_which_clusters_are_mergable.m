function [] = analyze_which_clusters_are_mergable(table_of_clusters,config)
    function [conditional_matrix,overlap_percentages] = check_timestamp_overlap(all_rows_for_current_unit,config)
        conditional_matrix = nan(size(all_rows_for_current_unit,1),size(all_rows_for_current_unit,1));
        overlap_percentages = nan(size(all_rows_for_current_unit,1),size(all_rows_for_current_unit,1));
        [row_idx,col_idx] = find(tril(true(size(conditional_matrix,1))));
        for k=1:size(row_idx,1)
            row = row_idx(k);
            col= col_idx(k);
            if row==col
                continue;
            end
            current_compare_neuron_ts = all_rows_for_current_unit{row,"timestamps"}{1};
            current_neuron_ts = all_rows_for_current_unit{col,"timestamps"}{1};
            [~,index_of_larger ]= max([length(current_compare_neuron_ts),length(current_neuron_ts)]);
            [smaller_cluster_size,~ ]= min([length(current_compare_neuron_ts),length(current_neuron_ts)]);
            if index_of_larger==1
                %if the larger cluster is the compare neuron then we use the ts
                %of the current neuron as our compare
                number_of_timestamps_in_common = find_number_of_true_positives_given_a_time_delta_hpc(current_neuron_ts,current_compare_neuron_ts,config.TIME_DELTA);
            elseif index_of_larger==2
                %if the larger cluster is the current_neuron then we use the ts
                %of the compare neuron as our compare
                %the logic behind this is that the first set of ts that are put
                %into the function will never be over counted
                number_of_timestamps_in_common = find_number_of_true_positives_given_a_time_delta_hpc(current_compare_neuron_ts,current_neuron_ts,config.TIME_DELTA);
            else
                number_of_timestamps_in_common=0;
            end

            actual_overlap_percentage = (number_of_timestamps_in_common / smaller_cluster_size) * 100;
            overlap_percentages(row,col) = actual_overlap_percentage;
            overlap_percentages(col,row) = actual_overlap_percentage;
            if actual_overlap_percentage >= config.OVERLAP
                conditional_matrix(row,col) = 1;
                conditional_matrix(col,row) = 1;
            else
                conditional_matrix(row,col) = 0;
                conditional_matrix(col,row) = 0;
            end
            print_status_iter_message("analyze_which_clusters_are_mergable.mat:check_timestamp_overlap",k,size(row_idx,1));

        end
    end
    function [conditional_matrix] = check_euc_distance_overlap(all_rows_for_current_unit,config)
        conditional_matrix = nan(size(all_rows_for_current_unit,1),size(all_rows_for_current_unit,1));
        [row_idx,col_idx] = find(tril(true(size(conditional_matrix,1))));
        
        for k=1:size(row_idx,1)
            row = row_idx(k);
            col= col_idx(k);
            if row==col
                continue;
            end
            neuron_1_waveform = all_rows_for_current_unit{row,"Mean Waveform"}{1};
            neuron_2_waveform = all_rows_for_current_unit{col,"Mean Waveform"}{1};
            euc_dist = norm(neuron_1_waveform-neuron_2_waveform);
            if euc_dist <= config.MAX_EUC_DIST
                conditional_matrix(row,col) = 1;
                conditional_matrix(col,row) = 1;
            else
                conditional_matrix(row,col) = 0;
                conditional_matrix(col,row) = 0;
            end
            print_status_iter_message("analyze_which_clusters_are_mergable.mat:check_euc_distance_overlap",k,size(row_idx,1));

        end
    end
    function [conditional_matrix] = check_nn_overlap(all_rows_for_current_unit,config,nn_struct)
        conditional_matrix = nan(size(all_rows_for_current_unit,1),size(all_rows_for_current_unit,1));

        the_nn = nn_struct.net;
        [row_idx,col_idx] = find(tril(true(size(conditional_matrix,1))));
        for k=1:size(row_idx,1)
            row = row_idx(k);
            col= col_idx(k);
            if row==col
                continue;
            end
            neuron_1_waveform = all_rows_for_current_unit{row,"Mean Waveform"}{1};
            neuron_2_waveform = all_rows_for_current_unit{col,"Mean Waveform"}{1};
            is_mergable_probabilities = predict(the_nn,[neuron_1_waveform,neuron_2_waveform]);
            [~,is_mergable] = max(is_mergable_probabilities);
            is_mergable = is_mergable-1;
            if is_mergable
                conditional_matrix(row,col) = 1;
                conditional_matrix(col,row) = 1;
            else
                conditional_matrix(row,col) = 0;
                conditional_matrix(col,row) = 0;
            end
            print_status_iter_message("analyze_which_clusters_are_mergable.mat:check_nn_overlap",k,size(row_idx,1));

        end
    end
if config.ON_HPC
    nn_struct = config.FP_TO_MERGABLE_OR_NOT_NN_ON_HPC;
else
    nn_struct = config.FP_TO_MERGABLE_OR_NOT_NN;
end
list_of_units =1:1:config.NUM_OF_UNITS;
list_of_units = [1];
overlap_conditions = ["timestamp overlap","euc distance","Mergable or not nn"];

for i=1:size(list_of_units,1)
    all_rows_for_current_unit = table_of_clusters(table_of_clusters{:,"Max Overlap Unit"}==list_of_units(i),:);
    [row_idxs,col_idxs] = find(tril(true(size(all_rows_for_current_unit,1))));
    max_num_overlaps = sum(row_idxs ~= col_idxs);
    overlap_matrices = cell(1,length(overlap_conditions));
    for j=1:size(overlap_conditions,2)
        if overlap_conditions(i)=="timestamp overlap"
            [overlap_matrices{j},overlap_percentages] = check_timestamp_overlap(all_rows_for_current_unit,config);
            list_of_overlap_percentages = sort(unique(reshape(overlap_percentages,1,[])));
            clc;
        elseif overlap_conditions(i)=="euc distance"
            overlap_matrices{j} = check_euc_distance_overlap(all_rows_for_current_unit,config);
        elseif overlap_conditions(i)=="Mergable or not nn"
            overlap_matrices{j} = check_nn_overlap(all_rows_for_current_unit,config,nn_struct);
        end
    end
end
end