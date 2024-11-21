function [classification_of_clusters,tetrode_and_cluster_number] = grade_clusters(generic_dir_with_grades,generic_dir_with_outputs,optional_z_scores,list_of_tetrodes_to_check,debug,relevant_grades,relevant_grade_names)
%relevant grades include
%2 cv 2
%3 percent short isi 3
%4 incompleteness 4
%8 template matching 8
%9 min bhat 9
%28 skewness of cluster
%29 measure the difference between the cluster's individual spikes and the
%cluster's spike templates
%30 Incompleteness using histogram symmetry
%31 Classification of cluster amplitude
%32 classification of cluster amplitude based only on rep wire
%34 min bhat distance from all the clusters in the current configuration which are likely to be co activation

%possible classifications
%probably a neuron - passes all tests that I care about so far
%might be a neuron - doesn't pass all the test, but is saved by its bhat distance from clusters identified as multiunit activity
%probably multi unit activity - a cluster which does not tie to a neuron, but may tie to a helpful multi unit activity cluster, therefore we do not purge it

classification_of_clusters = [];
tetrode_and_cluster_number = [];
art_tetr_array = build_artificial_tetrode();
default_z_score = optional_z_scores(1);
have_tried_lower_cutting_threshold = 0;
for tetrode_counter=18:length(list_of_tetrodes_to_check)
    current_tetrode = list_of_tetrodes_to_check(tetrode_counter);
    channels_of_curr_tetr = art_tetr_array(tetrode_counter,:);
    dir_with_grades = generic_dir_with_grades + " "+string(default_z_score) + " grades";
    dir_with_outputs = generic_dir_with_outputs +string(default_z_score);
    default_z_score = optional_z_scores(1);
    [current_grades,~,aligned,~,idx_b4_filt] = import_data(dir_with_grades,dir_with_outputs,current_tetrode);
    if any(isnan(current_grades))
        continue;
    end
    list_of_clusters = 1:length(idx_b4_filt);
    idx_aft_filt = cell(1,length(idx_b4_filt));
    current_clusters_category = [];
    for cluster_counter=1:size(current_grades,1)
        current_cluster_grades = current_grades(cluster_counter,:);
        if current_cluster_grades(2) < 0.1 && current_cluster_grades(31) > 1 && current_cluster_grades(30) < 7 && current_cluster_grades(31) > 1
            current_clusters_category = [current_clusters_category;"Probably A Neuron c1"];
            idx_aft_filt{cluster_counter} = idx_b4_filt{cluster_counter};
        elseif current_cluster_grades(2) < 0.1 && current_cluster_grades(31) > 1 && current_cluster_grades(30) < 7 && current_cluster_grades(32) > 1
           current_clusters_category = [current_clusters_category;"Probably A Neuron c2"];
            idx_aft_filt{cluster_counter} = idx_b4_filt{cluster_counter};
        elseif current_cluster_grades(34) > 4 && current_cluster_grades(33) ~=1
            current_clusters_category =[current_clusters_category;"Might Be a Neuron c3"];
            idx_aft_filt{cluster_counter} = idx_b4_filt{cluster_counter};
        elseif current_cluster_grades(33) == 1
            current_clusters_category = [current_clusters_category;"Probably Multi Unit Activity c4"];
            idx_aft_filt{cluster_counter} = idx_b4_filt{cluster_counter};
        elseif current_cluster_grades(33) == 2 && current_cluster_grades(33) 
            current_clusters_category = [current_clusters_category;"Might Be Multi Unit Activity c5"];
            idx_aft_filt{cluster_counter} = idx_b4_filt{cluster_counter};
        else
            current_clusters_category = [current_clusters_category;"No category"];
            list_of_clusters(cluster_counter) = NaN;
        end
        classification_of_clusters = [classification_of_clusters;current_clusters_category];
        tetrode_and_cluster_number = [tetrode_and_cluster_number; string(current_tetrode)+"_"+string(cluster_counter)];
    end
    list_of_clusters(isnan(list_of_clusters)) = [];

    %in the case that no clusters were found try again using a lower
    %cutting threshold than the current one
    %can also be triggered in current_grades has an inf, which would only
    %happen if there was no multi unit activity, which is a flag
    if (isempty(list_of_clusters) || any(isinf(current_grades(:,34)),"all")) && ~have_tried_lower_cutting_threshold
        tetrode_counter = tetrode_counter-1; %modify the tetrode counter as to repeat the current grading with the next lowest cutting threshold
        default_z_score = optional_z_scores(2); % lower the cutting threshold
        have_tried_lower_cutting_threshold = 1;
        if isempty(list_of_clusters)
            disp("Min Z Score of "+string(optional_z_scores(1)) + " still didn't return any clusters, lowering threshold again")
        end
        if any(isinf(current_grades(:,34)),"all")
            disp("Min Z Score of "+string(optional_z_scores(1)) + " still didn't return muli unit clusters, lowering threshold again")
        end
    elseif (isempty(list_of_clusters) || any(isinf(current_grades(:,34)),"all")) && have_tried_lower_cutting_threshold
        %if you've already tried a lower cutting threshold, but still
        %haven't gotten anything try the next lowest cutting threshold
        if isempty(list_of_clusters)
            disp("Min Z Score of "+string(optional_z_scores(2)) + " still didn't return any clusters, lowering threshold again")
        end
        if any(isinf(current_grades(:,34)),"all")
            disp("Min Z Score of "+string(optional_z_scores(2)) + " still didn't return muli unit clusters, lowering threshold again")
        end

        tetrode_counter = tetrode_counter-1; %modify the tetrode counter as to repeat the current grading with the next lowest cutting threshold
        default_z_score = optional_z_scores(3); % lower the cutting threshold
        have_tried_lower_cutting_threshold = 1;
    end
    if debug
        clc;
        disp(current_clusters_category);
        plot_the_clusters_ver_2(1:length(idx_b4_filt),channels_of_curr_tetr,idx_b4_filt,"Min Z Score "+ string(default_z_score)+"Before",current_grades,aligned,relevant_grades,relevant_grade_names);
        plot_the_clusters_ver_3(list_of_clusters,channels_of_curr_tetr,idx_aft_filt,"Min Z Score "+string(default_z_score) +"After",current_grades,aligned,relevant_grades,relevant_grade_names,current_clusters_category);
    end
    close all;
end

end