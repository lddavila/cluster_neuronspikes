function [updated_table_of_other_appearences] = update_table_of_other_appearences(old_table_of_other_appearences,what_you_want_to_update,contamination_table,parameters_to_use)
updated_table_of_other_appearences = old_table_of_other_appearences;

for j=1:size(what_you_want_to_update,1)
    if what_you_want_to_update(j)=="categorization"
        %use this loop to update the classification of each cluster in the category
        for i=1:size(old_table_of_other_appearences,1)
            current_z_score = old_table_of_other_appearences{i,"Z Score"};
            current_tetrode = old_table_of_other_appearences{i,"Tetrode"};
            current_cluster_num = old_table_of_other_appearences{i,"Cluster #"};
            % current_overlap_data_dict = old_table_of_other_appearences{i,"Other Appearence Info"};

            c1 = contamination_table{:,"Tetrode"} == current_tetrode;
            c2 = contamination_table{:,"Z Score"} == current_z_score;
            c3 = contamination_table{:, "Cluster"} == current_cluster_num;

            grades_of_current_cluster = contamination_table{c1 & c2 & c3,"grades"}{1};

            new_cluster_category = classify_clusters_based_on_grades_ver_2(grades_of_current_cluster);
            updated_table_of_other_appearences{i,"Classification"} = new_cluster_category;
        end

        %use this loop to update the classification of all the overlap
        %clusters with their new values
        for i=1:size(old_table_of_other_appearences,1)
            current_z_score = old_table_of_other_appearences{i,"Z Score"};
            current_tetrode = old_table_of_other_appearences{i,"Tetrode"};
            current_cluster_num = old_table_of_other_appearences{i,"Cluster #"};
            current_overlap_data_dict = updated_table_of_other_appearences{i,"Other Appearence Info"};




            % other_appearences_dict = containers.Map("KeyType",'char','ValueType','any');
            % other_appearences_dict("cluster number of other appearences") = other_cluster_numbers_of_this_cluster;
            % other_appearences_dict("tetrodes of other appearences") = other_tetrodes_where_cluster_appears;
            % other_appearences_dict("overlap percentages of other appearences") = overlap_percentages_of_this_cluster;
            % other_appearences_dict("Z score of other appearences") = other_z_scores_of_this_cluster;
            % other_appearences_dict("classification of other appearences") = classification_of_other_appearences;
            other_appearences_clusters_array = current_overlap_data_dict("cluster number of other appearences");
            other_appearences_tetrode_array= current_overlap_data_dict("tetrodes of other appearences");
            other_appearences_overlap_percentage_array= current_overlap_data_dict("overlap percentages of other appearences");
            other_appearences_z_score_array= current_overlap_data_dict("Z score of other appearences");
            other_appearences_classification_array= current_overlap_data_dict("classification of other appearences");

            %use this if statement to ensre all the data to be updated is
            %the same length
            %if they're not then that indicates something is wrong
            if length(other_appearences_classification_array) ~= length(other_appearences_z_score_array) || length(other_appearences_classification_array) ~= length(other_appearences_overlap_percentage_array) ||length(other_appearences_classification_array) ~= length(other_appearences_tetrode_array) ||length(other_appearences_classification_array) ~= length(other_appearences_z_score_array) ||length(other_appearences_classification_array) ~= length(other_appearences_clusters_array)
                ME = MException("at least 1 of the other appearence data arrays have incompatatible data sizes");
                disp("length:"+string(length(other_appearences_clusters_array)));
                disp("length:"+string(length(other_appearences_tetrode_array)));
                disp("length:"+string(length(other_appearences_overlap_percentage_array)));
                disp("length:"+string(length(other_appearences_z_score_array)));
                disp("length:"+string(length(other_appearences_classification_array)));
                throw(ME);
            end

            %now cycle through the other_appearences_classification data
            %and update it with new classification

            for k=1:length(other_appearences_classification_array)
                other_appear_tetr = other_appearences_tetrode_array(k);
                other_appear_z_sc = other_appearences_clusters_array(k);
                other_appear_class = other_appearences_classification_array(k);
                other_appear_clust = other_appearences_clusters_array(k);

                c1 = updated_table_of_other_appearences{:,"Tetrode"} == other_appear_tetr;
                c2 = updated_table_of_other_appearences{:,"Z Score"} == other_appear_z_sc;
                c3 = updated_table_of_other_appearences{:, "Cluster"} == other_appear_clust;

                other_appearences_classification_array(k) = updated_table_of_other_appearences{c1 & c2 & c3,"Classification"};

            end
            current_overlap_data_dict("classification of other appearences") =other_appearences_classification_array ;
            updated_table_of_other_appearences{i,"Other Appearence Info"} =current_overlap_data_dict;



        end
    elseif what_you_want_to_update(j) == "overlap"
        for i=1:size(old_table_of_other_appearences,1)
            current_z_score = old_table_of_other_appearences{i,"Z Score"};
            current_tetrode = old_table_of_other_appearences{i,"Tetrode"};
            current_cluster_num = old_table_of_other_appearences{i,"Cluster #"};
            current_overlap_data_dict = old_table_of_other_appearences{i,"Other Appearence Info"};

            c1 = contamination_table{:,"Tetrode"} == current_tetrode;
            c2 = contamination_table{:,"Z Score"} == current_z_score;
            c3 = contamination_table{:, "Cluster"} == current_cluster_num;

            grades_of_current_cluster = contamination_table{c1 & c2 & c3,"grades"}{1};


        end
    end



end
end