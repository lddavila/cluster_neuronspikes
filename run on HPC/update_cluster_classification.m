function [updated_table_of_other_appearences] = update_cluster_classification(old_table_of_other_appearences)
updated_table_of_other_appearences = old_table_of_other_appearences;
%use this loop to update the classification of each cluster in the category
for i=1:size(updated_table_of_other_appearences,1)
    grades_of_current_cluster = old_table_of_other_appearences{i,"grades"}{1};
    new_cluster_category = classify_clusters_based_on_grades_ver_2(grades_of_current_cluster);
    updated_table_of_other_appearences{i,"Classification"} = new_cluster_category;
    disp("update_cluster_classification First Part Finished "+string(i)+"/"+size(updated_table_of_other_appearences,1));
end

%use this loop to update the classification of all the overlap
%clusters with their new values
for i=1:size(updated_table_of_other_appearences,1)
    current_overlap_data_dict = updated_table_of_other_appearences{i,"Other Appearence Info"};
    current_overlap_data_dict = current_overlap_data_dict{1};

    other_appearences_clusters_array = current_overlap_data_dict("cluster number of other appearences");
    other_appearences_tetrode_array= current_overlap_data_dict("tetrodes of other appearences");
    other_appearences_overlap_percentage_array= current_overlap_data_dict("overlap percentages of other appearences");
    other_appearences_z_score_array= current_overlap_data_dict("Z score of other appearences");
    other_appearences_classification_array= current_overlap_data_dict("classification of other appearences");

    other_appearences_clusters_array(other_appearences_clusters_array=="") = [];
    other_appearences_tetrode_array(other_appearences_tetrode_array=="") = [];
    other_appearences_overlap_percentage_array(other_appearences_overlap_percentage_array=="") = [];
    other_appearences_z_score_array(other_appearences_z_score_array=="") = [];
    other_appearences_classification_array(other_appearences_classification_array=="") = [];

    other_appearences_clusters_array(ismissing(other_appearences_clusters_array)) = [];
    % other_appearences_tetrode_array(isnan(other_appearences_tetrode_array)) = [];
    % other_appearences_overlap_percentage_array(isnan(other_appearences_overlap_percentage_array=="")) = [];
    other_appearences_z_score_array(ismissing(other_appearences_z_score_array)) = [];
    % other_appearences_classification_array(isnan(other_appearences_classification_array)) = [];

    %use this if statement to ensre all the data to be updated is
    %the same length
    %if they're not then that indicates something is wrong
    if length(other_appearences_classification_array) ~= length(other_appearences_z_score_array) || length(other_appearences_classification_array) ~= length(other_appearences_overlap_percentage_array) ||length(other_appearences_classification_array) ~= length(other_appearences_tetrode_array) ||length(other_appearences_classification_array) ~= length(other_appearences_z_score_array) ||length(other_appearences_classification_array) ~= length(other_appearences_clusters_array)
        disp("length of other_appearences_clusters_array:"+string(length(other_appearences_clusters_array)));
        disp("length of other_appearences_tetrode_array:"+string(length(other_appearences_tetrode_array)));
        disp("length of other_appearences_overlap_percentage_array:"+string(length(other_appearences_overlap_percentage_array)));
        disp("length of other_appearences_z_score_array:"+string(length(other_appearences_z_score_array)));
        disp("length of other_appearences_classification_array:"+string(length(other_appearences_classification_array)));
        ME = MException('at_least_1_of_the_other_appearence_data_arrays_have_incompatatible_data_sizes','check the size');
        throw(ME);
    end

    %now cycle through the other_appearences_classification data
    %and update it with new classification
    for k=1:length(other_appearences_classification_array)
        other_appear_tetr = other_appearences_tetrode_array(k);
        other_appear_z_sc = other_appearences_z_score_array(k);
        other_appear_clust = other_appearences_clusters_array(k);

        c1 = updated_table_of_other_appearences{:,"Tetrode"} == other_appear_tetr;
        c2 = updated_table_of_other_appearences{:,"Z Score"} == str2double(other_appear_z_sc);
        c3 = updated_table_of_other_appearences{:, "Cluster"} == str2double(other_appear_clust);

        other_appearences_classification_array(k) = updated_table_of_other_appearences{c1 & c2 & c3,"Classification"};

    end
    current_overlap_data_dict("classification of other appearences") =other_appearences_classification_array ;
    updated_table_of_other_appearences{i,"Other Appearence Info"} ={current_overlap_data_dict};
    disp("update_cluster_classification Second Part Finished "+string(i)+"/"+size(updated_table_of_other_appearences,1));
end
end