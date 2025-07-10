function [all_window_beginning,all_window_end] = get_window_based_on_multiple_neural_networks(blind_pass_table,neural_networks_array,presorted_table,cluster_size_col,mean_waveform_array,grades_array,config)
    function [beginning_of_window,end_of_window] = run_all_neural_networks(neural_networks_array,presorted_table,i,blind_pass_table,cluster_size_col,mean_waveform_array,grades_array,config)
        max_iterations = 100;

        %each end of the window has 2 scenarios that must be accounted for
        %starting from 1 the best case scenario is that our example (i) has an accuracy score of 99%
        %in this case we have a neural network which predicts with 100% accuracy that i is better than the bottom of the window (bow)
        %the worst case scenario is that i has an accuracy of 2%
        %in this case we can only predict that the bow example is better 55.9% of the time (obviously only slightly better than a coin flip)
        %so how do we resolve this?
        current_example_grades = grades_array(i,:);
        current_example_size = cluster_size_col(i);
        current_example_mean_waveform = mean_waveform_array(i,:);

        %compute ahead of time the overlap between the current cluster and all example cluster to avoid repeat computations
        overlap_between_current_cluster_and_all_others = nan(size(presorted_table,1),1);
        for overlap_counter=1:size(presorted_table,1)
            c1 = blind_pass_table{:,"Z Score"} == presorted_table{overlap_counter,"Z Score"};
            c2 = blind_pass_table{:,"Tetrode"} == presorted_table{overlap_counter,"Tetrode"};
            c3 = blind_pass_table{:,"Cluster"} == presorted_table{overlap_counter,"Cluster"};

            [timestamp_index,~] = find(c1 & c2 & c3);

            overlap_between_current_cluster_and_all_others(overlap_counter) =get_overlap_percentage_between_2_cluster_ts(blind_pass_table{i,"timestamps"}{1},blind_pass_table{timestamp_index,"timestamps"}{1},config);
        end

        for nn_counter=1:size(neural_networks_array,2)
            current_nn = neural_networks_array{nn_counter};
            %start by setting the broadest window possible
            beginning_of_window = 1;
            end_of_window = size(presorted_table,1);
            %this widow dictates that your accuracy can range between 1-100
            %this information is essentially useless, but we can hopefully narrow it down from here
            prediction_probabilities = [1 1000];
            num_iterations = 1;
            while beginning_of_window <size(presorted_table,1) && abs(prediction_probabilities(2) - prediction_probabilities(1))>0.05 && num_iterations <=max_iterations
                c1_for_tow = blind_pass_table{:,"Z Score"} == presorted_table{beginning_of_window,"Z Score"};
                c2_for_tow = blind_pass_table{:,"Tetrode"} == presorted_table{beginning_of_window,"Tetrode"};
                c3_for_tow = blind_pass_table{:,"Cluster"} == presorted_table{beginning_of_window,"Cluster"};
                [top_of_window_index,~] = find(c1_for_tow & c2_for_tow & c3_for_tow);
                beginning_of_window_grades = grades_array(top_of_window_index,:);
                beginning_of_window_size = cluster_size_col(top_of_window_index,1);
                beginning_of_window_mean_waveform = mean_waveform_array(top_of_window_index,:);

                %get the overlap between the the beginning of the window and current example
                overlap = overlap_between_current_cluster_and_all_others(beginning_of_window);

                %now the beginning of window should be akin to the min amount of accuracy we expect example i to be
                %therefore we should put example i's data in the left position as we expect it's accuracy to be higher than this

                data_for_nn = [current_example_mean_waveform,current_example_grades,beginning_of_window_mean_waveform,beginning_of_window_grades,overlap,current_example_size,beginning_of_window_size];

                prediction_probabilities = predict(current_nn,data_for_nn);

                [~,is_left_better] = max(prediction_probabilities);
                is_left_better = is_left_better-1;
                if is_left_better
                    beginning_of_window = beginning_of_window+1;
                end
                num_iterations = num_iterations+1;
                % print_status_iter_message("get_window_based_on_multiple_neural_networks.m:first window loop:",[nn_counter,num_iterations],max_iterations);
            end

            num_iterations = 1;
            prediction_probabilities = [1 1000];
            while end_of_window > 1 && abs(prediction_probabilities(2) - prediction_probabilities(1))>0.05 && end_of_window > beginning_of_window && num_iterations < max_iterations
                c1_for_bow = blind_pass_table{:,"Z Score"} == presorted_table{end_of_window,"Z Score"};
                c2_for_bow = blind_pass_table{:,"Tetrode"} == presorted_table{end_of_window,"Tetrode"};
                c3_for_bow = blind_pass_table{:,"Cluster"} == presorted_table{end_of_window,"Cluster"};
                [bottom_of_window_index,~] = find(c1_for_bow & c2_for_bow &c3_for_bow);
                end_of_window_grades = grades_array(bottom_of_window_index,:);
                end_of_window_size = cluster_size_col(bottom_of_window_index,1);
                end_of_window_mean_waveform = mean_waveform_array(bottom_of_window_index,:);

                %get the overlap between the the beginning of the window and current example
                overlap = overlap_between_current_cluster_and_all_others(end_of_window);
                
                %because this is the end of the window we must organize the neural network data in such a way that we're trying to predict if the current example is worse
                %therefore the end of the window information must be placed in the left category
                data_for_nn = [end_of_window_mean_waveform,end_of_window_grades,current_example_mean_waveform,current_example_grades,overlap,end_of_window_size,current_example_size];

                prediction_probabilities = predict(current_nn,data_for_nn);
                [~,is_left_better] = max(prediction_probabilities);
                is_left_better = is_left_better-1;
                if is_left_better
                    end_of_window = end_of_window-1;
                end
                % print_status_iter_message("get_window_based_on_multiple_neural_networks.m:second window loop:",[nn_counter,num_iterations],max_iterations);
                num_iterations = num_iterations+1;
            end

            if beginning_of_window>5
                beginning_of_window = beginning_of_window-5;
            end
            if end_of_window<95
                end_of_window = end_of_window +5;
            end

        end

    end
all_window_beginning = nan(size(blind_pass_table,1),1);
all_window_end = nan(size(blind_pass_table,1),1);
for i=1:size(blind_pass_table,1)
    %for every sample in the blind_pass_table we must try to minimize the window where its true accuracy might exist
    beginning_time = tic;
    [all_window_beginning(i),all_window_end(i)]= run_all_neural_networks(neural_networks_array,presorted_table,i,blind_pass_table,cluster_size_col,mean_waveform_array,grades_array,config);
    end_time = toc(beginning_time);
    
    print_status_iter_message("get_window_based_on_multiple_neural_networks.m",i,size(blind_pass_table,1));
    % disp([all_window_beginning(i),all_window_end(i)]);
    disp("It Took "+string(end_time)+" Seconds");
end

end