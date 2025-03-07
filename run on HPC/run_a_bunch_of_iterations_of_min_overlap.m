%% Step 0: Run the experimental overlap table
table_of_all_overlap = check_timestamp_overlap_between_clusters_hpc_ver_3(graded_contamination_table,timestamp_array,1,0.004);


%% Step 1
[graded_contamination_table,neurons_of_graded_cont_table,group_counts]=grade_the_results_of_cont_table(final_contamination_table,1:100);
array_of_overlap_percentages = [5 10 15 20 25 30 35 40 45 50];
cell_array_of_overlapping_clusters_tables = cell(length(array_of_overlap_percentages),2);
for i=1:length(array_of_overlap_percentages)
    cell_array_of_overlapping_clusters_tables{i,1} = array_of_overlap_percentages(i);
    cell_array_of_overlapping_clusters_tables{i,2} = check_timestamp_overlap_between_clusters_hpc_ver_2(neurons_of_graded_cont_table,timestamp_array,array_of_overlap_percentages(i),0.004);
end
save("cell_array_of_overlapping_clusters_tables.mat","cell_array_of_overlapping_clusters_tables");

%% Step 2
%load("cell_array_of_overlapping_clusters_tables.mat","cell_array_of_overlapping_clusters_tables")
%first column will be the overlap percentage that was submitted to
%check_timsestamp_overlap_between_clusters_hpc_ver_2
%second col is the overlap percentage submitted to the
%return_best_conf_for_clust
%third col is the result of return_best_conf_for_cluster
cell_array_of_best_config= cell(64,3);
for i=1:8
    for j=1:8
        cell_array_of_best_config{((i-1)*8)+(j),1} = array_of_overlap_percentages(i);
        cell_array_of_best_config{((i-1)*8)+(j),2} = array_of_overlap_percentages(j);
        cell_array_of_best_config{((i-1)*8)+(j),3} =return_best_conf_for_cluster(cell_array_of_overlapping_clusters_tables{i,2},neurons_of_graded_cont_table,grades_array,false,timestamp_array,array_of_overlap_percentages(j)) ;
    end
end
save("cell_array_of_best_config_result.mat","cell_array_of_best_config")
%% STEP 3 now combine this info with the array of helpful info
results_of_meta_data_analysis = cell(64,3);
for j=1:size(cell_array_of_best_config,1)
    
    results_of_meta_data_analysis{j,1} = cell_array_of_best_config{j,1};
    results_of_meta_data_analysis{j,2} = cell_array_of_best_config{j,2};
    current_table_of_best_config = cell_array_of_best_config{j,3};
    if mod(j,8) ~= 0
        current_overlapping_cluster_table = cell_array_of_overlapping_clusters_tables{mod(j,8),2};
    else
        current_overlapping_cluster_table = cell_array_of_overlapping_clusters_tables{8,2};
    end
    %go to the contamination table and get the max overlap and the unit it
    %has max overlap with and the classification and the grades
    rows_to_add_from_graded_cont_table = table(nan(size(current_table_of_best_config,1),1),nan(size(current_table_of_best_config,1),1),cell(size(current_table_of_best_config,1),1),repelem("",size(current_table_of_best_config,1),1),'VariableNames',["Max Overlap % With Unit","Max Overlap Unit","grades","Classification"]);
    rows_to_add_from_overlapping_clusters_tables = table(cell(size(current_table_of_best_config,1),1),cell(size(current_table_of_best_config,1),1),cell(size(current_table_of_best_config,1),1),'VariableNames',["Overlap %","Other Appearences","Tetrode"]);
    for k=1:size(current_table_of_best_config,1)
        tetrode = current_table_of_best_config{k,"Tetrode"};
        z_score = current_table_of_best_config{k,"Z Score"};
        cluster = current_table_of_best_config{k,"Cluster"};
        rows_to_add_from_graded_cont_table(k,:) = neurons_of_graded_cont_table(neurons_of_graded_cont_table{:,"Tetrode"} ==tetrode &neurons_of_graded_cont_table{:,"Z Score"}==z_score & neurons_of_graded_cont_table{:,"Cluster"}==cluster ,["Max Overlap % With Unit","Max Overlap Unit","grades","Classification"]);
        rows_to_add_from_overlapping_clusters_tables(k,:) = current_overlapping_cluster_table(neurons_of_graded_cont_table{:,"Tetrode"} ==tetrode & neurons_of_graded_cont_table{:,"Z Score"}==z_score & neurons_of_graded_cont_table{:,"Cluster"}==cluster ,["Overlap %","Other Appearences","Tetrode"]);
    end

    %now do the same by going to the array_of_overlapping cluster tables
    %this can be used to help debug
    rows_to_add_from_overlapping_clusters_tables = renamevars(rows_to_add_from_overlapping_clusters_tables,"Tetrode","Other Appearences Tetrode");
    final_table_of_meta_data_analysis = [current_table_of_best_config,rows_to_add_from_graded_cont_table,rows_to_add_from_overlapping_clusters_tables];
    results_of_meta_data_analysis{j,3} = final_table_of_meta_data_analysis;
    disp("Finished "+string(j)+"/"+string(size(cell_array_of_best_config,1)))
