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


num_stds_to_try = 4:1:10;
cell_array_of_accuracy_increases = cell(size(table_of_neurons_to_vacuum,1),size(num_stds_to_try,2)+2);
for i=1:size(table_of_neurons_to_vacuum,1)
    current_z_score = table_of_neurons_to_vacuum{i,"Z Score"};
    current_tetrode = table_of_neurons_to_vacuum{i,"Tetrode"};
    current_cluster = table_of_neurons_to_vacuum{i,"Cluster"};
    current_grades = table_of_neurons_to_vacuum{i,"grades"}{1};
    current_accuracy = table_of_neurons_to_vacuum{i,"accuracy"};
    current_max_overlap_unit = table_of_neurons_to_vacuum{i,"Max Overlap Unit"};
    current_expand_or_dont = current_grades{61};



    dir_with_grades = gen_grades_dir + " "+string(current_z_score)+ " grades";
    dir_with_outputs = gen_output_dir +string(current_z_score);

    [~,~,aligned,reg_timestamps_of_the_spikes,idx,failed_to_load] = import_data_hpc(dir_with_grades,dir_with_outputs,current_tetrode,0);
    if failed_to_load
        error("vacuum_spikes.m Couldnt load row"+string(i)+" of table_of_neurons_to_vacuum");
    end

    current_cluster_idxs = idx{current_cluster};

    first_dim = current_grades{42};
    sec_dim = current_grades{43};

    all_peaks = get_peaks(aligned, true);

    cluster_peaks = all_peaks([first_dim,sec_dim],current_cluster_idxs);


    %calculate cluster center
    cluster_center = mean(cluster_peaks,2);
    cluster_std = std(cluster_peaks,0,2);

    if ~current_expand_or_dont
        continue;
    end

    cell_array_of_accuracy_increases{i,1} = current_accuracy;
    cell_array_of_accuracy_increases{i,2} = current_grades;
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
        new_accuracy = calculate_accuracy(gt_ts,{new_ts},config);


        
        cell_array_of_accuracy_increases{i,j+2} = new_accuracy;
        disp("vacuum_spikes.m Finished iteration "+string(i)+"|"+string(j)+"/"+string(size(num_stds_to_try)));
    end

    disp("vacuum_spikes.m Finished "+string(i)+"/"+string(size(table_of_neurons_to_vacuum,1)))

end
end