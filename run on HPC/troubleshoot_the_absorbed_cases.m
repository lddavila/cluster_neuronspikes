function [] = troubleshoot_the_absorbed_cases(table_of_best_appearences,timestamp_array,config,table_of_overlapping_clusters,grades_to_normalize_by)

    function [] = create_bar_plot_for_absorbed_cases(accuracy_for_absorbed_cases,names_for_the_plots,grades_to_plot_from_absorbed_cases_with_same_max_overlap_unit,absorbed_cases,j)

        
        formatted_accuracy = string(split(sprintf('%.2f ',accuracy_for_absorbed_cases.')," "));
        formatted_accuracy = formatted_accuracy(1:end-1);
        names_for_the_x_labels = strcat("Z:",string(absorbed_cases{:,"Z Score"})," ",string(absorbed_cases{:,"Tetrode"})," C"+string(absorbed_cases{:,"Cluster"})," acc:",formatted_accuracy);
        [~,index_of_max_accuracy ]= max(accuracy_for_absorbed_cases);

        names_for_the_x_labels(index_of_max_accuracy) = names_for_the_x_labels(index_of_max_accuracy)+"*Max";
        simplified_names = string(1:size(names_for_the_x_labels,1));
        simplified_names(index_of_max_accuracy) = simplified_names(index_of_max_accuracy)+"*";

        table_of_grades = array2table(grades_to_plot_from_absorbed_cases_with_same_max_overlap_unit,"VariableNames",names_for_the_plots,'RowNames',names_for_the_x_labels);
        sorted_table_of_grades = sortrows(table_of_grades,names_for_the_plots,"descend");


        figure;
        heatmap(string(sorted_table_of_grades.Properties.VariableNames),string(sorted_table_of_grades.Properties.RowNames),sorted_table_of_grades{:,:})
        disp([string(1:size(names_for_the_x_labels,1)).',names_for_the_x_labels])
        sgtitle(string(j))
    end


ground_truth_array = importdata(config.GT_FP);
timestamps = importdata(config.TIMESTAMP_FP);
list_of_units = 1:config.NUM_OF_UNITS;
number_of_false_absorbtion = 0;
for i=1:size(list_of_units,2)
    % unit_of_best_overlap = table_of_best_appearences{i,"Max Overlap Unit"};
    all_appearences_of_current_unit =table_of_best_appearences(table_of_best_appearences{:,"Max Overlap Unit"}==list_of_units(i),:);
    %get all absorbed cases
    gt_idxs = ground_truth_array{list_of_units(i)};
    gt_ts = timestamps(gt_idxs);
    for j=1:size(all_appearences_of_current_unit,1)

        
        clc;
        disp("i: "+string(i)+" j:"+string(j))
        absorbed_cases = all_appearences_of_current_unit{j,"absorbed_cases"}{1};
        if isempty(absorbed_cases)
            continue;
        end
        key_to_og_appearences = absorbed_cases{:,"idx of its location in arrays"};

        all_data_for_absorbed_cases = table_of_overlapping_clusters(ismember(table_of_overlapping_clusters{:,"idx of its location in arrays"},key_to_og_appearences),:);
        disp(all_appearences_of_current_unit(j,["Z Score","Tetrode","Cluster","Max Overlap % With Unit","Max Overlap Unit","SNR"]));
        % disp(all_data_for_absorbed_cases(:,["Z Score","Tetrode","Cluster","Max Overlap % With Unit","Max Overlap Unit"]))

        %define which of the absorbed cases have the same max overlap unit
        absorbed_cases_that_have_the_same_max_overlap_unit = all_data_for_absorbed_cases(all_data_for_absorbed_cases{:,"Max Overlap Unit"}==list_of_units(i),:);

        [names_of_grades_for_max_overlap_unit,grades_of_absorbed_cases_with_same_max_overlap_unit] = flatten_grades_cell_array(absorbed_cases_that_have_the_same_max_overlap_unit{:,"grades"},config);
        [names_of_grades_for_chosen_best,grade_of_chosen_best] = flatten_grades_cell_array(all_appearences_of_current_unit{j,"grades"},config);

        normalized_grades_of_absorbed_cases_with_same_max_overlap_unit = normalize_grades(grades_to_normalize_by,grades_of_absorbed_cases_with_same_max_overlap_unit,config);
        normalized_grades_of_chosen_best = normalize_grades(grades_to_normalize_by,grade_of_chosen_best,config);

        [indexes_of_grades_were_looking_for,~] = find(ismember(names_of_grades_for_chosen_best,config.NAMES_OF_CURR_GRADES(config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST)));

        
        grades_to_plot_from_absorbed_cases_with_same_max_overlap_unit = normalized_grades_of_absorbed_cases_with_same_max_overlap_unit(:,indexes_of_grades_were_looking_for);
        grades_to_plot_of_chosen_best = normalized_grades_of_chosen_best(:,indexes_of_grades_were_looking_for);

        unsorted_names = names_of_grades_for_chosen_best(indexes_of_grades_were_looking_for);
        %now reorder the columns of the grades to appear in the same order as we want them to appear as specified in config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST
        [row,col] = find(unsorted_names==config.NAMES_OF_CURR_GRADES(config.GRADE_IDXS_THAT_ARE_USED_TO_PICK_BEST));

        accuracy_correlation_table_unsorted = table(row,col);
        sorted_accuracy_correlation_table = sortrows(accuracy_correlation_table_unsorted,"col");
        accuracy_correlation_order = sorted_accuracy_correlation_table{:,"row"};

        grades_to_plot_from_absorbed_cases_with_same_max_overlap_unit = grades_to_plot_from_absorbed_cases_with_same_max_overlap_unit(:,accuracy_correlation_order);
        grades_to_plot_of_chosen_best = grades_to_plot_of_chosen_best(:,accuracy_correlation_order);
        sorted_names = unsorted_names(accuracy_correlation_order);


        accuracy_for_chosen_best_cluster = calculate_accuracy(gt_ts,timestamp_array(all_appearences_of_current_unit{j,"idx of its location in arrays"}),config);
        figure;
        first_bp =barh(sorted_names,grades_to_plot_of_chosen_best);
        first_bp(1).Labels = first_bp(1).YData;
        xlim([0,1.5]);
        title(string(j)+" Appearence of Unit "+string(list_of_units(i)) +" acc:"+string(accuracy_for_chosen_best_cluster));

        accuracy_for_absorbed_cases_sharing_max_overlap_unit = calculate_accuracy(gt_ts,timestamp_array(absorbed_cases_that_have_the_same_max_overlap_unit{:,"idx of its location in arrays"}),config);
       

        create_bar_plot_for_absorbed_cases(accuracy_for_absorbed_cases_sharing_max_overlap_unit,sorted_names,grades_to_plot_from_absorbed_cases_with_same_max_overlap_unit,absorbed_cases_that_have_the_same_max_overlap_unit,j)

        absorbed_cases_that_do_not_have_the_same_max_overlap_unit = all_data_for_absorbed_cases(all_data_for_absorbed_cases{:,"Max Overlap Unit"}~=list_of_units(i),:);


        if absorbed_cases_that_do_not_have_the_same_max_overlap_unit{:,"Max Overlap % With Unit"} > config.MIN_UNIT_APPEARENCE_THRESHOLD
            disp("ALERT")
            disp("Best Configuration: " )
            disp(all_appearences_of_current_unit(j,["Z Score","Tetrode","Cluster","Max Overlap % With Unit","Max Overlap Unit","SNR"]))
            disp("Absorbed the following cases which belong to a different unit");
            disp(absorbed_cases_that_do_not_have_the_same_max_overlap_unit(absorbed_cases_that_do_not_have_the_same_max_overlap_unit{:,"Max Overlap % With Unit"} > config.MIN_UNIT_APPEARENCE_THRESHOLD,["Z Score","Tetrode","Cluster","Max Overlap % With Unit","Max Overlap Unit"]))
            number_of_false_absorbtion = number_of_false_absorbtion +1;
        end
    end



close all;
end
clc;
disp("Number of False Absorbtion:"+string(number_of_false_absorbtion))
end