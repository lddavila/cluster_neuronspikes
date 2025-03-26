%% Step 0: Run the experimental overlap table
clc;
table_of_all_overlap = check_timestamp_overlap_between_cchecklusters_hpc_ver_3(graded_contamination_table,timestamp_array,1,0.004);

%% step 0a: update the table
clc;
updated_table_of_overlap = update_table_of_overlap(table_of_all_overlap,choose_best_config());
%% get table of channels
art_tetr_array = build_artificial_tetrode;
table_of_channels = table(strcat("t",string(1:size(art_tetr_array,1))).',art_tetr_array,'VariableNames',["Tetrode","Channels"]);
updated_table_of_overlap = join(updated_table_of_overlap,table_of_channels,"Keys","Tetrode");
%% now check how removing any config with only 4 channels affects counts

%% now get best configuration results with best 
clc;
table_of_best_representation = return_best_conf_for_cluster_ver_3(updated_table_of_overlap,timestamp_array,5,choose_best_config());

%% check missing
clc;
close all;
min_unit_appearence_threshold = 30;
table_of_best_rep_no_negatives = table_of_best_representation(table_of_best_representation{:,"SNR"}>0,:);
table_of_best_rep_with_min_unit_app_thresh = table_of_best_rep_no_negatives(table_of_best_rep_no_negatives{:,"Max Overlap % With Unit"} >=min_unit_appearence_threshold,:);
unit_appearences_no_negatives = groupcounts(table_of_best_rep_no_negatives,"Max Overlap Unit");
unit_appearences_no_negatives_tp = groupcounts(table_of_best_rep_with_min_unit_app_thresh,"Max Overlap Unit");
missing_units = setdiff(1:100,unit_appearences_no_negatives_tp.("Max Overlap Unit"));
disp("Number of Best Clusters Found:"+string(size(table_of_best_rep_no_negatives,1)));
disp("Missing Units:" + strjoin(string(missing_units)));

disp("Number of FP:" +string(sum(table_of_best_rep_no_negatives{:,"Max Overlap % With Unit"} <min_unit_appearence_threshold)))
disp("Number of TP:" + string(size(table_of_best_rep_with_min_unit_app_thresh,1)));
disp("Number of Times a unit was repeated:" + sum(unit_appearences_no_negatives{:,"GroupCount"}>1));
%% choose better dimensions
clc;
table_with_best_channels = determine_best_dimensions_of_data(table_of_best_rep_no_negatives,updated_table_of_overlap,choose_best_config());
%% now check how tp/fn is affected when you remove any with only 4 channels
clc;
close all;
min_unit_appearence_threshold = 30;
rows_with_more_than_4_channels = zeros(size(table_with_best_channels,1),1);
for i=1:length(rows_with_more_than_4_channels)
    current_channels_list = table_with_best_channels{i,"Sorted Channels"}{1};
    current_channels_snr = table_with_best_channels{i,"Sorted SNR"}{1};
    if sum(current_channels_snr>0) >4
        rows_with_more_than_4_channels(i)=1;
    end
end
% table_of_best_rep_no_negatives = table_of_best_representation(table_of_best_representation{:,"SNR"}>0,:);
table_of_best_rep_with_min_unit_app_thresh = table_with_best_channels(table_with_best_channels{boolean(rows_with_more_than_4_channels),"Max Overlap % With Unit"} >=min_unit_appearence_threshold,:);
unit_appearences_no_negatives = groupcounts(table_with_best_channels(boolean(rows_with_more_than_4_channels),:),"Max Overlap Unit");
unit_appearences_no_negatives_tp = groupcounts(table_of_best_rep_with_min_unit_app_thresh,"Max Overlap Unit");
missing_units = setdiff(1:100,unit_appearences_no_negatives_tp.("Max Overlap Unit"));
disp("Number of Best Clusters Found:"+string(size(table_with_best_channels(boolean(rows_with_more_than_4_channels),:),1)));
disp("Missing Units:" + strjoin(string(missing_units)));

disp("Number of FP:" +string(sum(table_with_best_channels{boolean(rows_with_more_than_4_channels),"Max Overlap % With Unit"} <min_unit_appearence_threshold)))
disp("Number of TP:" + string(size(table_of_best_rep_with_min_unit_app_thresh,1)));
disp("Number of Times a unit was repeated:" + sum(unit_appearences_no_negatives{:,"GroupCount"}>1));
%% recluster with best channels
clc;
recluster_with_ideal_dims(table_with_best_channels,choose_best_config());
 %% make overlap and accuracy bar plots
 close all;
 clc;
 min_unit_appearence_threshold = 30;
 has_been_plotted = zeros(size(table_with_best_channels,1),1);
 for i=1:size(table_with_best_channels,1)

     if has_been_plotted(i)
         continue;
     end
     unit_of_max_overlap = table_with_best_channels{i,"Max Overlap Unit"};

     has_been_plotted(table_with_best_channels{:,"Max Overlap Unit"} == unit_of_max_overlap) = true;
     all_appearences_of_this_unit = table_with_best_channels(table_with_best_channels{:,"Max Overlap Unit"} == unit_of_max_overlap,:);
     cluster =all_appearences_of_this_unit{:,"Cluster"};
     z_score = all_appearences_of_this_unit{:,"Z Score"};
     tetrode = all_appearences_of_this_unit{:,"Tetrode"};
     max_overlap_with_unit_percentage = all_appearences_of_this_unit{:,"Max Overlap % With Unit"};

     
     overlap_perc_with_unit = all_appearences_of_this_unit{:,"Max Overlap % With Unit"};
     ts_of_cluster = timestamp_array(all_appearences_of_this_unit{:,"idx of its location in arrays_table_of_best_representation"});

     gt_of_max_overlap_unit = ground_truth{unit_of_max_overlap};
     ts_of_max_overlap_unit = timestamps(gt_of_max_overlap_unit).';

     accuracy_for_all_appearences = nan(1,size(all_appearences_of_this_unit,1));
     for j=1:size(all_appearences_of_this_unit,1)
         tp_count = get_tp_count_given_a_tdelta_hpc(ts_of_max_overlap_unit,ts_of_cluster{j},0.004); %in both cluster and unit
         fp_count = length(ts_of_cluster{j}) - tp_count; %in cluster but not in unit
         fn_count = length(ts_of_max_overlap_unit) - tp_count; %in unit but not in cluster
         accuracy_for_all_appearences(j) = (tp_count / (fn_count + tp_count + fp_count)) * 100;
     end
     SNR = table_with_best_channels{:,"SNR"};

     figure('units','normalized','outerposition',[0 0 1 1])
     for j=1:size(all_appearences_of_this_unit,1)
         subplot(1,size(accuracy_for_all_appearences,2),j)
         data = [overlap_perc_with_unit(j) NaN; NaN accuracy_for_all_appearences(j)];
         b =bar(data);
         if j==1
             legend("Overlap with unit","Accuracy of cluster");
         end
         if max_overlap_with_unit_percentage(j) >= min_unit_appearence_threshold
             tp_or_fp = "TRUE POSITIVE";
         else
             tp_or_fp = "FALSE POSITIVE";
         end
         title("Z Score:"+string(z_score(j))+" "+tetrode(j) + " Cluster:"+string(cluster(j)) +" SNR:"+ string(SNR(j))+" "+tp_or_fp);
         b(1).Labels = b(1).YData;
         b(2).Labels = b(2).YData;
         ylim([0,100]);
     end
     sgtitle("Unit: "+string(unit_of_max_overlap))
     close all;

 end

%% lets check to see if in the case of multiples if they share stuff
clc;
min_unit_appearence_threshold = 30;
table_of_best_rep_no_negatives = table_of_best_representation(table_of_best_representation{:,"SNR"}>0,:);
table_of_best_rep_with_min_unit_app_thresh = table_of_best_rep_no_negatives(table_of_best_rep_no_negatives{:,"Max Overlap % With Unit"} >=min_unit_appearence_threshold,:);

repitition_example =table_of_best_rep_with_min_unit_app_thresh(table_of_best_rep_with_min_unit_app_thresh{:,"Max Overlap Unit"}==4,:);

first_repititon_dict = repitition_example{1,"Other Appearence Info"}{1};
sec_repitition_dict = repitition_example{2,"Other Appearence Info"}{1};

z_sc_first = first_repititon_dict('Z score of other appearences');
clust_num_first = first_repititon_dict('cluster number of other appearences');
tetrodes_first = first_repititon_dict('tetrodes of other appearences');

z_sc_sec = sec_repitition_dict('Z score of other appearences');
clust_num_sec = sec_repitition_dict('cluster number of other appearences');
tetrodes_sec = sec_repitition_dict('tetrodes of other appearences');

first_list =strcat("Z Score:", z_sc_first.'," ",tetrodes_first.');
sec_list = strcat("Z Score:", z_sc_sec.'," ",tetrodes_sec.');

intersection_of_both_lists = length(intersect(first_list,sec_list));
number_of_items_in_both_lists = length(union(first_list,sec_list));
disp(string(intersection_of_both_lists)+"/"+string(number_of_items_in_both_lists));
 %% make missing unit plots
 min_unit_appearence_threshold = 30;
 table_of_best_rep_no_negatives = table_of_best_representation(table_of_best_representation{:,"SNR"}>0,:);
 table_of_best_rep_with_min_unit_app_thresh = table_of_best_rep_no_negatives(table_of_best_rep_no_negatives{:,"Max Overlap % With Unit"} >=min_unit_appearence_threshold,:);
 unit_appearences_no_negatives_tp = groupcounts(table_of_best_rep_with_min_unit_app_thresh,"Max Overlap Unit");
 cd("D:\cluster_neuronspikes\run on HPC")
 clc;
 close all;
 missing_units = setdiff(1:100,unit_appearences_no_negatives_tp.("Max Overlap Unit"));
 disp(missing_units)
 dir_to_save_missing_units_to = "D:\cluster_neuronspikes\Data\Missing Units Plot";
 for i=1:length(missing_units)
     current_missing_unit = missing_units(i);
     % c1 =contains(updated_table_of_overlap{:,"Classification"},"Neuron","IgnoreCase",true) ;
     c2 = table_of_all_overlap{:,"Max Overlap Unit"}==current_missing_unit;
     current_missing_unit_samples = table_of_all_overlap(c2,:);
     dir_to_save_plots_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_missing_units_to);
     generic_dir_with_grades = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass min z_score";
     generic_dir_with_outputs = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass_results min z_score";

     home_dir = cd(dir_to_save_plots_to);

     current_unit_dir = "Missing Unit "+string(current_missing_unit)+ " Plots";
     mkdir(current_unit_dir);
     cd(current_unit_dir);
     plot_output_hpc_ver_2(generic_dir_with_grades,generic_dir_with_outputs,current_missing_unit_samples,false,[],[])
     cd(dir_to_save_plots_to);
 end

 %% make plots of best config which repeat
 min_unit_appearence_threshold = 30;
 table_of_best_rep_no_negatives = table_of_best_representation(table_of_best_representation{:,"SNR"}>0,:);
 table_of_best_rep_with_min_unit_app_thresh = table_of_best_rep_no_negatives(table_of_best_rep_no_negatives{:,"Max Overlap % With Unit"} >=min_unit_appearence_threshold,:);
 unit_appearences_no_negatives_tp = groupcounts(table_of_best_rep_with_min_unit_app_thresh,"Max Overlap Unit");
 cd("D:\cluster_neuronspikes\run on HPC")
 clc;
 close all;
 repeated_units = unit_appearences_no_negatives_tp{unit_appearences_no_negatives_tp{:,"GroupCount"} >1,"Max Overlap Unit"};
 disp(repeated_units)
 dir_to_save_repeated_units_to = "D:\cluster_neuronspikes\Data\Repeated Unit Plots";
 for i=1:length(repeated_units)
     repeated_unit = repeated_units(i);
     % c1 =contains(updated_table_of_overlap{:,"Classification"},"Neuron","IgnoreCase",true) ;
     c2 = table_of_best_rep_with_min_unit_app_thresh{:,"Max Overlap Unit"}==repeated_unit;
     current_repeated_units = table_of_best_rep_with_min_unit_app_thresh(c2,:);
     dir_to_save_plots_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_repeated_units_to);
     generic_dir_with_grades = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass min z_score";
     generic_dir_with_outputs = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass_results min z_score";

     home_dir = cd(dir_to_save_plots_to);

     current_unit_dir = "Repeated Unit "+string(repeated_unit)+ " Plots";
     mkdir(current_unit_dir);
     cd(current_unit_dir);
     plot_output_hpc_ver_2(generic_dir_with_grades,generic_dir_with_outputs,current_repeated_units,false,[],[])
     cd(dir_to_save_plots_to);
 end
 %% make overlap and accuracy bar plots
 close all;
 clc;
 for i=1:size(table_of_best_representation,1)

     unit_of_max_overlap = table_of_best_representation{i,"Max Overlap Unit"};

     all_appearences_of_this_unit = table_of_best_representation(table_of_best_representation{:,"Max Overlap Unit"} == unit_of_max_overlap,:);
     cluster =all_appearences_of_this_unit{:,"Cluster"};
     z_score = all_appearences_of_this_unit{i,"Z Score"};
     tetrode = all_appearences_of_this_unit{i,"Tetrode"};

     
     overlap_perc_with_unit = all_appearences_of_this_unit{:,"Max Overlap % With Unit"};
     ts_of_cluster = timestamp_array{all_appearences_of_this_unit{:,"idx of its location in arrays_table_of_best_representation"}};

     gt_of_max_overlap_unit = ground_truth_array{unit_of_max_overlap};
     ts_of_max_overlap_unit = timestamps(gt_of_max_overlap_unit).';

     tp_count = get_tp_count_given_a_tdelta_hpc(ts_of_max_overlap_unit,ts_of_cluster,0.004); %in both cluster and unit
     fp_count = length(ts_of_cluster) - tp_count; %in cluster but not in unit
     fn_count = length(ts_of_max_overlap_unit) - tp_count; %in unit but not in cluster

     SNR = table_of_best_representation{i,"SNR"};

     accuracy_score = (tp_count / (fn_count + tp_count + fp_count)) * 100;

     

     figure;
     data = [overlap_perc_with_unit ;accuracy_score];
     bar(["Overlap with Unit"," Accuracy"],data);
     % legend("Overlap with unit","Accuracy of cluster");
     title("Z Score:"+string(z_score)+" "+tetrode + " Cluster:"+string(cluster) +" SNR:"+ string(SNR));

     ylim([0,100]);
     close all;

 end
 %%
 clc;
 disp(unit_appearences)
 disp(table_of_best_representation)
 b = groupcounts(table_of_best_representation(table_of_best_representation{:,"Max Overlap % With Unit"} >=30,:),"Max Overlap Unit");
 disp("Number of units not idefnitied:"+string(length(setdiff(1:100,b.("Max Overlap Unit")))))
 disp("Number of reptitions:"+string(sum(b.GroupCount>1)))
