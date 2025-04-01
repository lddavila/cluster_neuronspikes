function [] = recluster_with_ideal_dims(config)
if config.ON_HPC
    number_of_outer_iterations = length(config.NUM_DIMS_TO_USE_FOR_RECLUSTERING_ON_HPC);
    possible_numbers_of_dimensions = config.NUM_DIMS_TO_USE_FOR_RECLUSTERING_ON_HPC;
    table_with_best_channels = importdata(config.FP_TO_TABLE_OF_BEST_CHANNELS);
else
    number_of_outer_iterations = length(config.NUM_DIMS_TO_USE_FOR_RECLUSTERING);
    possible_numbers_of_dimensions =config.NUM_DIMS_TO_USE_FOR_RECLUSTERING;
end

disp("Successfully read data from config file");


table_with_best_channels_cell_array = cell(size(table_with_best_channels,1),1);
for i=1:size(table_with_best_channels,1)
    table_with_best_channels_cell_array{i} = table_with_best_channels(i,:);
end
for num_dims_to_use_counter=1:number_of_outer_iterations
    disp("Beginning Reclustering With "+string(possible_numbers_of_dimensions(num_dims_to_use_counter))+" Dimensions")
    % already_used = cell(1,size(table_with_best_channels,1));

    parfor i=1:size(table_with_best_channels,1)
        current_data = table_with_best_channels_cell_array{i};
        z_score_to_use_for_reclustering = current_data{1,"Z Score"};
        potent_new_dims = current_data{1,"Sorted Channels"}{1};
        snr_of_pot_dims = current_data{1,"Sorted SNR"}{1};
        dims_to_use =potent_new_dims( find(snr_of_pot_dims >0,possible_numbers_of_dimensions(num_dims_to_use_counter)));

        % dims_already_used = false;
        % for j=1:size(already_used,2)
        %     if all(ismember(dims_to_use,already_used{j}))
        %         dims_already_used = true;
        %     end
        %     if isempty(already_used{j})
        %         already_used{j} = dims_to_use;
        %         break;
        %     end
        % end

        % if dims_already_used
        %     continue;
        % end

        if config.ON_HPC
            precomputed_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(config.DIR_TO_SAVE_RECLUSTERING_TO_ON_HPC(num_dims_to_use_counter));
            dictionaries_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(fullfile(precomputed_dir,"Ideal Dimension Dictionaries"));
        else
            precomputed_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(config.DIR_TO_SAVE_RECLUSTERING_TO);
            dictionaries_dir = create_a_file_if_it_doesnt_exist_and_ret_abs_path(fullfile(precomputed_dir,"Ideal Dimension Dictionaries"));
        end
        % disp("Sucessfully set the directories for reclustering")
        if length(dims_to_use) ==possible_numbers_of_dimensions(num_dims_to_use_counter)
            run_clustering_algorithm_on_refined_tetrodes_ver_2(dims_to_use,precomputed_dir,dictionaries_dir,i,config,z_score_to_use_for_reclustering);
            disp("recluster_with_ideal_dims.m Finished "+string(i)+"/"+string(size(table_with_best_channels,1) * number_of_outer_iterations))
        else
            disp("Not Enogh dimensions skipping "+string(i))
        end
        

    end
end
end