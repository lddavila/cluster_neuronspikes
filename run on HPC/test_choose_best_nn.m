function [] = test_choose_best_nn(config,table_with_clusters)
nn_struct = importdata(config.FP_TO_CHOOSE_BETTER_NN);
choose_better_net = nn_struct.net;
%100 data samples per try that we want to do
bounds_to_try = [0 1; 5 10; 10 20; 20 30; 30 40; 40 50; 50 80];
number_of_tests_per_bound =100;

every_possible_permutation = nchoosek(1:size(table_with_clusters,1),2);
every_accuracy_difference = abs(table_with_clusters{every_possible_permutation(:,1),"accuracy"} - table_with_clusters{every_possible_permutation(:,2),"accuracy"});
rng(0);
for i=1:size(bounds_to_try,1)
    possible_tests_within_current_accuracy_bounds = every_possible_permutation(every_accuracy_difference < bounds_to_try(i,2) & every_accuracy_difference > bounds_to_try(i,1),:);
    random_sample_idxs= randi(size(possible_tests_within_current_accuracy_bounds,1),number_of_tests_per_bound,1);
    random_samples = possible_tests_within_current_accuracy_bounds(random_sample_idxs,:);

    true_positives = 0;
    true_negatives = 0;
    false_positive = 0;
    false_negative = 0;
    for j=1:size(random_sample_idxs,1)
        wave_1_accuracy =table_with_clusters{random_samples(j,1),"accuracy"} ;
        wave_2_accuracy = table_with_clusters{random_samples(j,2),"accuracy"};
        waveform_1 = table_with_clusters{random_samples(j,1),"Mean Waveform"}{1};
        waveform_2 = table_with_clusters{random_samples(j,1),"Mean Waveform"}{1};
        probabilities_that_wave_1_is_better = predict(choose_better_net,[waveform_1,waveform_2]);
        [~,max_ind] = max(probabilities_that_wave_1_is_better);
        wave_1_better = max_ind-1;
        if wave_1_better && wave_1_accuracy>wave_2_accuracy
            true_positives = true_positives+1;
        elseif wave_1_better && wave_1_accuracy < wave_2_accuracy
            false_positive = false_positive+1;
        elseif ~wave_1_better && wave_1_accuracy < wave_2_accuracy
            true_negatives = true_negatives+1;
        elseif ~wave_1_better && wave_1_accuracy > wave_2_accuracy
            false_negatives = false_negative+1;
        end

    end
    figure;
    bar(["true positives","true negatives","False Positives","false negative"],[true_positives,true_negatives,false_positive,false_negatives])
    title("Cases Within "+strjoin(string(bounds_to_try(i,:)))+" accuracy")
end


end