%% step 0a1: test to make sure that updating the min overlap threshold works
clc;
for i=1:size(updated_table_of_overlap,1)
    current_overlap_percentages = updated_table_of_overlap{i,"Other Appearence Info"}{1};
    other_appearence_overlap_percentage = current_overlap_percentages("overlap percentages of other appearences");
    other_appearences_classification = current_overlap_percentages("classification of other appearences");

    disp([other_appearence_overlap_percentage.',other_appearences_classification.'])
    clc;
end
%% get the mean cluster waveform for every cluster
generic_dir_with_grades = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass min z_score";
generic_dir_with_outputs = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass_results min z_score";
current_recording = "0_100Neuron300SecondRecordingWithLevel3Noise";
dir_with_timestamps_and_rvals = "D:\spike_gen_data\Recordings By Channel Precomputed\"+current_recording+"\initial_pass min z_score";
table_of_mean_waveform = get_template_spike_for_clusters(graded_contamination_table,generic_dir_with_grades,generic_dir_with_outputs,false,dir_with_timestamps_and_rvals);

%% get the euc dist between overlapping mean waveforms and non overlapping
clc;
[array_of_euc_dist_to_non_overlapping_clusters,array_of_euc_dist_to_overlapping_clusters] = get_euc_dist_between_temp_spike_wavesforms(false,table_of_all_overlap,50);
%% plot the distributions of overlapping and non overlapping
s = RandStream('mlfg6331_64'); 
rand_sampled_array_of_non_overlapping_clusters = randsample(s,array_of_euc_dist_to_non_overlapping_clusters,size(array_of_euc_dist_to_overlapping_clusters,1));
figure;
histogram(rand_sampled_array_of_non_overlapping_clusters,'Normalization','probability');
hold on;
histogram(array_of_euc_dist_to_overlapping_clusters,'Normalization','probability');
legend("Non Overlapping","Overlapping")
%xlim([0,500])
%% plot the spikes of overlapping clusters
clc;
close all;
for i=1:size(updated_table_of_overlap,1)
    current_tetrode = updated_table_of_overlap{i,"Tetrode"};
    current_cluster = updated_table_of_overlap{i,"Cluster"};
    current_z_score = updated_table_of_overlap{i,"Z Score"};
    current_classification = updated_table_of_overlap{i,"Classification"};

    current_overlap_percentages = updated_table_of_overlap{i,"Other Appearence Info"}{1};
    other_appearence_overlap_percentage = current_overlap_percentages("overlap percentages of other appearences");
    other_appearences_classification = current_overlap_percentages("classification of other appearences");
    other_appearences_cluster = current_overlap_percentages('cluster number of other appearences');
    other_appearences_tetrode = current_overlap_percentages('tetrodes of other appearences');
    other_appearences_z_score=current_overlap_percentages("Z score of other appearences");
    a = figure('Position',[917 121 120 855]);
    subplot(size(other_appearences_classification,2)+1,1,1);

    c1 = table_of_mean_waveform{:,"Cluster" }== current_cluster;
    c2 = table_of_mean_waveform{:,"Z Score" }== current_z_score;
    c3 =table_of_mean_waveform{:,"Tetrode" }== current_tetrode;
    index_to_use = find(c1 & c2 & c3);
    mean_waveform_of_cluster = table_of_mean_waveform{index_to_use,"Mean Waveform"}{1};
    plot(mean_waveform_of_cluster)
    title(sprintf('Master Classification: %s Z Score:%i Tetrode:%s Cluster: %i',current_classification,current_z_score,current_tetrode,current_cluster))
    for j=1:size(other_appearences_z_score,2)
        try
        subplot(size(other_appearences_classification,2)+1,1,j+1);
        compare_tetrode =other_appearences_tetrode(j);
        compare_z_score = other_appearences_z_score(j);
        compare_cluster = other_appearences_cluster(j);
        compare_classification = other_appearences_classification(j);
        compare_overlap_percentage = other_appearence_overlap_percentage(j);

        c1a = table_of_mean_waveform{:,"Cluster" }== str2double(compare_cluster);
        c2b = table_of_mean_waveform{:,"Z Score" }==str2double(compare_z_score);
        c3c =table_of_mean_waveform{:,"Tetrode" }== compare_tetrode;

        index_of_compare_waveform= find(c1a & c2b & c3c);
        compare_mean_waveform = table_of_mean_waveform{index_of_compare_waveform,"Mean Waveform"}{1};
        euc_dist = norm(compare_mean_waveform-mean_waveform_of_cluster);
        plot(compare_mean_waveform)
       
        title(sprintf('Classification: %s Z Score:%s Tetrode:%s Cluster: %s Overlap:%s EucD:%f',compare_classification,compare_z_score,compare_tetrode,compare_cluster,compare_overlap_percentage,euc_dist))
        %disp([other_appearence_overlap_percentage.',other_appearences_classification.'])
        
        clc;
        catch
            continue
        end

    end
    close all;
