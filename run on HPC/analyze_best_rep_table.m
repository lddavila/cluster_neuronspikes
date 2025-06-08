function [] = analyze_best_rep_table(table_of_best_rep,unmerged_table_of_clusters,min_accuracy)
%numbers to keep track of 
    %how many clusters are left (this will be my sample size
    %for each absorbed case we can ask ourselves 
        %did it return the true highest accuracy result?
        %whether it did or didn't we want to return the magnitude of the chance
    %i will say that if it has no absorbed cases then we can't say that it returned the highest
    %but we won't count it towards the total either

group_counts_by_unit = groupcounts(table_of_best_rep,"Max Overlap Unit");


number_of_cases_that_absorbed = 0;
successfully_chose_best= 0;
failed_to_choose_best = 0;
magnitude_of_differences = nan(size(table_of_best_rep,1),1);
number_of_true_positives = 0;
number_of_false_positives = 0;
for i=1:size(table_of_best_rep,1)

    current_absorbed_cases = table_of_best_rep{i,"absorbed_cases"}{1};
    best_case_accuracy = table_of_best_rep{i,"accuracy"};
    if best_case_accuracy > min_accuracy
        number_of_true_positives = number_of_true_positives+1;
    else
        number_of_false_positives = number_of_false_positives+1;
    end
    if isempty(current_absorbed_cases)
        continue;
    end
    number_of_cases_that_absorbed = number_of_cases_that_absorbed+1;

    accuracies_of_the_absorbed_cases = unmerged_table_of_clusters{current_absorbed_cases{:,"idx of its location in arrays"},"accuracy"};
    if best_case_accuracy==max(accuracies_of_the_absorbed_cases)
        successfully_chose_best = successfully_chose_best+1;
    else
        failed_to_choose_best = failed_to_choose_best+1;
        magnitude_of_differences(i) = abs(best_case_accuracy- max(accuracies_of_the_absorbed_cases));
    end
end
disp("Number of clusters remaining after choosing best:" +string(size(table_of_best_rep,1)));
disp("Number of clusters that absorbed no other cases:"+string(size(table_of_best_rep,1) - number_of_cases_that_absorbed))
disp("Number Of Cases that could be chosen best:"+string(number_of_cases_that_absorbed))
disp("Number of cases where it succcessfully chose best:"+string(successfully_chose_best))
disp("number of cases where it failed to choose best:"+string(failed_to_choose_best))
magnitude_of_differences(isnan(magnitude_of_differences)) = [];
histogram(magnitude_of_differences);
disp(group_counts_by_unit);
missing_units = setdiff(1:100,group_counts_by_unit{:,"Max Overlap Unit"});
disp("List Of Missing Units")
disp(missing_units);

fprintf("Number of true positives:%d/%d \n",number_of_true_positives,size(table_of_best_rep,1));

fprintf("Number of false Positives:%d/%d \n",number_of_false_positives,size(table_of_best_rep,1));
end