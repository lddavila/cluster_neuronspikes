function [] = analyze_reclustering_results(config,dir_with_tables_of_best_rep,blind_pass_table,timestamp_array)
%step 1 is to get a list of all best_rep tables in the dir
table_of_best_configs = struct2table(dir(fullfile(dir_with_tables_of_best_rep,"*best*")));
filenames_of_best_configs =table_of_best_configs{:,"name"};
ground_truth = importdata(config.GT_FP);
timestamps = importdata(config.TIMESTAMP_FP);
skip = false;
for i=6:size(filenames_of_best_configs,1)
    current_filename = filenames_of_best_configs{i};
    table_of_best_representation = importdata(fullfile(dir_with_tables_of_best_rep,current_filename));

    min_unit_appearence_threshold = config.MIN_UNIT_APPEARENCE_THRESHOLD;

    %remove any rows of table of best appearence that have a negative SNR
    table_of_best_rep_no_negatives = table_of_best_representation(table_of_best_representation{:,"SNR"}>0,:);

    %we can define our prediction space as the number of rows in table_of_best_rep_no_negatives
    %true positive: the number of clusters in table_of_best_rep_no_negatives which meet the min_unit_appearence_threshold


    %from the table with no negative snr check how many of them meet the min unit appearence threshold
    %ie it has at least n% of a unit's spikes
    %n is specified by the config file
    table_of_best_rep_with_min_unit_app_thresh = table_of_best_rep_no_negatives(table_of_best_rep_no_negatives{:,"Max Overlap % With Unit"} >=min_unit_appearence_threshold,:);

    %check which units appeared on the table of best configurations without negatives
    %this way we can tell how many times a unit was repeated
    unit_appearences_no_negatives = groupcounts(table_of_best_rep_no_negatives,"Max Overlap Unit");

    %check which units appeared with min unit appearence threshold
    unit_appearences_no_negatives_tp = groupcounts(table_of_best_rep_with_min_unit_app_thresh,"Max Overlap Unit");

    %get a list of which units did not appear in this table of best configuration
    missing_units = setdiff(1:config.NUM_OF_UNITS,unit_appearences_no_negatives_tp.("Max Overlap Unit"));

    disp("+++++++++++++++++++++++")
    disp("Number of clusters identified as best:"+string(size(table_of_best_rep_no_negatives,1)));
    disp("# of clusters have at least "+string(min_unit_appearence_threshold)+"% With a Unit:"+string(size(table_of_best_rep_with_min_unit_app_thresh,1)));
    disp("# of clusters which don't meet threshold:"+string(size(table_of_best_rep_no_negatives,1)-size(table_of_best_rep_with_min_unit_app_thresh,1)))
    disp("Missing Units:"+ strjoin(string(missing_units)));
    disp("+++++++++++++++++++++++")

    %now create the bar charts for the accuracy/overlap with unit/ overlap with cluster


    list_of_units = 1:100;
    for j=1:size(list_of_units,2)
        if skip
            break;
        end
        unit_of_max_overlap = list_of_units(j);
        % unit_of_max_overlap = 27;
        all_appearences_of_this_unit = table_of_best_rep_no_negatives(table_of_best_rep_no_negatives{:,"Max Overlap Unit"} == unit_of_max_overlap,:);
        if size(all_appearences_of_this_unit,1)==0
            continue;
        end
        cluster =all_appearences_of_this_unit{:,"Cluster"};
        z_score = all_appearences_of_this_unit{:,"Z Score"};
        tetrode = all_appearences_of_this_unit{:,"Tetrode"};
        max_overlap_with_unit_percentage = all_appearences_of_this_unit{:,"Max Overlap % With Unit"};

        overlap_perc_with_unit = all_appearences_of_this_unit{:,"Max Overlap % With Unit"};
        ts_of_cluster = all_appearences_of_this_unit{:,"Timestamps of spikes"};

        gt_of_max_overlap_unit = ground_truth{unit_of_max_overlap};
        ts_of_max_overlap_unit = timestamps(gt_of_max_overlap_unit).';

        accuracy_for_all_appearences = nan(1,size(all_appearences_of_this_unit,1));
        proportion_of_cluster_spikes_that_belong_to_unit  = nan(1,size(all_appearences_of_this_unit,1));
        for k=1:size(all_appearences_of_this_unit,1)
            tp_count = get_tp_count_given_a_tdelta_hpc(ts_of_max_overlap_unit,ts_of_cluster{k},0.004); %in both cluster and unit
            fp_count = length(ts_of_cluster{k}) - tp_count; %in cluster but not in unit
            fn_count = length(ts_of_max_overlap_unit) - tp_count; %in unit but not in cluster
            accuracy_for_all_appearences(k) = (tp_count / (fn_count + tp_count + fp_count)) * 100;
            proportion_of_cluster_spikes_that_belong_to_unit(k) = (tp_count / size(ts_of_cluster{k},1))*100;
        end
        SNR = table_of_best_rep_no_negatives{:,"SNR"};
        figure('units','normalized','outerposition',[0.5 0 0.5 1])

        for k=1:size(all_appearences_of_this_unit,1)
            subplot(1,size(accuracy_for_all_appearences,2),k)
            data = [overlap_perc_with_unit(k) NaN NaN; NaN accuracy_for_all_appearences(k) NaN;NaN NaN proportion_of_cluster_spikes_that_belong_to_unit(k)];
            b =bar(data);
            if k==1
                legend("Overlap with unit","Accuracy of cluster","Proportion of Cluster's Spike That Belong To Unit");
            end
            if max_overlap_with_unit_percentage(k) >= min_unit_appearence_threshold
                tp_or_fp = "TRUE POSITIVE";
            else
                tp_or_fp = "FALSE POSITIVE";
            end
            title("ZSc:"+string(z_score(k))+" "+tetrode(k) + " Clus:"+string(cluster(k)) +" SNR:"+ string(SNR(k))+" "+tp_or_fp);
            b(1).Labels = b(1).YData;
            b(2).Labels = b(2).YData;
            b(3).Labels = b(3).YData;
            ylim([0,100]);
        end

        number_of_dims = size(table_of_best_rep_no_negatives{1,"Channels"}{1},1);
        sgtitle(["Ideal Dims Pass Unit: "+string(unit_of_max_overlap),"# Dims:"+string(number_of_dims)]);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% plot the blind pass results for the same unit
        all_appearences_of_this_unit = blind_pass_table(blind_pass_table{:,"Max Overlap Unit"} == unit_of_max_overlap,:);
        if size(all_appearences_of_this_unit,1)==0
            continue;
        end
        cluster =all_appearences_of_this_unit{:,"Cluster"};
        z_score = all_appearences_of_this_unit{:,"Z Score"};
        tetrode = all_appearences_of_this_unit{:,"Tetrode"};
        max_overlap_with_unit_percentage = all_appearences_of_this_unit{:,"Max Overlap % With Unit"};

        overlap_perc_with_unit = all_appearences_of_this_unit{:,"Max Overlap % With Unit"};
        ts_of_cluster = timestamp_array(all_appearences_of_this_unit{:,"idx of its location in arrays_table_of_best_representation"});

        gt_of_max_overlap_unit = ground_truth{unit_of_max_overlap};
        ts_of_max_overlap_unit = timestamps(gt_of_max_overlap_unit).';

        accuracy_for_all_appearences = nan(1,size(all_appearences_of_this_unit,1));
        proportion_of_cluster_spikes_that_belong_to_unit  = nan(1,size(all_appearences_of_this_unit,1));
        for k=1:size(all_appearences_of_this_unit,1)
            tp_count = get_tp_count_given_a_tdelta_hpc(ts_of_max_overlap_unit,ts_of_cluster{k},0.004); %in both cluster and unit
            fp_count = length(ts_of_cluster{k}) - tp_count; %in cluster but not in unit
            fn_count = length(ts_of_max_overlap_unit) - tp_count; %in unit but not in cluster
            accuracy_for_all_appearences(k) = (tp_count / (fn_count + tp_count + fp_count)) * 100;
            proportion_of_cluster_spikes_that_belong_to_unit(k) = (tp_count / size(ts_of_cluster{k},1))*100;
        end
        SNR = blind_pass_table{:,"SNR"};
        figure('units','normalized','outerposition',[0 0 0.5 1])

        for k=1:size(all_appearences_of_this_unit,1)
            subplot(1,size(accuracy_for_all_appearences,2),k)
            data = [overlap_perc_with_unit(k) NaN NaN; NaN accuracy_for_all_appearences(k) NaN;NaN NaN proportion_of_cluster_spikes_that_belong_to_unit(k)];
            b =bar(data);
            if k==1
                legend("Overlap with unit","Accuracy of cluster","Proportion of Cluster's Spike That Belong To Unit");
            end
            if max_overlap_with_unit_percentage(k) >= min_unit_appearence_threshold
                tp_or_fp = "TRUE POSITIVE";
            else
                tp_or_fp = "FALSE POSITIVE";
            end
            title("ZSc:"+string(z_score(k))+" "+tetrode(k) + " Clus:"+string(cluster(k)) +" SNR:"+ string(SNR(k))+" "+tp_or_fp);
            b(1).Labels = b(1).YData;
            b(2).Labels = b(2).YData;
            b(3).Labels = b(3).YData;
            ylim([0,100]);
        end

        number_of_dims = size(blind_pass_table{1,"Channels_table_of_channels"},2);
        sgtitle(["Blind Pass Unit: "+string(unit_of_max_overlap),"# Dims:"+string(number_of_dims)]);
        close all;

    end



end


end