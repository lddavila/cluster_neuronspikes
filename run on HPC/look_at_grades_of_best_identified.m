function [] = look_at_grades_of_best_identified(list_of_tables,config,plotable_grades)
list_of_units = 1:config.NUM_OF_UNITS;
names_of_grades = config.NAMES_OF_CURR_GRADES;

ground_truth = importdata(config.GT_FP);
timestamps = importdata(config.TIMESTAMP_FP);
for i=1:length(list_of_units)
    unit_of_max_overlap = list_of_units(i);
    gt_of_max_overlap_unit = ground_truth{unit_of_max_overlap};
    ts_of_max_overlap_unit = timestamps(gt_of_max_overlap_unit).';


    array_of__first_table_fig_positions = [2   566   958   430;
        962   566   958   430;
        1922         566         958         430;
        2882         566         958         430];
    array_of__second_table_fig_positions = [2    50   958   430;
        962    50   958   430;
        1922          50         958         430;
        2882          50         958         430];

    for table_list_counter =1:length(list_of_tables)
        table_of_best_rep = list_of_tables{table_list_counter};
        rows_with_current_units =table_of_best_rep(table_of_best_rep{:,"Max Overlap Unit"} == list_of_units(i),:);
        mean_waveforms = rows_with_current_units{:,"Mean Waveform"};
        grades = rows_with_current_units{:,"grades"};
        if table_list_counter==1
            figure('Position',array_of__first_table_fig_positions(1,:));
        else
            figure('Position',array_of__second_table_fig_positions(1,:))
        end
        %plot the mean waveform
        for j=1:size(rows_with_current_units,1)
            %plot the mean waveforms
            subplot(size(rows_with_current_units,1),1,j)
            plot(mean_waveforms{j});
            title(string(rows_with_current_units{j,"Z Score"})+" "+rows_with_current_units{j,"Tetrode"}+" "+string(rows_with_current_units{j,"Cluster"})+" "+string(rows_with_current_units{j,"Max Overlap % With Unit"})+"% With Unit")


        end
        sgtitle("Unit: "+string(list_of_units(i)));


        if table_list_counter==1
            figure('Position',array_of__first_table_fig_positions(2,:));
        else
            figure('Position',array_of__second_table_fig_positions(2,:))
        end
        grades_in_single_matrix = [];
        legend_strings = [];
        %make the radar plot of grades
        for j=1:size(rows_with_current_units,1)
            % subplot(size(rows_with_current_units,1),1,j)
            %plot the mean waveforms

            % plot(mean_waveforms{j});
            % title(string("Zsc:"+rows_with_current_units{j,"Z Score"})+" "+rows_with_current_units{j,"Tetrode"}+" "+string(rows_with_current_units{j,"Cluster"}))
            current_grades = grades{j};

            x_label_strings ={} ;
            flattened_grades = [];
            for k=1:size(plotable_grades,2)
                if size(current_grades{plotable_grades(k)},2)==1 ||size(current_grades{plotable_grades(k)},2)==0
                    if names_of_grades(plotable_grades(k)) == "do not use"
                        continue
                    end
                    % if isinf(current_grades{plotable_grades(k)}) %|| isnan(current_grades{plotable_grades(k)})
                    %     continue;
                    % end
                    x_label_strings{end+1} = names_of_grades(plotable_grades(k));
                    if isempty(current_grades{plotable_grades(k)})
                        flattened_grades = [flattened_grades,NaN];
                    else
                        flattened_grades = [flattened_grades,current_grades{plotable_grades(k)}];
                    end

                else
                    for p=1:size(current_grades{plotable_grades(k)},2)
                        % if isinf(current_grades{plotable_grades(k)}(p)) %|| isnan(current_grades{plotable_grades(k)}(p))
                        %     continue;
                        % end
                        x_label_strings{end+1} =names_of_grades(plotable_grades(k))+"_dim_"+string(p);
                        flattened_grades = [flattened_grades,current_grades{plotable_grades(k)}(p)];
                    end
                end

            end
            % heatmap(flattened_grades,'ColorbarVisible','off');
            % for k=1:size(plotable_grades,2)
            %     plot_index = ((j-1)*size(plotable_grades,2)) + k;
            %     subplot(size(rows_with_current_units,1),length(plotable_grades),plot_index)
            %     bar(flattened_grades(k));
            % end


            grades_in_single_matrix = [grades_in_single_matrix;flattened_grades];
            legend_string =string(rows_with_current_units{j,"Z Score"})+" "+rows_with_current_units{j,"Tetrode"}+" "+string(rows_with_current_units{j,"Cluster"})+" "+string(rows_with_current_units{j,"Max Overlap % With Unit"})+"% With Unit" ;
            legend_strings =[legend_strings,legend_string];

        end
        [~,cols_to_remove] = find(isnan(grades_in_single_matrix) | isinf(grades_in_single_matrix));
        x_label_strings(cols_to_remove) = [];
        grades_in_single_matrix(:,cols_to_remove) = [];
        [lower_bound,upper_bound] = bounds(grades_in_single_matrix,1);
        upper_bound = upper_bound + .1;
        lower_bound = lower_bound - .1;
        axes_limits = [lower_bound;upper_bound];
        x_label_strings = string(x_label_strings);
        a =bar(x_label_strings,grades_in_single_matrix);
        for bar_counter=1:size(a,2)
            a(bar_counter).Labels = a(bar_counter).YData;
        end
        % spider_plot_R2019b(grades_in_single_matrix,'AxesLimits',axes_limits,'AxesLabels',x_label_strings,'AxesLabelsRotate', 'on','AxesRadial', 'off','AxesDisplay','data','AxesDataOffset', 0.1);
        legend(legend_strings,'Location','southoutside')

        %plot the cluster plots
        %helpful position vector 1922          50         958         946
        if table_list_counter==1
            figure('Position',array_of__first_table_fig_positions(3,:));
        else
            figure('Position',array_of__second_table_fig_positions(3,:))
        end
        generic_dir_with_grades = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass min z_score";
        generic_dir_with_outputs = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass_results min z_score";

        for j=1:size(rows_with_current_units,1)
            subplot(size(rows_with_current_units,1),1,j)
            current_z_score = rows_with_current_units{j,"Z Score"};
            current_cluster = rows_with_current_units{j,"Cluster"};
            current_tetrode = rows_with_current_units{j,"Tetrode"};
            channels_of_curr_tetr = rows_with_current_units{j,"Channels"};
            cluster_categories = rows_with_current_units{j,"Classification"};
            dir_with_grades = generic_dir_with_grades + " "+string(current_z_score) + " grades";
            current_grades = rows_with_current_units{j,"grades"}{1};
            first_dimension = current_grades{42};
            second_dimension = current_grades{43};
            dir_with_outputs = generic_dir_with_outputs +string(current_z_score);
            if table_list_counter==2
                continue;
            end
            [~,~,aligned,~,idx_b4_filt] = import_data_hpc(dir_with_grades,dir_with_outputs,current_tetrode,false);
            new_plot_proj_ver_5(idx_b4_filt(current_cluster),aligned,first_dimension,second_dimension,channels_of_curr_tetr,"","",1,cluster_categories,[first_dimension,second_dimension]);

        end
       
        



        %plot the accuracy plots

        %2882          50         958         946
        if table_list_counter==1
            figure('Position',array_of__first_table_fig_positions(4,:));
        else
            figure('Position',array_of__second_table_fig_positions(4,:))
        end
        accuracy_for_all_appearences = nan(size(rows_with_current_units,1));
        proportion_of_cluster_spikes_that_belong_to_unit = nan(size(rows_with_current_units,1));
        ts_of_cluster = rows_with_current_units{:,"Timestamps of spikes"};
        overlap_perc_with_unit = rows_with_current_units{:,"Max Overlap % With Unit"};
        for j=1:size(rows_with_current_units,1)
            tp_count = get_tp_count_given_a_tdelta_hpc(ts_of_max_overlap_unit,ts_of_cluster{j},0.004); %in both cluster and unit
            fp_count = length(ts_of_cluster{j}) - tp_count; %in cluster but not in unit
            fn_count = length(ts_of_max_overlap_unit) - tp_count; %in unit but not in cluster
            accuracy_for_all_appearences(j) = (tp_count / (fn_count + tp_count + fp_count)) * 100;
            proportion_of_cluster_spikes_that_belong_to_unit(j) = (tp_count / size(ts_of_cluster{j},1))*100;

        end
        for k=1:size(rows_with_current_units,1)
            subplot(size(accuracy_for_all_appearences,2),1,k)
            data = [overlap_perc_with_unit(k) NaN NaN; NaN accuracy_for_all_appearences(k) NaN;NaN NaN proportion_of_cluster_spikes_that_belong_to_unit(k)];
            b =bar(data);

            if k==1
                legend("Overlap with unit","Accuracy of cluster","Proportion of Cluster's Spike That Belong To Unit");
            end
            b(1).Labels = b(1).YData;
            b(2).Labels = b(2).YData;
            b(3).Labels = b(3).YData;
            ylim([0,100]);
        end
        % pause;
        % close all;
    end
    pause
    close all;
end
end