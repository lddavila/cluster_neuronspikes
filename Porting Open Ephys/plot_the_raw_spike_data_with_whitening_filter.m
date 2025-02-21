function [] = plot_the_raw_spike_data_with_whitening_filter(art_tetr_array,dir_with_spikes_dicts,dir_to_save_plots_to,config,mean_of_channels,stds_of_channels,number_of_stds_above_mean,display_whitened_data)
for tetrode_to_use=1:size(art_tetr_array,1)
    % try
        spikes_dict = importdata(dir_with_spikes_dicts+"t"+string(tetrode_to_use)+" spike_tetrode_dictonary.mat");
        timestamps = importdata(dir_with_spikes_dicts+"t"+string(tetrode_to_use)+" timing_tetrode_dictionary.mat");
        timestamps = timestamps("t"+string(tetrode_to_use));
        timestamps = timestamps(:,1);
        timestamps = timestamps * 1000000;
        r_raw = spikes_dict("t"+string(tetrode_to_use));
        r_ir = [];
        for i=1:size(r_raw,1)
            [~,max_of_wire_i] = bounds(squeeze(r_raw(i,:,:)),"all");
            r_ir = [r_ir;max_of_wire_i];
        end
        num_spikes = size(r_raw, 2);
        default_filter = true(num_spikes, 1); % Ignores no spikes

        channel_means = mean_of_channels(art_tetr_array(tetrode_to_use,:));
        channel_stds = stds_of_channels(art_tetr_array(tetrode_to_use,:));

        t_vals = channel_means + (number_of_stds_above_mean*channel_stds);
        aligned = align_to_peak(r_raw,t_vals,r_ir);
        peaks = get_peaks(aligned, true)';


        % close all;
        % plot the 2d histogram of the data
        figure('units','normalized','outerposition',[0 0 1 1]);
        %figure;
        plot_counter =1;
        simple = art_tetr_array(tetrode_to_use,:);
        for first_dimension = 1:length(simple)
            for second_dimension = first_dimension+1:length(simple)
                subplot(2,3,plot_counter);
                dimension_1_data = peaks(:,first_dimension);
                dimension_2_data = peaks(:,second_dimension);


                first_dim_bounds= prctile(dimension_1_data,[40,93]);
                sec_dim_bounds= prctile(dimension_1_data,[40,93]);

                rows_to_eliminate_based_on_first_dimension = dimension_1_data > first_dim_bounds(1) & dimension_1_data <first_dim_bounds(2);

                 
                rows_to_eliminate_based_on_second_dimension = dimension_2_data > sec_dim_bounds(1) & dimension_2_data < sec_dim_bounds(2);

                rows_to_eliminate = rows_to_eliminate_based_on_second_dimension | rows_to_eliminate_based_on_first_dimension;


                in_first_quadrant = dimension_1_data > first_dim_bounds(2) & dimension_2_data > sec_dim_bounds(2);
                in_second_quadrant = dimension_1_data < first_dim_bounds(1) & dimension_2_data > sec_dim_bounds(2);

                in_third_quadrant = dimension_1_data < first_dim_bounds(1) & dimension_2_data < sec_dim_bounds(1);

                

                in_fourth_quadrant = dimension_1_data > first_dim_bounds(2) & dimension_2_data < sec_dim_bounds(1);

                cleaned_first_and_second_row = [dimension_1_data(~rows_to_eliminate),dimension_2_data(~rows_to_eliminate)];


                if display_whitened_data
                    % Compute timestamp and SNR filters
                    if config.USE_TIMESTAMP_FILTER && length(timestamps) > 20000
                        timestamp_filter = compute_timestamp_filter(timestamps);
                    else
                        timestamp_filter = default_filter;
                    end

                    num_iterations = max(config.NUM_ITERATIONS, 1);
                    snr_filters = repmat(default_filter, [1, num_iterations]);

                    if config.USE_SNR_FILTER && num_spikes > 10000
                        good_filters = true(num_iterations, 1);
                        pmv = compute_snr_statistic(aligned, r_raw, t_vals, r_ir);
                        if num_iterations == 2
                            snr_threshs = 0;
                        elseif num_iterations == 3
                            snr_threshs = [1, 0];
                        elseif num_iterations == 4
                            snr_threshs = [1.5, 1, 0];
                        else
                            snr_threshs = linspace(2, 0, num_iterations-1);
                        end
                        for k = 1:length(snr_threshs)
                            snr_filter = pmv > snr_threshs(k);
                            num_filtered_spikes = sum(snr_filter);
                            if num_filtered_spikes < 600
                                good_filters(k) = false;
                            else
                                snr_filters(:, k) = snr_filter;
                            end
                        end
                        snr_filters = snr_filters(:, good_filters);
                        num_iterations = size(snr_filters, 2);
                    end

                    % Compute the whitening filter on the space of peaks
                    preproc_idx = cell(1, num_iterations);
                    for k = 1:num_iterations
                        snr_filter = snr_filters(:, k);
                        combined_filter = snr_filter & timestamp_filter;
                        % Store the indices so that we can use the vector as an injection
                        % function back into the original set of indices
                        combined_idx_inj = find(combined_filter);

                        if config.USE_DENSITY_FILTER && ...
                                (num_iterations == 1 || k < num_iterations)
                            whiten_filter = whiten(peaks(:, :));
                            break;
                        else
                            whiten_filter = true(size(combined_idx_inj));
                        end

                    end


                    filtered_data = [dimension_1_data(whiten_filter & ~rows_to_eliminate),dimension_2_data(whiten_filter & ~rows_to_eliminate)];
                    first_quadrant_data = [dimension_1_data(in_first_quadrant & whiten_filter), dimension_2_data(in_first_quadrant & whiten_filter)];
                    sec_quad_data = [dimension_1_data(in_second_quadrant & whiten_filter), dimension_2_data(in_second_quadrant & whiten_filter)];
                    third_quad_data = [dimension_1_data(in_third_quadrant & whiten_filter), dimension_2_data(in_third_quadrant & whiten_filter)];
                    fourth_quad_data = [dimension_1_data(in_fourth_quadrant & whiten_filter), dimension_2_data(in_fourth_quadrant & whiten_filter)];


                    [~, first_third_and_fourth_quadrant_cluster_pcs] = pca([first_quadrant_data;sec_quad_data;fourth_quad_data]);
                   
                    [~, third_quadrant_cluster_pcs] = pca(third_quad_data);
               
                    
                    % [~, peakpcs] = pca(filtered_data);

                    filtered_data = [dimension_1_data(whiten_filter),dimension_2_data(whiten_filter)];

                    all_pcs = [first_third_and_fourth_quadrant_cluster_pcs;third_quadrant_cluster_pcs];
                    % [~, all_pcs] = pca(filtered_d);
                    scatter(zscore(filtered_data(:,1)),zscore(filtered_data(:,2)));
                    % scatter_kde(filtered_data(:,1),filtered_data(:,2),'filled','MarkerSize',5);
                    % cb = colorbar();
                    % cb.Label.String = 'Probability density estimate';
                else
                    %[~, peakpcs] = pca(cleaned_first_and_second_row);
                    %[~, peakpcs] = pca([zscore(dimension_1_data),zscore(dimension_2_data)]);
                    %scatter(peakpcs(:,1),peakpcs(:,2))
                    scatter(zscore(dimension_1_data),zscore(dimension_2_data));
                    % scatter_kde(cleaned_first_and_second_row(:,1),cleaned_first_and_second_row(:,2),'filled','MarkerSize',5);
                    % cb = colorbar();
                    % cb.Label.String = 'Probability density estimate';
                end
                xlabel("channel " + string(simple(first_dimension)) + " Peaks PCs")
                ylabel("channel "+string(simple(second_dimension)) + " Peaks PCs")

                plot_counter = plot_counter+1;
            end
        end
        % pause(3)
        sgtitle("t"+string(tetrode_to_use))
        saveas(gcf,dir_to_save_plots_to+"\t"+string(tetrode_to_use)+".svg");
        % fprintf("%0.f Number of Peaks %0.1f Sum of Whiten Filter %0.1f\n",tetrode_to_use,size(peaks,1),sum(whiten_filter));
        close all;

    % catch ME
    %     % disp("t"+string(tetrode_to_use)+ " Couldn't be printed")
    %      disp(ME)
    %     close all;
    % end
