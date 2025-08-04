function [blind_pass_table] = get_template_spike_for_each_rep_wire(blind_pass_table)
% unique_aligned_fps = unique(blind_pass_table{:,"fp_to_aligned"});
% number_of_iterations =size(unique_aligned_fps,1);

sliced_blind_pass_table = slice_table_for_parallel_processing(blind_pass_table,["Z Score","Tetrode"]);
number_of_iterations = size(sliced_blind_pass_table,1);
for i=1:size(sliced_blind_pass_table,1)
    current_data = sliced_blind_pass_table{i};
    num_of_channels = size(current_data{:,"grades"}{1}{49},2);
    try
        aligned = importdata(current_data{1,"dir_to_aligned"});
    catch
        disp("Failed to load aligned file")
        disp(current_data{1,"fp_to_aligned"})
        continue;
    end

    try
        output = importdata(current_data{1,"dir_to_output"});
    catch
        disp("Failed to load output file")
        disp(current_data{1,"fp_to_output"})
        continue;
    end



    idx_b4_filt = extract_clusters_from_output(output(:,1),output);


    mean_waveform_cell_array = cell(size(current_data,1),num_of_channels);

    all_peaks = get_peaks(aligned, true);
    for j=1:length(idx_b4_filt)
        cluster_filter = idx_b4_filt{j};
        spikes = aligned(:, cluster_filter, :);
        peaks = all_peaks(:, cluster_filter);
        for k=1:num_of_channels
            [~, max_wire] = max(peaks, [], 1);
            poss_wires = unique(max_wire);
            n = histc(max_wire, poss_wires);
            [~, max_n] = max(n);
            compare_wire = poss_wires(max_n);
            peaks(compare_wire,:) = nan;
            % disp(compare_wire)
            
            mean_waveform = mean(shiftdim(spikes(compare_wire, :, :), 1));
            mean_waveform = mean_waveform - mean(mean_waveform);
            mean_waveform_cell_array{j,k} = mean_waveform;
        end
        % disp("##########################")
    end
    for k=1:num_of_channels
        
        current_data.("mean_waveform_rep_wire_"+string(k)) = mean_waveform_cell_array(:,k);
    end
    disp("Finished "+string(i)+"/"+string(number_of_iterations))
    sliced_blind_pass_table{i} = current_data;

end
blind_pass_table = vertcat(sliced_blind_pass_table{:});
end