end
%% plot by branches
groupcounts_of_branches =groupcounts(updated_table_of_overlap,"Classification");
dir_to_save_plots_to = "D:\cluster_neuronspikes\Data\neuron_plots_by_branches";
if ~exist(dir_to_save_plots_to,"dir")
    dir_to_save_plots_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_plots_to);
end
for i=1:size(groupcounts_of_branches,1)
    current_branch = groupcounts_of_branches{i,"Classification"};
    current_branch_samples = updated_table_of_overlap(contains(updated_table_of_overlap{:,"Classification"},"Neuron","IgnoreCase",true),:);
    dir_to_save_plots_to = create_a_file_if_it_doesnt_exist_and_ret_abs_path(dir_to_save_plots_to);
    generic_dir_with_grades = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass min z_score";
    generic_dir_with_outputs = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass_results min z_score";

    home_dir = cd(dir_to_save_plots_to);

    current_unit_dir = "Branch "+current_branch+ " Plots";
    mkdir(current_unit_dir);
    cd(current_unit_dir);
    plot_output_hpc(generic_dir_with_grades,generic_dir_with_outputs,current_branch_samples,false,[],[])
    cd(dir_to_save_plots_to);
end
cd(home_dir);
%% step 0b: make all the plots of 
%% Step 1
[graded_contamination_table,neurons_of_graded_cont_table,group_counts]=grade_the_results_of_cont_table(final_contamination_table,1:100);
array_of_overlap_percentages = [5 10 15 20 25 30 35 40 45 50];
cell_array_of_overlapping_clusters_tables = cell(length(array_of_overlap_percentages),2);
for i=1:length(array_of_overlap_percentages)
    cell_array_of_overlapping_clusters_tables{i,1} = array_of_overlap_percentages(i);
    cell_array_of_overlapping_clusters_tables{i,2} = check_timestamp_overlap_between_clusters_hpc_ver_2(neurons_of_graded_cont_table,timestamp_array,array_of_overlap_percentages(i),0.004);
