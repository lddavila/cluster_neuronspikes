function [] = check_vacuuming_results(table_of_neurons_to_vacuum,dir_to_save_image_files_to,config)


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


   
    for k=1:size(current_data,1)
        current_cluster = current_data{k,"Cluster"};
        data_string = strjoin(["Z_Score "+string(current_z_score),current_tetrode,"Cluster "+string(current_cluster)],"_");
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

        figure;
        f_1 = scatter(all_peaks(first_dim,:),all_peaks(sec_dim,:),'filled','o',MarkerFaceColor=[0.5 0.5 0.5]);
        hold on;
        scatter(all_peaks(first_dim,current_cluster_idxs),all_peaks(sec_dim,current_cluster_idxs),'filled','o',MarkerFaceColor='k')
        title("before")

        figure;
        everything_other_than_the_cluster = setdiff(1:size(all_peaks,2),current_cluster_idxs);
        f_2 = scatter(all_peaks(first_dim,everything_other_than_the_cluster),all_peaks(sec_dim,everything_other_than_the_cluster),'filled','o',MarkerFaceColor=[0.5 0.5 0.5]);
        title("after");

    
        saveas(f_1,fullfile(dir_to_save_image_files_to,data_string+"_1.png"))
        saveas(f_2,fullfile(dir_to_save_image_files_to,data_string+"_2.png"))

    end

    disp("vacuum_spikes.m Finished "+string(i)+"/"+string(size(groups,1)))

end

end