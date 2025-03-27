function [] = build_tables_of_to_id_overlap_on_hpc()
%add necessary libraries to path
cd("..");
addpath(genpath(pwd));
% step 1 is to get the config file
config = choose_best_config();

%step 2 is to get the lists of dim_configs
list_of_dim_configs_dir = config.DIR_TO_SAVE_RECLUSTERING_TO_ON_HPC;

%step 3 is to get the dimensions associated with that
list_of_dim_configs = config.NUM_DIMS_TO_USE_FOR_RECLUSTERING_ON_HPC;

%step 4 is to cycle through each num dim iterations and get a table and array with all the info you need
for i=1:size(list_of_dim_configs,2)
    %step 4a is getting the file paths that will contain the data required for final analysis
    gen_dir = list_of_dim_configs_dir(i);
    grades_dir =fullfile(gen_dir,"ideal_dims_pass Top "+string(list_of_dim_configs(i)) + " Channels Grades") ; %contains the grades for the refined tetrodes
    results_dir =fullfile(gen_dir,"ideal_dims_pass_results Top "+string(list_of_dim_configs(i)) + " Channels") ; %contains the output of clustering (ts of spikes, clusters, etc)
    % mean_waveform_dir = fullfile(precomputed_dir,"ideal_dims_pass Top "+string(list_of_dim_configs(i))+ " Channels"); %contains some things which are needed to calculate mean waveform per cluster

    %step 4b is to load the gt and the timestamps of the recording into the space which will be important later
    load(config.FP_TO_GT_FOR_RECORDING_ON_HPC);
    disp("Successfully loaded ground truth")
    load(config.TIMESTAMP_FP_ON_HPC);
    disp("Sucessfully loaded timestamps of recordings")

    % step 4c is to get a list of all the tetrodes which appear in this configuration because it is variable
    home_dir = cd(results_dir);
    disp("Successfully changed directories")
    struct_of_names = dir("t*output*.mat");
    table_of_names = struct2table(struct_of_names);
    names_of_files = string(table_of_names{:,"name"});
    num_tetrodes = size(names_of_files,1);

    %step 4d is to construct a table which will contain all the data we need
    %this includes timestamps, z score, tetrode, the mean waveform, the classification, the channels, the overlap with units, the max overlap unit, and the max overlap %

    table_of_all_info = cell2table(cell(0,11),'VariableNames',["Tetrode","Cluster","Z Score","Classification","Max Overlap % With Unit","Max Overlap Unit","overlap % with all units","grades","Mean Waveform","Timestamps of spikes","Channels"]);

    parfor j=1:num_tetrodes
        %step 4e is to get the tetrode names
        unformatted_tetrode_name = names_of_files(j);
        unformatted_split_tetrode_name = split(unformatted_tetrode_name," ");
        current_tetrode = unformatted_split_tetrode_name(1);
        %4f is to get the z score and channels
        current_z_score_unformatted = strtrim(string(ls(current_tetrode+"_z_score_*.txt")));
        current_channels_unformatted = strtrim(string(ls(current_tetrode+"_channels_*.txt")));
        if length(current_z_score_unformatted) ~=1 || length(current_channels_unformatted)~=1
            disp(current_z_score_unformatted);
            disp(current_channels_unformatted);
            disp("Returned too many/few z score files or channels, aborting, Should always return exactly 1");
        else
            current_z_score_formatted = split(current_z_score_unformatted,"_");
            current_z_score = str2double(strrep(current_z_score_formatted(end),".txt",""));
            current_channels_formatted = split(current_channels_unformatted,"_");
            current_channels =  strrep(current_channels_formatted(end),".txt","");
            current_channels = split(current_channels," ");
            current_channels = str2double(current_channels);

            %step 4g is to get the grades, idx, ts for the current tetrode
            [grades,~,aligned,reg_timestamps_of_the_spikes,idx,failed_to_load] = import_data_hpc(grades_dir,results_dir,current_tetrode,true);
            disp("Successfully loaded data from clustering")


            if ~failed_to_load
                %step 4h is to create a local table for the current tetrode which will be populated
                % rows_to_add = cell2table(cell(size(grades,1),11),'VariableNames',["Tetrode","Cluster","Z Score","Classification","Max Overlap % With Unit","Max Overlap Unit","overlap % with all units","grades","Mean Waveform","Timestamps of spikes","Channels"]);
                rows_to_add = table(repelem("",size(grades,1),1),nan(size(grades,1),1),nan(size(grades,1),1),repelem("",size(grades,1),1),nan(size(grades,1),1),nan(size(grades,1),1),cell(size(grades,1),1),cell(size(grades,1),1),cell(size(grades,1),1),cell(size(grades,1),1),cell(size(grades,1),1), ...
                    'VariableNames', ...
                    ["Tetrode","Cluster","Z Score","Classification","Max Overlap % With Unit","Max Overlap Unit","overlap % with all units","grades","Mean Waveform","Timestamps of spikes","Channels"]);
                all_peaks = get_peaks(aligned, true);
                %step 4i is to populate the table
                for k=1:size(rows_to_add,1)
                    rows_to_add{k,"Tetrode"} = current_tetrode;
                    rows_to_add{k,"Cluster"} = k;
                    rows_to_add{k,"Z Score"} = current_z_score;
                    current_cluster_grades = grades(k,:);
                    % disp("++++++++++++++++")
                    % disp(grades)
                    % disp("++++++++++++++++")
                    rows_to_add{k,"Classification"} = classify_clusters_based_on_grades_ver_3(current_cluster_grades);
                    current_cluster_ts = reg_timestamps_of_the_spikes(idx{k});
                    [array_of_overlap_with_unit,unit_of_max_overlap,max_overlap_percentage] = get_overlap_between_cluster_and_unit_as_percentage_ver_2(current_cluster_ts,ground_truth_array,timestamps,config.TIME_DELTA);
                    rows_to_add{k,"Max Overlap % With Unit"} = max_overlap_percentage;
                    rows_to_add{k,"Max Overlap Unit"} = unit_of_max_overlap;
                    rows_to_add{k,"overlap % with all units"} ={array_of_overlap_with_unit};
                    rows_to_add{k,"grades"} = {current_cluster_grades};
                    cluster_filter = idx{k};
                    spikes = aligned(:, cluster_filter, :);
                    peaks = all_peaks(:, cluster_filter);
                    % Set up the representative wire for the cluster
                    [~, max_wire] = max(peaks, [], 1);
                    poss_wires = unique(max_wire);
                    n = histc(max_wire, poss_wires);
                    [~, max_n] = max(n);
                    compare_wire = poss_wires(max_n);
                    mean_waveform = mean(shiftdim(spikes(compare_wire, :, :), 1));
                    mean_waveform = mean_waveform - mean(mean_waveform);
                    rows_to_add{k,"Mean Waveform"} = {mean_waveform};
                    
                    rows_to_add{k,"Timestamps of spikes"} ={current_cluster_ts} ;                    
                    rows_to_add{k,"Channels"} = {current_channels};
                    
                end
            end
        end
        table_of_all_info = [table_of_all_info;rows_to_add];
        disp("build_tables_of_to_id_overlap_on_hpc.m Finished Iteration "+string(i)+" "+string(j)+"/"+string(num_tetrodes))
    end
    cd(home_dir)
    number_of_rows = 1:size(table_of_all_info);
    number_of_rows = number_of_rows.';
    table_of_all_info = [table_of_all_info,table(number_of_rows,'VariableNames',["idx of its location in arrays"])];
    save(fullfile(gen_dir,"table of all data for "+string(list_of_dim_configs(i))+".mat"),"table_of_all_info");

    min_overlap_percentage =1;
    timestamps_cluster_data = table_of_all_info.("Timestamps of spikes")(:);
    table_of_other_appearences = check_timestamp_overlap_between_clusters_hpc_ver_3(table_of_all_info,timestamps_cluster_data,min_overlap_percentage,config);
    save(fullfile(gen_dir,"table of all data with overlap added for "+string(list_of_dim_configs(i))+" Dims.mat"),"table_of_other_appearences");

    updated_table_of_overlap = update_table_of_overlap(table_of_all_overlap,config);
    save(fullfile(gen_dir,"table of all data with overlap added and updated for "+string(list_of_dim_configs(i))+" Dims.mat"),"updated_table_of_overlap");

    table_of_best_representation = return_best_conf_for_cluster_ver_3(updated_table_of_overlap,timestamps_cluster_data,5,config);
    save(fullfile(gen_dir,"table of best configurations for "+string(list_of_dim_configs(i))+" Dims.mat"),"table_of_best_representation");

end
end