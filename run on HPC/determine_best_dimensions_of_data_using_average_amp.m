function [table_with_sorted_channels] = determine_best_dimensions_of_data_using_average_amp(table_of_best_representation,updated_table_of_overlap,config)
%this version does it based on the z score
table_with_best_channels = table(nan(size(table_of_best_representation,1),1), ...
    repelem("",size(table_of_best_representation,1),1), ...
    nan(size(table_of_best_representation,1),1), ...
    cell(size(table_of_best_representation,1),1), ...
    cell(size(table_of_best_representation,1),1) ...
    ,'VariableNames',["Z Score","Tetrode","Cluster","Sorted Channels","Sorted Amp"]);
for i=1:size(table_of_best_representation,1)

    table_with_best_channels{i,"Tetrode"} = table_of_best_representation{i,"Tetrode"};
    table_with_best_channels{i,"Z Score"} = table_of_best_representation{i,"Z Score"};
    table_with_best_channels{i,"Cluster"} = table_of_best_representation{i,"Cluster"};

    current_overlap_data_dict = table_of_best_representation{i,"Other Appearence Info"}{1};
    grades_of_current_best_rep = cell2mat(table_of_best_representation{i,"grades"});


    snr_of_current_best_rep = grades_of_current_best_rep;
    channels_of_current_best_rep = table_of_best_representation{i,"Channels_table_of_channels"};
    other_appearences_tetrodes = current_overlap_data_dict("tetrodes of other appearences");
    other_appearence_z_score = current_overlap_data_dict("Z score of other appearences");
    other_appearence_clusters = current_overlap_data_dict("cluster number of other appearences");
    tetrode_numbers = str2double(strrep(other_appearences_tetrodes,"t",""));
    channels_of_other_tetrodes = config.ART_TETR_ARRAY(tetrode_numbers,:);

    c1 = updated_table_of_overlap{:,"Tetrode"}==other_appearences_tetrodes;
    c2 = updated_table_of_overlap{:,"Z Score"}==str2double(other_appearence_z_score);
    c3 = updated_table_of_overlap{:,"Cluster"}==str2double(other_appearence_clusters);

    [rows_with_grades,~] = find(c1 & c2 & c3);


    grades_of_other_appearences = cell2mat(updated_table_of_overlap{rows_with_grades,"grades"});
    if isempty(grades_of_other_appearences)
        table_with_best_channels{i,"Sorted Channels"} = {channels_of_current_best_rep};
        table_with_best_channels{i,"Sorted SNR"} = {snr_of_current_best_rep};
        disp("determine_best_dimensions_of_data: "+string(i)+"/"+string(size(table_of_best_representation,1)));
        continue;
    end

    snr_of_other_appearences = grades_of_other_appearences(:,45:48);

    channels_of_br_and_oa_comb = [channels_of_current_best_rep;channels_of_other_tetrodes];
    snr_of_br_and_oa_comb = [snr_of_current_best_rep;snr_of_other_appearences];

    Channels =reshape(channels_of_br_and_oa_comb,[],1);
    SNR = reshape(snr_of_br_and_oa_comb,[],1);

    table_of_channels_and_snr = table(Channels,SNR);
    sorted_channels_as_col = sortrows(table_of_channels_and_snr,["Channels","SNR"]);

    unique_channels = unique(sorted_channels_as_col{:,"Channels"});
    max_of_unique_channels = nan(1,length(unique_channels));
    for j=1:length(unique_channels)
        current_unique_channel = unique_channels(j);
        max_of_unique_channels(j) = max(sorted_channels_as_col{sorted_channels_as_col{:,"Channels"}==current_unique_channel,"SNR"});

    end

    [sorted_means_of_unique_channels,sort_order] = sort(max_of_unique_channels,"descend");
    sorted_unique_channels = unique_channels(sort_order).';

    table_with_best_channels{i,"Sorted Channels"} = {sorted_unique_channels};
    table_with_best_channels{i,"Sorted SNR"} = {sorted_means_of_unique_channels};
    disp("determine_best_dimensions_of_data: "+string(i)+"/"+string(size(table_of_best_representation,1)));
end

table_with_sorted_channels = join(table_of_best_representation,table_with_best_channels);

end