end

save("cell_array_of_overlapping_clusters_tables.mat","cell_array_of_overlapping_clusters_tables");

%% Step 2
%load("cell_array_of_overlapping_clusters_tables.mat","cell_array_of_overlapping_clusters_tables")
%first column will be the overlap percentage that was submitted to
%check_timsestamp_overlap_between_clusters_hpc_ver_2
%second col is the overlap percentage submitted to the
%return_best_conf_for_clust
%third col is the result of return_best_conf_for_cluster
cell_array_of_best_config= cell(64,3);
for i=1:8
    for j=1:8
        cell_array_of_best_config{((i-1)*8)+(j),1} = array_of_overlap_percentages(i);
        cell_array_of_best_config{((i-1)*8)+(j),2} = array_of_overlap_percentages(j);
        cell_array_of_best_config{((i-1)*8)+(j),3} =return_best_conf_for_cluster(cell_array_of_overlapping_clusters_tables{i,2},neurons_of_graded_cont_table,grades_array,false,timestamp_array,array_of_overlap_percentages(j)) ;
    end
end
save("cell_array_of_best_config_result.mat","cell_array_of_best_config")
%% STEP 3 now combine this info with the array of helpful info
results_of_meta_data_analysis = cell(64,3);
for j=1:size(cell_array_of_best_config,1)
    
    results_of_meta_data_analysis{j,1} = cell_array_of_best_config{j,1};
    results_of_meta_data_analysis{j,2} = cell_array_of_best_config{j,2};
    current_table_of_best_config = cell_array_of_best_config{j,3};
    if mod(j,8) ~= 0
        current_overlapping_cluster_table = cell_array_of_overlapping_clusters_tables{mod(j,8),2};
    else
        current_overlapping_cluster_table = cell_array_of_overlapping_clusters_tables{8,2};
    end
    %go to the contamination table and get the max overlap and the unit it
    %has max overlap with and the classification and the grades
    rows_to_add_from_graded_cont_table = table(nan(size(current_table_of_best_config,1),1),nan(size(current_table_of_best_config,1),1),cell(size(current_table_of_best_config,1),1),repelem("",size(current_table_of_best_config,1),1),'VariableNames',["Max Overlap % With Unit","Max Overlap Unit","grades","Classification"]);
    rows_to_add_from_overlapping_clusters_tables = table(cell(size(current_table_of_best_config,1),1),cell(size(current_table_of_best_config,1),1),cell(size(current_table_of_best_config,1),1),'VariableNames',["Overlap %","Other Appearences","Tetrode"]);
    for k=1:size(current_table_of_best_config,1)
        tetrode = current_table_of_best_config{k,"Tetrode"};
        z_score = current_table_of_best_config{k,"Z Score"};
        cluster = current_table_of_best_config{k,"Cluster"};
        rows_to_add_from_graded_cont_table(k,:) = neurons_of_graded_cont_table(neurons_of_graded_cont_table{:,"Tetrode"} ==tetrode &neurons_of_graded_cont_table{:,"Z Score"}==z_score & neurons_of_graded_cont_table{:,"Cluster"}==cluster ,["Max Overlap % With Unit","Max Overlap Unit","grades","Classification"]);
        rows_to_add_from_overlapping_clusters_tables(k,:) = current_overlapping_cluster_table(neurons_of_graded_cont_table{:,"Tetrode"} ==tetrode & neurons_of_graded_cont_table{:,"Z Score"}==z_score & neurons_of_graded_cont_table{:,"Cluster"}==cluster ,["Overlap %","Other Appearences","Tetrode"]);
    end

    %now do the same by going to the array_of_overlapping cluster tables
    %this can be used to help debug
    rows_to_add_from_overlapping_clusters_tables = renamevars(rows_to_add_from_overlapping_clusters_tables,"Tetrode","Other Appearences Tetrode");
    final_table_of_meta_data_analysis = [current_table_of_best_config,rows_to_add_from_graded_cont_table,rows_to_add_from_overlapping_clusters_tables];
    results_of_meta_data_analysis{j,3} = final_table_of_meta_data_analysis;
    disp("Finished "+string(j)+"/"+string(size(cell_array_of_best_config,1)))
