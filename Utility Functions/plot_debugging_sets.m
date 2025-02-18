function [] = plot_debugging_sets(dir_of_precomputed,table_of_accuracy_of_clusters,min_grade,grades_to_check,plot_the_figures,time_delta,plot_the_clusters_that_didnt_overlap_with_any_units)
unique_list_of_tetrodes_and_clusters = unique(table_of_accuracy_of_clusters{:,"og_tetr_and_clust_num"},"stable");
unique_units = unique(table_of_accuracy_of_clusters{:,"unit_id"},"stable");

for current_grade_counter=1:length(grades_to_check)
    number_of_times_the_same_unit_is_repeated = 0;
    array_of_data = reshape(table_of_accuracy_of_clusters{:,(grades_to_check(current_grade_counter))},length(unique_units),[]);
    array_of_clusters_never_tied_to_a_unit = 1:size(array_of_data,2);
    %for each row, check if there's only one value above the min grade
    unit_names = strcat("Unit:",string(unique(table_of_accuracy_of_clusters{:,"unit_id"},"stable")));
    number_of_times_repeated = nan(size(unit_names,1),1);
    number_of_units_not_found = 0;
    for i=1:size(array_of_data,1)
        number_of_clusters_representing_same_unit = sum(array_of_data(i,:)>min_grade);
        indexes_of_those_clusters = array_of_data(i,:)>min_grade;
        array_of_clusters_never_tied_to_a_unit(indexes_of_those_clusters) = nan;
        %if there are more than 1 cluster representing the same unit we make
        %plots to see why
        number_of_times_repeated(i) = number_of_clusters_representing_same_unit;
        if number_of_clusters_representing_same_unit==0
            number_of_units_not_found = number_of_units_not_found+1;
        end

        if number_of_clusters_representing_same_unit>1 && plot_the_figures
            number_of_times_the_same_unit_is_repeated = number_of_times_the_same_unit_is_repeated+1;

            cluster_data = split(unique_list_of_tetrodes_and_clusters(indexes_of_those_clusters),"_");
            tetrodes = cluster_data(:,1);
            cluster_number = str2double(cluster_data(:,2));
            z_scores = cluster_data(:,4);
            empty_col = nan(1,size(cluster_data,1));
            table_of_only_neurons = table(empty_col.',tetrodes,cluster_number,z_scores);
            generic_dir_with_grades = dir_of_precomputed+"\initial_pass min z_score";
            generic_dir_with_outputs = dir_of_precomputed+"\initial_pass_results min z_score";
            [~,~,array_of_aligned,array_of_ts,array_of_idxs] = get_data_of_tetrodes_containing_neurons(table_of_only_neurons,generic_dir_with_grades,generic_dir_with_outputs);
            art_tetr_array = build_artificial_tetrode();
            %plot the overlap between the cluster
            table_of_overlapping_clusters = check_timestamp_overlap_between_clusters_ver_3(table_of_only_neurons,array_of_ts,0,time_delta);
            disp(table_of_overlapping_clusters);

            %plot the configurations which represent the same unit
            if plot_the_figures
                for j=1:size(table_of_only_neurons,1)
                    figure
                    channels_of_current_tetrode = art_tetr_array(str2double(strrep(table_of_only_neurons{j,"tetrodes"},"t","")),:);
                    plot_counter=1;
                    idx = array_of_idxs{j};
                    aligned = array_of_aligned{j};
                    current_z_score = table_of_only_neurons{j,"z_scores"};
                    for first_dimension = 1:length(channels_of_current_tetrode)
                        for second_dimension = first_dimension+1:length(channels_of_current_tetrode)
                            subplot(2,3,plot_counter);
                            new_plot_proj_ver_4(idx,aligned,first_dimension,second_dimension,channels_of_current_tetrode,table_of_only_neurons{j,"tetrodes"},current_z_score,plot_counter);
                            plot_counter = plot_counter+1;
                        end

                    end
                    sgtitle([table_of_only_neurons{j,"tetrodes"}+" Cluster:"+string(table_of_only_neurons{j,"cluster_number"}+" Z Score:"+string(table_of_only_neurons{j,"z_scores"})),"Represents Unit:"+string(unique_units(i)),"Channels:"+strjoin(string(channels_of_current_tetrode))]);

                end
                % close all;
            end
        else


        end
    end
    array_of_clusters_never_tied_to_a_unit(isnan(array_of_clusters_never_tied_to_a_unit)) = [];
    if plot_the_clusters_that_didnt_overlap_with_any_units
        cluster_data = split(unique_list_of_tetrodes_and_clusters,"_");
        tetrodes = cluster_data(:,1);
        cluster_number = str2double(cluster_data(:,2));
        z_scores = cluster_data(:,4);
        for j=1:length(array_of_clusters_never_tied_to_a_unit)
            current_z_score = z_scores(array_of_clusters_never_tied_to_a_unit(j));
            current_tetrode = tetrodes(array_of_clusters_never_tied_to_a_unit(j));
            current_cluster = cluster_number(array_of_clusters_never_tied_to_a_unit(j));

            generic_dir_with_grades = dir_of_precomputed+"\initial_pass min z_score";
            generic_dir_with_outputs = dir_of_precomputed+"\initial_pass_results min z_score";
            dir_with_grades = generic_dir_with_grades + " "+string(current_z_score) + " grades";
            dir_with_outputs = generic_dir_with_outputs +string(current_z_score);
            [grades,outputs,aligned,timestamp,idx] = import_data(dir_with_grades,dir_with_outputs,current_tetrode);

            figure
            art_tetr_array = build_artificial_tetrode();
            channels_of_current_tetrode = art_tetr_array(str2double(strrep(current_tetrode,"t","")),:);
            plot_counter=1;


            for first_dimension = 1:length(channels_of_current_tetrode)
                for second_dimension = first_dimension+1:length(channels_of_current_tetrode)
                    subplot(2,3,plot_counter);
                    new_plot_proj_ver_4(idx,aligned,first_dimension,second_dimension,channels_of_current_tetrode,current_tetrode,current_z_score,plot_counter);
                    plot_counter = plot_counter+1;
                end

            end
            sgtitle([string(current_tetrode)+" Cluster Not Tied:"+string(current_cluster)+" Z Score:"+string(current_z_score),"Channels:"+strjoin(string(channels_of_current_tetrode)),"Rep Channel:"+string(channels_of_current_tetrode(grades(current_cluster,42)))]);
            input("Hit Enter to get the next figure")
            close all

        end
    end
end




%for each column, check if there's only one value above the min grade
for i=1:size(array_of_data,2)
    number_of_units_cluster_represents = sum(array_of_data(:,i)>min_grade);
    if number_of_units_cluster_represents>1
        disp("Multiple units are represented by a single cluster")
    end

end


table_of_repeated = table(unit_names,number_of_times_repeated);
disp(table_of_repeated)
disp("Number Of Times A Single Unit Was Repeated: "+string(number_of_times_the_same_unit_is_repeated));
disp("Number Of Units Not Found:"+string(number_of_units_not_found))
end