end
end

% [counts_per_bin,bin_centers] = hist3([dimension_1_data,dimension_2_data],[25,25]);
% x_largest_sum_dimension = 0;
% x_largest_sum_index = NaN;
% y_largest_sum_dimension = 0;
% y_largest_sum_index = NaN;
% for dimension_counter=1:25
%     if sum(counts_per_bin(:,dimension_counter)) > x_largest_sum_dimension
%         x_largest_sum_index = dimension_counter;
%         x_largest_sum_dimension = sum(counts_per_bin(:,dimension_counter));
%     end
%     if sum(counts_per_bin(dimension_counter,:)) > y_largest_sum_dimension
%         y_largest_sum_index = dimension_counter;
%         y_largest_sum_dimension = sum(counts_per_bin(dimension_counter,:));
%     end
% end
% y_dimension_limit = [x_largest_sum_index,x_largest_sum_index+3];
% x_dimension_limit = [y_largest_sum_index,y_largest_sum_index+3];
%
% if y_dimension_limit(2) > 25
%     y_dimension_limit(2) = 25;
% end
% if x_dimension_limit(2) > 25
%     x_dimension_limit(2) =25;
% end
%
% ranges_of_data_to_cut_along_y_axis = bin_centers{2}(y_dimension_limit);
% ranges_of_data_to_cut_along_x_axis = bin_centers{1}(x_dimension_limit);
% dimension_1_and_2_data = [dimension_1_data,dimension_2_data];
%
% rows_to_keep_based_on_x_dimension = dimension_1_and_2_data(:,1) > ranges_of_data_to_cut_along_x_axis(2) | dimension_1_and_2_data(:,1) < ranges_of_data_to_cut_along_x_axis(1);
% rows_to_keep_based_on_y_dimension = dimension_1_and_2_data(:,2) > ranges_of_data_to_cut_along_y_axis(2) | dimension_1_and_2_data(:,2) < ranges_of_data_to_cut_along_y_axis(1);
%
% rows_to_keep = rows_to_keep_based_on_y_dimension & rows_to_keep_based_on_x_dimension;
%
% figure;
% hist3([dimension_1_and_2_data(rows_to_keep,:)],[25,25],"ctrs",bin_centers,'CDataMode','auto','FaceColor','interp')
% title("After")
%
% figure;
% hist3(dimension_1_and_2_data,[25,25],'CDataMode','auto','FaceColor','interp')
% title("Before")
