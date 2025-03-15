function [array_of_euc_dist_to_non_overlapping_clusters,array_of_euc_dist_to_overlapping_clusters] = get_euc_dist_between_temp_spike_wavesforms(create_plots,table_of_overlap,overlap_threshold)
array_of_euc_dist_to_non_overlapping_clusters = nan(500000,1);
array_of_euc_dist_to_overlapping_clusters = nan(500000,1);
matrix_of_euc_dist = zeros(size(table_of_overlap,1),size(table_of_overlap,1));
overlapping_cluster_counter=1;
non_overlapping_cluster_counter = 1;
for i=1:size(table_of_overlap,1)
    tic
    %profile on;
    %D = gpuDevice;

    current_overlap_data_dict = table_of_overlap{i,"Other Appearence Info"}{1};

    other_appearences_clusters_array = current_overlap_data_dict("cluster number of other appearences");
    other_appearences_tetrode_array= current_overlap_data_dict("tetrodes of other appearences");
    other_appearences_overlap_percentage_array= current_overlap_data_dict("overlap percentages of other appearences");
    other_appearences_z_score_array= current_overlap_data_dict("Z score of other appearences");
    % other_appearences_classification_array= current_overlap_data_dict("classification of other appearences");

    other_appearences_clusters_array(other_appearences_clusters_array=="") = [];
    other_appearences_tetrode_array(other_appearences_tetrode_array=="") = [];
    other_appearences_overlap_percentage_array(other_appearences_overlap_percentage_array=="") = [];
    other_appearences_z_score_array(other_appearences_z_score_array=="") = [];
    %other_appearences_classification_array(other_appearences_classification_array=="") = [];


    current_cluster_template_waveform = table_of_overlap{i,"Mean Waveform"}{1};
    % current_cluster_template_waveform_gpu = gpuArray(current_cluster_template_waveform);

    for j=1:length(other_appearences_overlap_percentage_array)
        if  other_appearences_overlap_percentage_array(j)==""
            continue;
        end
        current_overlap_percentage = str2double(strrep(other_appearences_overlap_percentage_array(j),"%",""));
        if current_overlap_percentage > overlap_threshold
            c1 = table_of_overlap{:,"Cluster"} == str2double(other_appearences_clusters_array(j));
            c2 = table_of_overlap{:,"Z Score"} == str2double(other_appearences_z_score_array(j));
            c3 = table_of_overlap{:,"Tetrode"} == other_appearences_tetrode_array(j);
            index_of_overlap = find(c1 & c2 & c3);
            % display(table_of_overlap{index_of_overlap,"Mean Waveform"})
            if isempty(table_of_overlap{index_of_overlap,"Mean Waveform"})
                continue
            end
            overlapping_cluster_template_waveform = table_of_overlap{index_of_overlap,"Mean Waveform"}{1};
            % overlapping_cluster_template_waveform_gpu = gpuArray(overlapping_cluster_template_waveform);
            
            if size(current_cluster_template_waveform,2) ~= size(overlapping_cluster_template_waveform,2) 
                continue;
            end
            %euc_dist_between_waveforms_gpu = norm(current_cluster_template_waveform_gpu - overlapping_cluster_template_waveform_gpu);
            euc_dist_between_waveforms = norm(current_cluster_template_waveform - overlapping_cluster_template_waveform);
            matrix_of_euc_dist(i,index_of_overlap) = 1;
            array_of_euc_dist_to_overlapping_clusters(overlapping_cluster_counter) =euc_dist_between_waveforms;
            overlapping_cluster_counter = overlapping_cluster_counter+1;
        end
    end

    for j=1:size(table_of_overlap,1)
        if matrix_of_euc_dist(i,j)==1 || i==j || matrix_of_euc_dist(j,i)==1
            continue
        end
        if isempty(table_of_overlap{j,"Mean Waveform"})
                continue
        end
        non_overlapping_cluster_waveform = table_of_overlap{j,"Mean Waveform"}{1};
        %non_overlapping_cluster_waveform_gpu = gpuArray(non_overlapping_cluster_waveform);
        if size(non_overlapping_cluster_waveform,2) ~= size(current_cluster_template_waveform,2)
            continue;
        end
        %euc_dist_between_non_overlapping_clusters_gpu = norm(current_cluster_template_waveform_gpu - non_overlapping_cluster_waveform_gpu);
        euc_dist_between_non_overlapping_clusters = norm(current_cluster_template_waveform - non_overlapping_cluster_waveform);
        array_of_euc_dist_to_non_overlapping_clusters(non_overlapping_cluster_counter)= euc_dist_between_non_overlapping_clusters;
        non_overlapping_cluster_counter = non_overlapping_cluster_counter+1;
        matrix_of_euc_dist(i,j) =1;
    end

    fprintf("Finished %i/%0f\n",i,size(table_of_overlap,1))
    % reset(D);
    toc
    %profile off;
    %profile viewer;
end
array_of_euc_dist_to_non_overlapping_clusters(isnan(array_of_euc_dist_to_non_overlapping_clusters)) = [];
array_of_euc_dist_to_overlapping_clusters(isnan(array_of_euc_dist_to_overlapping_clusters)) = [];
if create_plots
    figure;
    h = histogram(array_of_euc_dist_to_non_overlapping_clusters,'Normalization','probability');
    histogram(array_of_euc_dist_to_overlapping_clusters,'BinEdges',h.Edges,'Normalization','probability')
end
end