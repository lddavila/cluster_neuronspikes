function [table_of_correlation,accuracy_array,percentage_of_unit_in_cluster,percentage_of_cluster_that_belongs_to_unit,grades_of_all_clusters] = check_correlation_between_grades_and_scoring_metrics(table_of_all_clusters,array_of_grades_to_check_correlation_for,timestamp_array,config)
%step 0 will be to import the ground truth and timestamps
ground_truth_array = importdata(config.GT_FP);
timestamps = importdata(config.TIMESTAMP_FP);

%step 1 will be to extract all of the grades from the table into an easily parsable array
grades_of_all_clusters = [];
accuracy_array = nan(size(table_of_all_clusters,1),1);
percentage_of_unit_in_cluster = nan(size(table_of_all_clusters,1),1);
percentage_of_cluster_that_belongs_to_unit = nan(size(table_of_all_clusters,1),1);
grade_names = [];
for i=1:size(table_of_all_clusters,1)
    current_grades = table_of_all_clusters{i,"grades"}{1};
    flattened_grades = [];
    for j=1:size(array_of_grades_to_check_correlation_for,2)
        singular_grade = current_grades{array_of_grades_to_check_correlation_for(j)};
        if isempty(singular_grade)
            singular_grade = NaN;
            if i==1
                grade_names = [grade_names;string(array_of_grades_to_check_correlation_for(j))+":"+config.NAMES_OF_CURR_GRADES(array_of_grades_to_check_correlation_for(j))];
            end
        end
        if size(singular_grade,2)==1
            flattened_grades = [flattened_grades,singular_grade];
            if i==1
                grade_names = [grade_names;string(array_of_grades_to_check_correlation_for(j))+":"+config.NAMES_OF_CURR_GRADES(array_of_grades_to_check_correlation_for(j))];
            end
        else
            for k=1:size(singular_grade,2)
                flattened_grades = [flattened_grades,singular_grade(k)];
                if i==1
                    grade_names = [grade_names;string(array_of_grades_to_check_correlation_for(j))+"_"+string(k)+":"+config.NAMES_OF_CURR_GRADES(array_of_grades_to_check_correlation_for(j))];
                end
            end
        end

    end
    %current_cluster_timestamps = timestamp_array{i};

    grades_of_all_clusters = [grades_of_all_clusters;flattened_grades];
    ground_truth_idxs = ground_truth_array{table_of_all_clusters{i,"Max Overlap Unit"}};

    gt_ts = timestamps(ground_truth_idxs); %the timestamps of the unit that the current cluster has the most overlap with (in seconds)
    cluster_ts = timestamp_array{i}; %the timestamps of the spikes of the current cluster (in seconds)

    %step 2 will be to calculate the accuracy/ % of the unit's spikes in the cluster/ % of the cluster that belongs to the unit
    percentage_of_unit_in_cluster(i) = table_of_all_clusters{i,"Max Overlap % With Unit"};
    if size(gt_ts,2) < size(cluster_ts,1)
        tp = find_number_of_true_positives_given_a_time_delta_hpc(gt_ts,cluster_ts.',config.TIME_DELTA); % a spike that is in both the cluster and the unit with some time delta specified in seconds
    else
        tp = find_number_of_true_positives_given_a_time_delta_hpc(cluster_ts.',gt_ts,config.TIME_DELTA);
    end
    fn = length(gt_ts) - tp; % a spike in the unit, but not in the cluster
    tn = 0; % this would be a spike in the same configuration ie
    %                                   |z score n|tetrode i| cluster a
    %but not assigned to this cluster
    %we set this equal to 0 because it is not a helpful metric and costly to compute
    fp = length(cluster_ts) - tp; % aspike that is in the cluster, but does not have a correlative spike in the unit

    accuracy_array(i) = ((tp +tn)/(tp+fn+tn+fp))*100;
    if accuracy_array(i) >100
        print("Something is wrong");
    end
    percentage_of_cluster_that_belongs_to_unit(i) = (tp / length(cluster_ts)) * 100;
    disp("Finished "+string(i)+"/"+size(table_of_all_clusters,1))
end

accuracy_r_vals = inf(size(grade_names,1),1);
accuracy_p_vals = inf(size(grade_names,1),1);

unit_spikes_in_clust_r_vals = inf(size(grade_names,1),1);
unit_spikes_in_clust_p_vals = inf(size(grade_names,1),1);

cluster_belong_to_unit_r_vals = inf(size(grade_names,1),1);
cluster_belong_to_unit_p_vals = inf(size(grade_names,1),1);

for i=1:size(grade_names,1)
    current_grade_instances = grades_of_all_clusters(:,i);
    [r,p] = corrcoef(current_grade_instances,accuracy_array);
    if r(1,2) ==r(2,1) && p(1,2)==p(2,1)
        accuracy_r_vals(i) = r(1,2);
        accuracy_p_vals(i) = p(1,2);
    end

    [r,p] = corrcoef(current_grade_instances,percentage_of_unit_in_cluster);
    if r(1,2) ==r(2,1) && p(1,2)==p(2,1)
        unit_spikes_in_clust_r_vals(i)=r(1,2);
        unit_spikes_in_clust_p_vals(i)=p(1,2);
    end

    [r,p] = corrcoef(current_grade_instances,percentage_of_cluster_that_belongs_to_unit);
    if r(1,2) ==r(2,1) && p(1,2)==p(2,1)
        cluster_belong_to_unit_r_vals(i)=r(1,2);
        cluster_belong_to_unit_p_vals(i)=p(1,2);
    end

end

table_of_correlation = table(grade_names,accuracy_r_vals,accuracy_p_vals,unit_spikes_in_clust_r_vals,unit_spikes_in_clust_p_vals,cluster_belong_to_unit_r_vals,cluster_belong_to_unit_p_vals);
table_of_correlation = sortrows(table_of_correlation,["accuracy_r_vals","unit_spikes_in_clust_r_vals","cluster_belong_to_unit_r_vals"]);
%step 3 will be to calculate the correlation of each of those grades with
end