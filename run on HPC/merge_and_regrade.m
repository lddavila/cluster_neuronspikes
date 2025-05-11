function [new_accuracies_and_grades] = merge_and_regrade(table_of_overlapping_neurons,config)
% run_the_100_neuron_example
%get_slices_per_artificial_tetrode_ver_2

%slice the table for paralellization
sliced_table_of_other_appearences =cell(size(table_of_overlapping_neurons,1),1);
for i=1:size(sliced_table_of_other_appearences,1)

    overlap_data = table_of_overlapping_neurons{i,"Other Appearence Info"}{1};

    other_appearence_z_score = overlap_data('Z score of other appearences');
    other_appearence_cluster = overlap_data('cluster number of other appearences');
    other_appearence_tetrode = overlap_data('tetrodes of other appearences');

    if isempty(other_appearence_z_score)
        %disp("merge_and_regrade Finished "+string(i)+"/"+string(size(number_of_iterations,1)));
        continue;
    end

    c1 = table_of_overlapping_neurons{:,"Tetrode"} == other_appearence_tetrode;
    c2 = table_of_overlapping_neurons{:,"Z Score"}== str2double(other_appearence_z_score);
    c3 = table_of_overlapping_neurons{:,"Cluster"} == str2double(other_appearence_cluster);

    [rows_to_use,~] = find(c1 & c2 & c3);

    if size(rows_to_use,1) ~= length(other_appearence_z_score)
        disp("Found Too many rows with the correct data");
        disp("Expected "+string(length(other_appearence_z_score)) + " rows, but found "+string(size(rows_to_use,1)));
        disp("Please correct this");
        disp(table_of_overlapping_neurons(rows_to_use,:));
        disp("Expected");
        disp([other_appearence_z_score.',other_appearence_tetrode.',other_appearence_cluster.']);
        disp("Found");
        error("Found too many rows with the correct data.")
    end
    sliced_table_of_other_appearences{i} = table_of_overlapping_neurons([i;rows_to_use],:);
    disp("Slicing Finished "+string(i)+"/"+string(size(table_of_overlapping_neurons,1)))
end
disp("Finished Slicing")

draw_elipse_templates;
number_of_iterations = size(table_of_overlapping_neurons,1);
new_accuracies_and_grades = cell(size(table_of_overlapping_neurons,1),1);
parfor i=1:size(table_of_overlapping_neurons,1)

    current_overlap_data = sliced_table_of_other_appearences{i};
    if isempty(current_overlap_data)
        disp("merge_and_regrade Finished "+string(i)+"/"+string(number_of_iterations));
        continue;
    end
    all_grades = current_overlap_data{:,"grades"};


    aligned_cell_array = cell(length(other_appearence_tetrode)+1,1);
    ts_of_clusters_spikes_cell_array = cell(length(other_appearence_tetrode)+1,1);
    idx_cell_array = cell(length(other_appearence_tetrode)+1,1);
    r_tvals_cell_array =cell(length(other_appearence_tetrode)+1,1) ;
    spike_og_locs_cell_array = cell(length(other_appearence_tetrode)+1,1) ;

    all_z_scores = current_overlap_data{:,"Z Score"};
    all_tetrodes = current_overlap_data{:,"Tetrode"};
    all_clusters = current_overlap_data{:,"Cluster"};
    all_max_overlap_units = current_overlap_data{:,"Max Overlap Unit"};
    all_accuracies = current_overlap_data{:,"accuracy"};

    %extract the data required for merging and regrading
    for j=1:length(all_z_scores)

        if config.ON_HPC
            dir_with_outputs=config.GENRIC_DIR_WITH_OUTPUTS_ON_HPC+string(all_z_scores(j));
            dir_with_ts_and_rvals = config.GENERIC_GRADES_DIR_ON_HPC +string(all_z_scores(j));
        else
            dir_with_outputs=config.GENRIC_DIR_WITH_OUTPUTS+string(all_z_scores(j));
            dir_with_ts_and_rvals = config.GENERIC_GRADES_DIR+string(all_z_scores(j));
        end


        ts_r_tvals_cc_struct = load(fullfile(dir_with_ts_and_rvals,all_tetrodes(j)+".mat"),"timestamps","r_tvals","cleaned_clusters");



        ts_of_clusters_spikes_cell_array{j} = ts_r_tvals_cc_struct.timestamps;
        r_tvals_cell_array{j} = ts_r_tvals_cc_struct.r_tvals;
        idx_cell_array{j} = ts_r_tvals_cc_struct.cleaned_clusters{all_clusters(j)};
        %below we import a data structure which tells us the exact location of each of the spikes on the original recording
        %this is created during clustering and saved for the merging we will perform below
        spike_og_locs_cell_array{j} = importdata(fullfile(dir_with_outputs,all_tetrodes(j)+" sorted_spike_windows_after_purges.mat"));

        %get the aligned spikes found during clustering
        aligned_cell_array{j} = importdata(fullfile(dir_with_outputs,all_tetrodes(j)+" aligned.mat"),"aligned");


        %get the spike idxs of the current spikes

        %check to ensure that the number of spikes in aligned and the number of spike locations are equal, if not something is wrong
        if size(aligned_cell_array{j},2) ~= size(spike_og_locs_cell_array{j},1)
            disp("aligned size")
            disp(size(aligned_cell_array{j}))
            disp("spike_og_locs size")
            disp(size(spike_og_locs_cell_array{j}));
            error("Aligned Spikes and spike_og_locs size do not match")
        end



    end

    %extract the channels of each of the clusters
    all_channels = [];
    for j=1:size(all_grades,1)
        all_channels = [all_channels;all_grades{j}{49}];
    end


    % aligned_cell_array = cell(length(other_appearence_tetrode)+1,1);
    % ts_of_clusters_spikes_cell_array = cell(length(other_appearence_tetrode)+1,1);
    % idx_cell_array = cell(length(other_appearence_tetrode)+1,1);
    % r_tvals_cell_array =cell(length(other_appearence_tetrode)+1,1)

    new_accuracies_and_grades{i} =test_merge_perm(aligned_cell_array,ts_of_clusters_spikes_cell_array,idx_cell_array,r_tvals_cell_array,all_channels,spike_og_locs_cell_array,config,all_z_scores,all_tetrodes,all_clusters,all_max_overlap_units,all_accuracies);
    disp("merge_and_regrade Finished "+string(i)+"/"+string(number_of_iterations));

    %disp("merge_and_regrade.m Finished "+string(i)+"/"+string(size(table_of_overlapping_neurons,1)))
end

end