end

%% STPE 4 now print the TP FP groupcounts of the meta data analysis
clc;
unit_list = 1:100;
min_overlap_percentage_with_unit = 30;
array_of_tp_fp_results = {};
% what information do I want to know to debug?
    %the first meta data parameter
    %the second meta data parameter
    %# units identified
    %# cases correctly identified
        %where correctly_identified means that they meet the
        %min_overlap_percentage_with_unit threshold
    %cases where correctly identified but repeated
    %# of cases incorectly identified 
        %defined as being tied to some unit n, but not meeting the
        %min_overlap_percentage_with_unit requirement
    %the branch of the tree which caused this classification
    %how many correctly identified, but repeated
    %# of units not represented
    %the explanation as to why the units were lost
clc;

debug_table = cell2table(cell(0,11),'VariableNames',["first_overlap_percentage","second_overlap_percentage","total_clusters_idd_as_neurons","tp_aka_real_number_of_neurons","tp_cases","fp_aka_number_of_neurons_misid","fp_cases","number_of_repitions","repetition_cases","fn_aka_number_of_neurons_missed","units_missed"]);
for i=1:size(results_of_meta_data_analysis,1)
    first_meta_parameter = results_of_meta_data_analysis{i,1};
    second_meta_parameter = results_of_meta_data_analysis{i,2};
    current_final_table_of_meta_analysis = results_of_meta_data_analysis{i,3};

    table_of_correctly_identified = current_final_table_of_meta_analysis(current_final_table_of_meta_analysis{:,"Max Overlap % With Unit"} >= min_overlap_percentage_with_unit,:);
    gc_of_correctly_idd_neurons = groupcounts(table_of_correctly_identified,"Max Overlap Unit");
    number_of_units_correctly_idd_but_repeated = sum(gc_of_correctly_idd_neurons{:,"GroupCount"}>1);
    list_of_correctly_idd_but_repeated_units = gc_of_correctly_idd_neurons{gc_of_correctly_idd_neurons{:,"GroupCount"}>1,["Max Overlap Unit"]};
    number_of_units_correctly_idd_without_reps = size(table_of_correctly_identified,1) - number_of_units_correctly_idd_but_repeated;

    rows_of_correct_with_repetition = table_of_correctly_identified(ismember(table_of_correctly_identified{:,"Max Overlap Unit"},list_of_correctly_idd_but_repeated_units),:);

    
    list_of_units_identified_in_current_configuration = unique(table_of_correctly_identified{:,"Max Overlap Unit"});
    

    
    rows_of_cc_where_unit_was_misidentified = current_final_table_of_meta_analysis(current_final_table_of_meta_analysis{:,"Max Overlap % With Unit"} < min_overlap_percentage_with_unit,:);
    units_incorrectly_identified_in_current_configuration = size(rows_of_cc_where_unit_was_misidentified,1);
    units_not_represented = setdiff(unit_list,list_of_units_identified_in_current_configuration);
    units_represented_multiple_times = groupcounts_by_units_represented_in_current_meta_data(groupcounts_by_units_represented_in_current_meta_data{:,"GroupCount"}>1,["Max Overlap Unit"]);


    if first_meta_parameter==30 && second_meta_parameter ==40
        disp("First overlap %:"+string(first_meta_parameter)+" Second Overlap %:"+string(second_meta_parameter))
        disp("# of units total:"+string(size(current_final_table_of_meta_analysis,1)));
        disp("# of units correctly id'd (without repetitions):"+string(number_of_units_correctly_idd_without_reps))
        disp("# of repeitions:"+string(number_of_units_correctly_idd_but_repeated))
        disp("# of units incorrectly id'd:"+string(units_incorrectly_identified_in_current_configuration))
        disp("# of units not id'd:"+string(length(units_not_represented)))
        % disp("# of units represented multiple times:"+string(size(units_represented_multiple_times,1)))
        % disp(groupcounts_by_units_represented_in_current_meta_data(groupcounts_by_units_represented_in_current_meta_data{:,"GroupCount"}>1,["Max Overlap Unit","GroupCount"]));
        % disp(sortrows(current_final_table_of_meta_analysis,"Max Overlap Unit"))
        disp("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    end
    
    row_to_add_to_debug_table = table(first_meta_parameter,second_meta_parameter, size(current_final_table_of_meta_analysis,1),number_of_units_correctly_idd_without_reps,{table_of_correctly_identified},units_incorrectly_identified_in_current_configuration,{rows_of_cc_where_unit_was_misidentified},number_of_units_correctly_idd_but_repeated, {rows_of_correct_with_repetition},length(units_not_represented),{units_not_represented},...
        'VariableNames', ["first_overlap_percentage","second_overlap_percentage","total_clusters_idd_as_neurons","tp_aka_real_number_of_neurons","tp_cases","fp_aka_number_of_neurons_misid","fp_cases","number_of_repitions","repetition_cases","fn_aka_number_of_neurons_missed","units_missed"]);
    debug_table = [debug_table;row_to_add_to_debug_table];
    %seems as though 80 is the max #units my tree finds the first time 80
    %are found is first overlap %15 and second overlap percentage 40
end
[the_max,index_of_max] = max(debug_table{:,"tp_aka_real_number_of_neurons"});
most_tp = debug_table(index_of_max,:);

%% STEP 5 diagnose which ones were missing 
min_overlap_percentage_with_unit = 30;
missing_units = most_tp.units_missed{1};
disp(missing_units)
first_overlap_percentages = most_tp.first_overlap_percentage;
clc;
index_of_best = find(array_of_overlap_percentages==first_overlap_percentages);
current_overlap_table = cell_array_of_overlapping_clusters_tables{index_of_best,2};
current_overlap_table = renamevars(current_overlap_table,"Tetrode","tetrodes_of_other_appearences");
og_tetrodes = neurons_of_graded_cont_table(:,"Tetrode");

table_to_use_for_debugging = [og_tetrodes,current_overlap_table];
disp(table_to_use_for_debugging)
clc
%find where those missing units were represented in the original neurons
%identified
appearences_of_missing_in_original = cell(1,size(missing_units,1));
for i=1:size(missing_units,2)
    c1 = neurons_of_graded_cont_table{:,"Max Overlap Unit"} ==missing_units(i);
    c2 = neurons_of_graded_cont_table{:,"Max Overlap % With Unit"} >= min_overlap_percentage_with_unit;
    appearences_of_missing_in_original{i} = neurons_of_graded_cont_table(c1 & c2,:);
end
disp(appearences_of_missing_in_original{1})
clc;
%now find which of the "best" cases absorbed any/all of those other
%appearences
tp_which_absorbed_missing_units = most_tp.tp_cases{1};
fp_which_absorbed_missing_units = most_tp.fp_cases{1};
list_of_cases_that_absorbed_missing_units = cell(size(missing_units,2),4);
for i=1:size(appearences_of_missing_in_original,2)
    current_appearences_of_missing = appearences_of_missing_in_original{i};
    list_of_tetrodes_of_og_appearence = current_appearences_of_missing.Tetrode;
    list_of_clusters_of_og_appearence = current_appearences_of_missing.Cluster;
    list_of_z_scores_of_og_appearence = current_appearences_of_missing.("Z Score");
    cases_that_absorbed_current_unit = [];
    cases_that_were_absorbed = [];

    list_of_cases_that_absorbed_missing_units{i,1} = missing_units(i);
    list_of_cases_that_absorbed_missing_units{i,2} = current_appearences_of_missing;


    %["Z_Score:3 Cluster 5"    "Z_Score:3 Cluster 6"    "Z_Score:3 Cluster 5"    "Z_Score:3 Cluster 1"
    formatted_z_score_and_cluster_list = strcat("Z_Score:",string(list_of_z_scores_of_og_appearence)," Cluster ",string(list_of_clusters_of_og_appearence));
    table_of_best = [tp_which_absorbed_missing_units;fp_which_absorbed_missing_units];
    for j=1:size(table_of_best,1)
       
        c1 = ismember(table_of_best{j,"Other Appearences Tetrode"}{1},list_of_tetrodes_of_og_appearence);
        c2 = ismember(table_of_best{j,"Other Appearences"}{1},formatted_z_score_and_cluster_list);
        indexes = find(c1 & c2);

        c3 = ismember(list_of_tetrodes_of_og_appearence,table_of_best{j,"Other Appearences Tetrode"}{1});
        c4 = ismember(formatted_z_score_and_cluster_list,table_of_best{j,"Other Appearences"}{1});
        indexes_in_opposite_direction = find(c3 & c4);

        appearences_that_were_absorbed_by_this_case = strcat("Tetrode:",list_of_tetrodes_of_og_appearence(indexes_in_opposite_direction)," Z_Score:",string(list_of_z_scores_of_og_appearence(indexes_in_opposite_direction))," Cluster ",string(list_of_clusters_of_og_appearence(indexes_in_opposite_direction)));

        if ~isempty(indexes)
            cases_that_absorbed_current_unit = [cases_that_absorbed_current_unit;table_of_best(j,:)];
            cases_that_were_absorbed = [cases_that_were_absorbed;appearences_that_were_absorbed_by_this_case];
        end
    end
    list_of_cases_that_absorbed_missing_units{i,3} = cases_that_absorbed_current_unit; 
    list_of_cases_that_absorbed_missing_units{i,4} = unique(cases_that_were_absorbed);
end
disp(list_of_cases_that_absorbed_missing_units)
%% now fix the fp cases
false_positive_cases = most_tp{1,"fp_cases"}{1};
branches_of_fp = false_positive_cases{:,"Classification"};
true_positive_cases = most_tp{1,"tp_cases"}{1};
branches_of_tp = true_positive_cases{:,"Classification"};
cases_that_affect_fp_and_not_tp = setdiff(branches_of_fp,branches_of_tp);
disp(cases_that_affect_fp_and_not_tp)