function [cell_array_of_accuracy_increases] = vacuum_spikes(table_of_neurons_to_vacuum,config)
if config.ON_HPC
    gen_grades_dir = config.GENERIC_GRADES_DIR_ON_HPC;
    gen_output_dir = config.GENRIC_DIR_WITH_OUTPUTS_ON_HPC;
    all_gt_idx =importdata(config.FP_TO_GT_FOR_RECORDING_ON_HPC);
    timestamps = importdata(config.TIMESTAMP_FP_ON_HPC);
else
    gen_grades_dir = config.GENERIC_GRADES_DIR;
    gen_output_dir = config.GENRIC_DIR_WITH_OUTPUTS;
    all_gt_idx = importdata(config.GT_FP);
    timestamps = importdata(config.TIMESTAMP_FP);
end

use_SNR_dims = config.USE_SNR_DIMS;

groups = groupcounts(table_of_neurons_to_vacuum,["Z Score", "Tetrode"]);


sliced_table_of_groups = cell(size(groups,1),1);

%slice for parallel processing
for i=1:size(groups,1)
    current_z_score = groups{i,"Z Score"};
    current_tetrode = groups{i,"Tetrode"};

    z_score_cond = table_of_neurons_to_vacuum{:,"Z Score"}==current_z_score ;
    tetro_cond = table_of_neurons_to_vacuum{:,"Tetrode"} == current_tetrode;

    [rows_of_current_z_score_and_tetrode,~] = find(z_score_cond & tetro_cond);
    rows_of_current_z_score_and_tetrode = rows_of_current_z_score_and_tetrode.';

    sliced_table_of_groups{i} = table_of_neurons_to_vacuum(rows_of_current_z_score_and_tetrode,:);
end
disp("Finished Slicing")
num_stds_to_try = 4:1:10;
cell_array_of_accuracy_increases = cell(size(groups,1),1);


parfor i=1:size(groups,1)
    current_data = sliced_table_of_groups{i};
    current_z_score = current_data{1,"Z Score"};
    current_tetrode = current_data{1,"Tetrode"};
    dir_with_grades = gen_grades_dir + " "+string(current_z_score)+ " grades";
    dir_with_outputs = gen_output_dir +string(current_z_score);

    %to prevent unnecessary loads
    [~,~,aligned,reg_timestamps_of_the_spikes,idx,failed_to_load] = import_data_hpc(dir_with_grades,dir_with_outputs,current_tetrode,0);

    if failed_to_load
        error("vacuum_spikes.m Couldnt load table_of_neurons_to_vacuum");
    end


    nested_cell_array_of_accuracy_increases =cell( size(current_data,1),size(num_stds_to_try,2)+3);
    for k=1:size(current_data,1)
        current_cluster = current_data{k,"Cluster"};
        data_string = strjoin(["Z_Score "+string(current_z_score),current_tetrode,"Cluster "+string(current_cluster)],"|");
        current_grades = current_data{k,"grades"}{1};
        current_accuracy = current_data{k,"accuracy"};
        current_max_overlap_unit = current_data{k,"Max Overlap Unit"};
        current_expand_or_dont = current_grades{61};

        current_cluster_idxs = idx{current_cluster};

        if use_SNR_dims
            snr_by_dims = current_grades{45};
            [~, sortedIndices] = sort(snr_by_dims, 'descend');
            first_dim = sortedIndices(1);
            sec_dim = sortedIndices(2);
        else
            first_dim = current_grades{42};
            sec_dim = current_grades{43};
        end

        all_peaks = get_peaks(aligned, true);

        cluster_peaks = all_peaks([first_dim,sec_dim],current_cluster_idxs);


        %calculate cluster center
        cluster_center = mean(cluster_peaks,2);
        cluster_std = std(cluster_peaks,0,2);

        if ~current_expand_or_dont
            continue;
        end

        

        nested_cell_array_of_accuracy_increases{k,1} = current_accuracy;
        nested_cell_array_of_accuracy_increases{k,2} = current_grades;
        nested_cell_array_of_accuracy_increases{k,3} = data_string;

        for j=1:size(num_stds_to_try,2)

            above_cluster_range = cluster_center + (cluster_std * num_stds_to_try(j));
            below_cluster_range = cluster_center - (cluster_std * num_stds_to_try(j));

            c1 = all_peaks(first_dim,:) < above_cluster_range(1) & all_peaks(first_dim,:) > below_cluster_range(1);
            c2 = all_peaks(sec_dim,:) < above_cluster_range(2) & all_peaks(2,:) > below_cluster_range(2);

            [~,spikes_to_vacuum] = find(all_peaks(:,c1 & c2));




            combined_spikes = union(spikes_to_vacuum,current_cluster_idxs);
            new_ts = reg_timestamps_of_the_spikes(combined_spikes);

            gt_ts_idx = all_gt_idx{current_max_overlap_unit};
            gt_ts = timestamps(gt_ts_idx);
            new_accuracy = calculate_accuracy(gt_ts,{new_ts},config) * 100;




            nested_cell_array_of_accuracy_increases{k,j+3} = new_accuracy;
            disp("vacuum_spikes.m Finished iteration "+string(i)+"|"+string(j)+"/"+string(size(num_stds_to_try,2)));
           
        end

    end
    cell_array_of_accuracy_increases{i} = nested_cell_array_of_accuracy_increases;

    disp("vacuum_spikes.m Finished "+string(i)+"/"+string(size(groups,1)))

end
end