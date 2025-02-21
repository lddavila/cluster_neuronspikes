function [clusters_which_survive_purge,names_of_tetrodes_clusters_belong_to] = filter_noise_clusters(debug,conditions,dir_with_grades,dir_with_outputs,ground_truth,timestamps,relevant_grades,check_against_values,relevant_grade_names)
art_tetr_array = build_artificial_tetrode();
list_of_tetrodes = strcat("t",string(1:285));
clusters_which_survive_purge = cell(1,size(art_tetr_array,1));
names_of_tetrodes_clusters_belong_to =cell(1,size(art_tetr_array,1));

for i=1:length(list_of_tetrodes)
    current_tetrode = list_of_tetrodes(i);
    channels_of_curr_tetr = art_tetr_array(i,:);
    %get data before filtering
    [grades_b4_filt,~,aligned,reg_timestamps,idx_b4_filt] = import_data(dir_with_grades,dir_with_outputs,current_tetrode);
    if any(isnan(grades_b4_filt))
        continue;
    end
    list_of_clusters = 1:length(idx_b4_filt);
    for cluster_counter=1:length(idx_b4_filt)
        for condition_counter=1:length(conditions)
            current_condition = conditions{condition_counter};
            current_grade = relevant_grades(condition_counter);
            check_against = check_against_values(condition_counter);
            if ~(current_condition(grades_b4_filt(cluster_counter,current_grade),check_against)) %if they fail any of the tests
                list_of_clusters(cluster_counter) = NaN;
            end
        end
    end
    
    names_of_tetrodes_clusters_belong_to{i} = current_tetrode;


    list_of_clusters(isnan(list_of_clusters)) = [];
    clusters_which_survive_purge{i} = list_of_clusters;
    idx_aft_filt = cell(1,length(1:size(grades_b4_filt,1)));
    for p=1:length(idx_aft_filt)
        if ismember(p,list_of_clusters)
            idx_aft_filt{p} = idx_b4_filt{p};
        end
    end
    %grades_aft_filt = grades_b4_filt(list_of_clusters,relevant_grades);
    if debug
        plot_the_clusters(1:length(idx_b4_filt),channels_of_curr_tetr,idx_b4_filt,"Before",reg_timestamps,ground_truth,timestamps,grades_b4_filt,aligned,relevant_grades,relevant_grade_names);
        plot_the_clusters(list_of_clusters,channels_of_curr_tetr,idx_aft_filt,"After",reg_timestamps,ground_truth,timestamps,grades_b4_filt,aligned,relevant_grades,relevant_grade_names);
    end


close all;
end

end