function [] = classify_clusters_as_neurons_based_on_overlap_with_unit(ground_truth_dir,time_delta,gen_data_dir,dir_of_timestamps,parent_save_dir)
z_scores_to_check = [3 4 5 6 7 8 9];
art_tetr_array = build_artificial_tetrode();

list_of_tetrodes = strcat("t",string(1:size(art_tetr_array,1)));
list_of_tetrodes = list_of_tetrodes.';
list_of_clusters = repelem(1,length(list_of_tetrodes),1);

best_appearences_of_cluster = table(repelem(list_of_tetrodes,length(z_scores_to_check)),repelem(list_of_clusters,length(z_scores_to_check)),repelem(z_scores_to_check,length(list_of_tetrodes)).','VariableNames',["Tetrode","Cluster","Z Score"]);

% gen_data_dir = "/home/lddavila/spike_gen_data/0_100Neuron300SecondRecordingWithLevel3Noise";
%slice the best appearences_of_cluster
cell_array_of_all_clusters = cell(1,size(best_appearences_of_cluster,1));
for i=1:length(cell_array_of_all_clusters)
    cell_array_of_all_clusters{i} = best_appearences_of_cluster(i,:);
end

final_contamination_table = cell2table(cell(0,7),'VariableNames',["Tetrode","Z Score","Cluster","Max Overlap % With Unit","Contamination Score","Max Overlap Unit","overlap % with all units","grades"]);


% ground_truth_dir = "/home/lddavila/ground_truth/Recording By Channel Ground Truth";
ground_truth_array = load_ground_truth_into_data(ground_truth_dir);
ground_truth = ground_truth_array{1};

timestamps = importdata(fullfile(dir_of_timestamps,"timestamps.mat")) ;
parfor i=1:length(cell_array_of_all_clusters)
    current_data = cell_array_of_all_clusters{i};
    current_tetrode = current_data{1,"Tetrode"};
    current_z_score = current_data{1,"Z Score"};
    dir_with_grades = fullfile(gen_data_dir,"initial_pass min z_score "+string(current_z_score)+" grades");
    dir_with_outputs = fullfile(gen_data_dir,"initial_pass_results min z_score"+string(current_z_score));
    [grades,~,~,reg_timestamps_of_the_spikes,idx] =import_data_hpc(dir_with_grades,dir_with_outputs,current_tetrode,false);
    cell_array_of_grades = cell(size(grades,1),1);


    contamination_per_cluter = nan(size(grades,1),1);
    max_overlap_per_cluster = zeros(size(grades,1),1);
    indexes_of_max_overlap_per_cluster = zeros(size(grades,1),1);
    array_of_overlap_percentages = cell(size(grades,1),1);
    for j=1:size(grades,1)
        array_of_overlap_percentages{j} = get_overlap_between_cluster_and_unit_as_percentage(reg_timestamps_of_the_spikes(idx{j}),ground_truth,timestamps,time_delta);
        [max_overlap_per_cluster(j),indexes_of_max_overlap_per_cluster(j)] = max(array_of_overlap_percentages{j});
        contamination_per_cluter(j) =  max_overlap_per_cluster(j) - sum(array_of_overlap_percentages{j}(setdiff(1:length(ground_truth),indexes_of_max_overlap_per_cluster(j))));
        cell_array_of_grades{j} = grades(j,:);
    end
    tetrode_list = repelem(current_tetrode,size(grades,1),1);
    z_score_list = repelem(current_z_score,size(grades,1),1);
    clusters_list = 1:size(grades,1);
    clusters_list = clusters_list.';

    current_contamination_table = table(tetrode_list,z_score_list,clusters_list,max_overlap_per_cluster,contamination_per_cluter,indexes_of_max_overlap_per_cluster,array_of_overlap_percentages,cell_array_of_grades,'VariableNames',["Tetrode","Z Score","Cluster","Max Overlap % With Unit","Contamination Score","Max Overlap Unit","overlap % with all units","grades"]);
    
    final_contamination_table = [final_contamination_table;current_contamination_table];
    disp("Finished "+string(i))

end
home_dir = cd(parent_save_dir);
data_dir = "contamination table with time delta:"+string(time_delta);
dir_to_save_data_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(fullfile(parent_save_dir,data_dir));
cd(dir_to_save_data_to);
disp(final_contamination_table);
disp("Finished")
save("contamination_table.mat","final_contamination_table");
cd(home_dir)
end