end

%% STPE 4 now print the TP FP groupcounts of the meta data analysis
clc;
unit_list = 1:100;
min_overlap_percentage_with_unit = 30;
array_of_tp_fp_results = {};
% what information do I want to know to debug?
    %the first meta data parameter
    %the second meta data parameter
    %# units identified
    %# cases correctly identified
        %where correctly_identified means that they meet the
        %min_overlap_percentage_with_unit threshold
    %cases where correctly identified but repeated
    %# of cases incorectly identified 
        %defined as being tied to some unit n, but not meeting the
        %min_overlap_percentage_with_unit requirement
    %the branch of the tree which caused this classification
    %how many correctly identified, but repeated
    %# of units not represented
    %the explanation as to why the units were lost
clc;

debug_table = cell2table(cell(0,11),'VariableNames',["first_overlap_percentage","second_overlap_percentage","total_clusters_idd_as_neurons","tp_aka_real_number_of_neurons","tp_cases","fp_aka_number_of_neurons_misid","fp_cases","number_of_repitions","repetition_cases","fn_aka_number_of_neurons_missed","units_missed"]);
for i=1:size(results_of_meta_data_analysis,1)
    first_meta_parameter = results_of_meta_data_analysis{i,1};
    second_meta_parameter = results_of_meta_data_analysis{i,2};
    current_final_table_of_meta_analysis = results_of_meta_data_analysis{i,3};

    table_of_correctly_identified = current_final_table_of_meta_analysis(current_final_table_of_meta_analysis{:,"Max Overlap % With Unit"} >= min_overlap_percentage_with_unit,:);
    gc_of_correctly_idd_neurons = groupcounts(table_of_correctly_identified,"Max Overlap Unit");
    number_of_units_correctly_idd_but_repeated = sum(gc_of_correctly_idd_neurons{:,"GroupCount"}>1);
    list_of_correctly_idd_but_repeated_units = gc_of_correctly_idd_neurons{gc_of_correctly_idd_neurons{:,"GroupCount"}>1,["Max Overlap Unit"]};
    number_of_units_correctly_idd_without_reps = size(table_of_correctly_identified,1) - number_of_units_correctly_idd_but_repeated;

    rows_of_correct_with_repetition = table_of_correctly_identified(ismember(table_of_correctly_identified{:,"Max Overlap Unit"},list_of_correctly_idd_but_repeated_units),:);

    
    list_of_units_identified_in_current_configuration = unique(table_of_correctly_identified{:,"Max Overlap Unit"});
    

    
    rows_of_cc_where_unit_was_misidentified = current_final_table_of_meta_analysis(current_final_table_of_meta_analysis{:,"Max Overlap % With Unit"} < min_overlap_percentage_with_unit,:);
    units_incorrectly_identified_in_current_configuration = size(rows_of_cc_where_unit_was_misidentified,1);
    units_not_represented = setdiff(unit_list,list_of_units_identified_in_current_configuration);
    % units_represented_multiple_times = groupcounts_by_units_represented_in_current_meta_data(groupcounts_by_units_represented_in_current_meta_data{:,"GroupCount"}>1,["Max Overlap Unit"]);


    if first_meta_parameter==30 && second_meta_parameter ==40
        disp("First overlap %:"+string(first_meta_parameter)+" Second Overlap %:"+string(second_meta_parameter))
        disp("# of units total:"+string(size(current_final_table_of_meta_analysis,1)));
        disp("# of units correctly id'd (without repetitions):"+string(number_of_units_correctly_idd_without_reps))
        disp("# of repeitions:"+string(number_of_units_correctly_idd_but_repeated))
        disp("# of units incorrectly id'd:"+string(units_incorrectly_identified_in_current_configuration))
        disp("# of units not id'd:"+string(length(units_not_represented)))
        % disp("# of units represented multiple times:"+string(size(units_represented_multiple_times,1)))
        % disp(groupcounts_by_units_represented_in_current_meta_data(groupcounts_by_units_represented_in_current_meta_data{:,"GroupCount"}>1,["Max Overlap Unit","GroupCount"]));
        % disp(sortrows(current_final_table_of_meta_analysis,"Max Overlap Unit"))
        disp("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    end
    
    row_to_add_to_debug_table = table(first_meta_parameter,second_meta_parameter, size(current_final_table_of_meta_analysis,1),number_of_units_correctly_idd_without_reps,{table_of_correctly_identified},units_incorrectly_identified_in_current_configuration,{rows_of_cc_where_unit_was_misidentified},number_of_units_correctly_idd_but_repeated, {rows_of_correct_with_repetition},length(units_not_represented),{units_not_represented},...
        'VariableNames', ["first_overlap_percentage","second_overlap_percentage","total_clusters_idd_as_neurons","tp_aka_real_number_of_neurons","tp_cases","fp_aka_number_of_neurons_misid","fp_cases","number_of_repitions","repetition_cases","fn_aka_number_of_neurons_missed","units_missed"]);
    debug_table = [debug_table;row_to_add_to_debug_table];
    %seems as though 80 is the max #units my tree finds the first time 80
    %are found is first overlap %15 and second overlap percentage 40
end
[the_max,index_of_max] = max(debug_table{:,"tp_aka_real_number_of_neurons"});
most_tp = debug_table(index_of_max,:);

%% STEP 5 diagnose which ones were missing 
min_overlap_percentage_with_unit = 30;
missing_units = most_tp.units_missed{1};
disp(missing_units)
first_overlap_percentages = most_tp.first_overlap_percentage;
clc;
index_of_best = find(array_of_overlap_percentages==first_overlap_percentages);
current_overlap_table = cell_array_of_overlapping_clusters_tables{index_of_best,2};
current_overlap_table = renamevars(current_overlap_table,"Tetrode","tetrodes_of_other_appearences");
og_tetrodes = neurons_of_graded_cont_table(:,"Tetrode");

table_to_use_for_debugging = [og_tetrodes,current_overlap_table];
disp(table_to_use_for_debugging)
clc
%find where those missing units were represented in the original neurons
%identified
appearences_of_missing_in_original = cell(1,size(missing_units,1));
for i=1:size(missing_units,2)
    c1 = neurons_of_graded_cont_table{:,"Max Overlap Unit"} ==missing_units(i);
    c2 = neurons_of_graded_cont_table{:,"Max Overlap % With Unit"} >= min_overlap_percentage_with_unit;
    appearences_of_missing_in_original{i} = neurons_of_graded_cont_table(c1 & c2,:);
end
disp(appearences_of_missing_in_original{1})
clc;
%now find which of the "best" cases absorbed any/all of those other
%appearences
tp_which_absorbed_missing_units = most_tp.tp_cases{1};
fp_which_absorbed_missing_units = most_tp.fp_cases{1};
list_of_cases_that_absorbed_missing_units = cell(size(missing_units,2),4);
for i=1:size(appearences_of_missing_in_original,2)
    current_appearences_of_missing = appearences_of_missing_in_original{i};
    list_of_tetrodes_of_og_appearence = current_appearences_of_missing.Tetrode;
    list_of_clusters_of_og_appearence = current_appearences_of_missing.Cluster;
    list_of_z_scores_of_og_appearence = current_appearences_of_missing.("Z Score");
    cases_that_absorbed_current_unit = [];
    cases_that_were_absorbed = [];

    list_of_cases_that_absorbed_missing_units{i,1} = missing_units(i);
    list_of_cases_that_absorbed_missing_units{i,2} = current_appearences_of_missing;


    %["Z_Score:3 Cluster 5"    "Z_Score:3 Cluster 6"    "Z_Score:3 Cluster 5"    "Z_Score:3 Cluster 1"
    formatted_z_score_and_cluster_list = strcat("Z_Score:",string(list_of_z_scores_of_og_appearence)," Cluster ",string(list_of_clusters_of_og_appearence));
    table_of_best = [tp_which_absorbed_missing_units;fp_which_absorbed_missing_units];
    for j=1:size(table_of_best,1)
       
        c1 = ismember(table_of_best{j,"Other Appearences Tetrode"}{1},list_of_tetrodes_of_og_appearence);
        c2 = ismember(table_of_best{j,"Other Appearences"}{1},formatted_z_score_and_cluster_list);
        indexes = find(c1 & c2);

        c3 = ismember(list_of_tetrodes_of_og_appearence,table_of_best{j,"Other Appearences Tetrode"}{1});
        c4 = ismember(formatted_z_score_and_cluster_list,table_of_best{j,"Other Appearences"}{1});
        indexes_in_opposite_direction = find(c3 & c4);

        appearences_that_were_absorbed_by_this_case = strcat("Tetrode:",list_of_tetrodes_of_og_appearence(indexes_in_opposite_direction)," Z_Score:",string(list_of_z_scores_of_og_appearence(indexes_in_opposite_direction))," Cluster ",string(list_of_clusters_of_og_appearence(indexes_in_opposite_direction)));

        if ~isempty(indexes)
            cases_that_absorbed_current_unit = [cases_that_absorbed_current_unit;table_of_best(j,:)];
            cases_that_were_absorbed = [cases_that_were_absorbed;appearences_that_were_absorbed_by_this_case];
        end
    end
    list_of_cases_that_absorbed_missing_units{i,3} = cases_that_absorbed_current_unit; 
    list_of_cases_that_absorbed_missing_units{i,4} = unique(cases_that_were_absorbed);
end
disp(list_of_cases_that_absorbed_missing_units)

%% STEP 6: print the missing units cases
dir_to_save_plots_to = "D:\cluster_neuronspikes\Data\debug_plots";
for i=5:size(list_of_cases_that_absorbed_missing_units,1)
    current_missing_unit = list_of_cases_that_absorbed_missing_units{i,1};
    missing_unit_appearences = list_of_cases_that_absorbed_missing_units{i,2};
    generic_dir_with_grades = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass min z_score";
    generic_dir_with_outputs = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass_results min z_score";
    
    home_dir = cd(dir_to_save_plots_to);
    
    current_unit_dir = "Missing UNIT "+string(current_missing_unit)+ " Plots";
    mkdir(current_unit_dir);
    cd(current_unit_dir);
    plot_output_hpc(generic_dir_with_grades,generic_dir_with_outputs,missing_unit_appearences,false,[],[])
    cd(dir_to_save_plots_to);
end
cd(home_dir);
%% now fix the fp cases
false_positive_cases = most_tp{1,"fp_cases"}{1};
branches_of_fp = false_positive_cases{:,"Classification"};
true_positive_cases = most_tp{1,"tp_cases"}{1};
branches_of_tp = true_positive_cases{:,"Classification"};
cases_that_affect_fp_and_not_tp = setdiff(branches_of_fp,branches_of_tp);
disp(cases_that_affect_fp_and_not_tp)