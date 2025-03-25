function [updated_table_of_other_appearences] = update_table_of_overlap(old_table_of_other_appearences,config)
updated_table_of_other_appearences = old_table_of_other_appearences;
if config.UPDATE_GRADES
    updated_table_of_other_appearences = update_grades_in_overlap_table(old_table_of_other_appearences,config);
end
if config.UPDATE_CLASSIFICATION
    updated_table_of_other_appearences =update_cluster_classification(updated_table_of_other_appearences); %update the classification of the clusters if necessary
end
if config.ONLY_NEURONS
    updated_table_of_other_appearences(~contains(updated_table_of_other_appearences{:,"Classification"},"Neuron","IgnoreCase",true),:) = [];
end



%use this loop to cycle through each item in your table of overlap and
%apply any conditions that are set in your config file
for i=1:size(updated_table_of_other_appearences,1)

    current_overlap_data_dict = updated_table_of_other_appearences{i,"Other Appearence Info"};
    current_overlap_data_dict = current_overlap_data_dict{1};
    current_cluster_waveform = old_table_of_other_appearences{i,"Mean Waveform"}{1};

    other_appearences_clusters_array = current_overlap_data_dict("cluster number of other appearences");
    other_appearences_tetrode_array= current_overlap_data_dict("tetrodes of other appearences");
    other_appearences_overlap_percentage_array= current_overlap_data_dict("overlap percentages of other appearences");
    other_appearences_z_score_array= current_overlap_data_dict("Z score of other appearences");
    other_appearences_classification_array= current_overlap_data_dict("classification of other appearences");

    %ensure that there are no empty values (there shouldn't be but
    %just in case)
    other_appearences_clusters_array(ismissing(other_appearences_clusters_array)) = [];
    other_appearences_clusters_array(other_appearences_clusters_array=="")= [];
    other_appearences_tetrode_array(other_appearences_tetrode_array=="") = [];
    other_appearences_overlap_percentage_array(other_appearences_overlap_percentage_array=="") = [];
    other_appearences_z_score_array(ismissing(other_appearences_z_score_array)) = [];
    other_appearences_z_score_array(other_appearences_z_score_array=="") = [];
    other_appearences_classification_array(other_appearences_classification_array=="") = [];


    if length(other_appearences_classification_array) ~= length(other_appearences_z_score_array) || length(other_appearences_classification_array) ~= length(other_appearences_overlap_percentage_array) ||length(other_appearences_classification_array) ~= length(other_appearences_tetrode_array) ||length(other_appearences_classification_array) ~= length(other_appearences_z_score_array) ||length(other_appearences_classification_array) ~= length(other_appearences_clusters_array)
        disp("length of other_appearences_clusters_array:"+string(length(other_appearences_clusters_array)));
        disp("length of other_appearences_tetrode_array:"+string(length(other_appearences_tetrode_array)));
        disp("length of other_appearences_overlap_percentage_array:"+string(length(other_appearences_overlap_percentage_array)));
        disp("length of other_appearences_z_score_array:"+string(length(other_appearences_z_score_array)));
        disp("length of other_appearences_classification_array:"+string(length(other_appearences_classification_array)));
        ME = MException("at least 1 of the other appearence data arrays have incompatatible data sizes","");

        throw(ME);
    end

    for k=1:length(other_appearences_overlap_percentage_array)
        current_overlap_percentage = str2double(strrep(other_appearences_overlap_percentage_array(k),"%",""));
        current_classification = other_appearences_classification_array(k);
        other_app_z_sc = str2double(other_appearences_z_score_array(k));
        other_app_tet = other_appearences_tetrode_array(k);
        other_app_clust = str2double(other_appearences_clusters_array(k));

        c1 = updated_table_of_other_appearences{:,"Tetrode"} == other_app_tet;
        c2 = updated_table_of_other_appearences{:,"Z Score"} == other_app_z_sc;
        c3 = updated_table_of_other_appearences{:, "Cluster"} == other_app_clust;
        if isempty(updated_table_of_other_appearences{c1 & c2 & c3,"Mean Waveform"})
            other_appearences_clusters_array(k) = NaN;
            other_appearences_tetrode_array(k) = "";
            other_appearences_overlap_percentage_array(k) = "";
            other_appearences_z_score_array(k) = NaN;
            other_appearences_classification_array(k) ="";
            continue;
        else
        other_app_mean_waveform =updated_table_of_other_appearences{c1 & c2 & c3,"Mean Waveform"}{1};
        end

        
        if size(current_cluster_waveform,2) ~= size(other_app_mean_waveform,2)
            current_euc_dist_between_waveforms = 10000000;
        else
            current_euc_dist_between_waveforms = norm(current_cluster_waveform - other_app_mean_waveform);
        end
        
        if (config.ONLY_OVERLAP_WITH_NEURONS &&~contains(current_classification,"Neuron","IgnoreCase",true)) || current_overlap_percentage < config.OVERLAP || current_euc_dist_between_waveforms < config.MAX_EUC_DIST 
            other_appearences_clusters_array(k) = NaN;
            other_appearences_tetrode_array(k) = "";
            other_appearences_overlap_percentage_array(k) = "";
            other_appearences_z_score_array(k) = NaN;
            other_appearences_classification_array(k) ="";
        end

     



    end
    other_appearences_clusters_array(other_appearences_clusters_array=="") =[];
    other_appearences_tetrode_array(other_appearences_tetrode_array=="") = [];
    other_appearences_overlap_percentage_array(other_appearences_overlap_percentage_array=="") = [];
    other_appearences_z_score_array(""==other_appearences_z_score_array) = [];
    other_appearences_classification_array(other_appearences_classification_array=="") = [];

    current_overlap_data_dict("cluster number of other appearences") = other_appearences_clusters_array;
    current_overlap_data_dict("tetrodes of other appearences") =other_appearences_tetrode_array;
    current_overlap_data_dict("overlap percentages of other appearences") = other_appearences_overlap_percentage_array;
    current_overlap_data_dict("Z score of other appearences") = other_appearences_z_score_array;
    current_overlap_data_dict("classification of other appearences") = other_appearences_classification_array;

    updated_table_of_other_appearences{i,"Other Appearence Info"} = {current_overlap_data_dict};
    fprintf("update_table_of_overlap.m Finished %i/%i\n",i,size(updated_table_of_other_appearences,1));

end




end