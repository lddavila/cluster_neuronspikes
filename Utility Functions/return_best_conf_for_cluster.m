function [table_of_best_representation] = return_best_conf_for_cluster(table_of_overlapping_clusters,table_of_only_neurons,grades_array,debug,timestamp_array,min_overlap_percentage)
table_of_best_representation = table(repelem("",10000,1),nan(10000,1),nan(10000,1),nan(10000,1),repelem("",10000,1),nan(10000,1),'VariableNames',["Tetrode","Cluster","Z Score","SNR","Overlap Percentage","idx of its location in arrays"]);
already_appeared = [];
for i=1:size(table_of_overlapping_clusters,1)
    current_z_score = table_of_overlapping_clusters{i,"Z Score"};
    current_cluster_num = table_of_overlapping_clusters{i,"Cluster #"};
    current_overlap_percentages = table_of_overlapping_clusters{i,"Overlap %"}{1};
    current_other_tetrode_appearences = table_of_overlapping_clusters{i,"Tetrode"}{1};
    current_cluster_other_appearence = table_of_overlapping_clusters{i,"Other Appearences"}{1};
    current_tetrode = table_of_only_neurons{i,"Tetrode"};

    %use this for loop to compile all of the grades of the best
    %representations into a single table
    table_of_other_appearences = table(repelem("",10000,1),nan(10000,1),nan(10000,1),nan(10000,1),repelem("",10000,1),nan(10000,1),'VariableNames',["Tetrode","Cluster","Z Score","SNR","Overlap Percentage","idx of its location in arrays"]);

    current_appearence_grades = grades_array{i};

    %insert the current cluster into the table of other appearences
    table_of_other_appearences{1,1} = current_tetrode;
    table_of_other_appearences{1,2} = current_cluster_num;
    table_of_other_appearences{1,3} = current_z_score;
    table_of_other_appearences{1,4} = current_appearence_grades(40); %the SNR grade which we hope to maximize
    table_of_other_appearences{1,5} = "100%";
    table_of_other_appearences{1,6} = i;

    %if there are no other appearences of this cluster then it is
    %automatically the best
    if isempty(current_overlap_percentages)
        %ensure that this cluster hasn't already been represented somewhere
        %else
        if  ~isempty(already_appeared) % check to ensure that there are no other clusters have been added to already_appeared
            to_be_added =table_of_other_appearences{1,"Tetrode"}+" "+string(table_of_other_appearences{1,"Z Score"})+" "+string(table_of_other_appearences{1,"Cluster"}) ;
            if ~ismember(to_be_added,already_appeared) %checks to ensure that this cluster hasn't already been added to the table of best appearences
                disp("Finished "+string(i)+"/"+string(size(table_of_only_neurons,1)));
                table_of_best_representation{i,:} = table_of_other_appearences{1,:};
            end
        else %if they haven't been added and this cluster has no other clusters that it overlaps with then it really is the first and only and thus best representation
            disp("Finished "+string(i)+"/"+string(size(table_of_only_neurons,1)));
            table_of_best_representation{i,:} = table_of_other_appearences{1,:};
            to_be_added =table_of_other_appearences{1,"Tetrode"}+" "+string(table_of_other_appearences{1,"Z Score"})+" "+string(table_of_other_appearences{1,"Cluster"}) ;
            already_appeared = [already_appeared,to_be_added];
        end
        continue;
    end

    for other_appearence_counter=1:length(current_overlap_percentages)
        if isempty(current_overlap_percentages)
            continue
        end
        other_tetrode = current_other_tetrode_appearences(other_appearence_counter);
        other_z_score_and_cluster_number = split(current_cluster_other_appearence(other_appearence_counter)," ");
        other_z_score = split(other_z_score_and_cluster_number{1},":");
        % if (other_tetrode=="t104" && current_tetrode=="t107") || (other_tetrode=="t107" && current_tetrode=="t104")
        %     disp("Something")
        % end
        if isempty(other_z_score) || isempty(other_z_score{1})
            disp("No other appearences of this cluster")
            continue;
        end
        % disp(other_z_score);
        other_z_score = str2double(other_z_score{2});
        other_cluster_number = other_z_score_and_cluster_number{3};
        other_cluster_number = str2double(other_cluster_number);
        other_overlap_percentage = current_overlap_percentages(other_appearence_counter);

        %get the grades of the other appearences
        [idx_of_array_with_appr_grades, ~] = find(table_of_only_neurons.Tetrode == other_tetrode & table_of_only_neurons.Cluster ==other_cluster_number & table_of_only_neurons.("Z Score") == other_z_score);
        grades_of_other_appearence = grades_array{idx_of_array_with_appr_grades};

        table_of_other_appearences{other_appearence_counter+1,1} = other_tetrode;
        table_of_other_appearences{other_appearence_counter+1,2} = other_cluster_number;
        table_of_other_appearences{other_appearence_counter+1,3} = other_z_score;
        table_of_other_appearences{other_appearence_counter+1,4} = grades_of_other_appearence(40); %the SNR grade
        table_of_other_appearences{other_appearence_counter+1,5} = current_overlap_percentages(other_appearence_counter);
        table_of_other_appearences{other_appearence_counter+1,6} = idx_of_array_with_appr_grades;
    end

    % remove any rows that empty 
    table_of_other_appearences = rmmissing(table_of_other_appearences);

    
    %pick the row with the best(highest) signal to noise ratio (AKA grade 40)
    %row_with_higest_snr = find(max(:))

    [best_rep,~] = find(table_of_other_appearences.SNR ==max(table_of_other_appearences.SNR));

    %if there are multiple rows with the same highest SNR then you simply
    %choose the first
    if size(best_rep,1) > 1
        best_rep = best_rep(1);
    end

    %ensure that no other clusters that this cluster overlaps with has
    %already been represented elsewhere, if so it cannot be added again
    %this should remove the repeat of clusters in the case of auxilary
    %clusters
    % if (table_of_other_appearences{best_rep,"Tetrode"} == "t107" && table_of_other_appearences{best_rep,"Z Score"}==9 && table_of_other_appearences{best_rep,"Cluster"}==3) || (table_of_other_appearences{best_rep,"Tetrode"} == "t104" && table_of_other_appearences{best_rep,"Z Score"}==9 && table_of_other_appearences{best_rep,"Cluster"}==3)
    %     disp("something")
    % end
    if i==1
        already_appeared = table_of_other_appearences{:,"Tetrode"}+" "+table_of_other_appearences{:,"Z Score"}+" "+table_of_other_appearences{:,"Cluster"};
        table_of_best_representation{i,:} = table_of_other_appearences{best_rep,:};
    else
        %check to ensure that this cluster hasn't already appeared on
        %another cluster's best appearences list
        %this ensures that there's no duplicates (multiple clusters
        %representing the same unit
        to_be_added = table_of_other_appearences{best_rep,"Tetrode"}+" "+table_of_other_appearences{best_rep,"Z Score"}+" "+table_of_other_appearences{best_rep,"Cluster"};
        if ismember(to_be_added,already_appeared)
            %if to_be_added is already a member of the
            %already_appeared_list then we take all of its other
            %appearences and union that with the already_appeared list
            %this ensures the elimination of auxilary clusters
            already_appeared = union(already_appeared,table_of_other_appearences{:,"Tetrode"}+" "+table_of_other_appearences{:,"Z Score"}+" "+table_of_other_appearences{:,"Cluster"});
            disp("Finished "+string(i)+"/"+string(size(table_of_only_neurons,1)));
            continue;
        else
            best_appearences = table_of_best_representation(~isnan(table_of_best_representation{:,"Cluster"}),:);
            %before adding the cluster to the table of best representations
            %ensure it doesn't have a significant amount of overlap with
            %another cluster that's already on the table
            %this ensures that we are not oversplitting the cluster
            is_already_represented=false;
            for best_appearences_row_counter=1:size(best_appearences,1)
                timestamps_of_current_best_appearences = timestamp_array{table_of_other_appearences{best_rep,"idx of its location in arrays"}};
                timestamps_of_previously_found_best_appearences = timestamp_array{best_appearences{best_appearences_row_counter,"idx of its location in arrays"}};
                size_of_smaller_cluster = min(length(timestamps_of_current_best_appearences),length(timestamps_of_previously_found_best_appearences)) ;
                true_overlap_percentage = length(intersect(timestamps_of_current_best_appearences,timestamps_of_previously_found_best_appearences)/size_of_smaller_cluster);
                if true_overlap_percentage > min_overlap_percentage
                    is_already_represented = true;
                end
            end
            if ~is_already_represented
                table_of_best_representation{i,:} = table_of_other_appearences{best_rep,:};
            end
            already_appeared = union(already_appeared,table_of_other_appearences{:,"Tetrode"}+" "+table_of_other_appearences{:,"Z Score"}+" "+table_of_other_appearences{:,"Cluster"});
        end

    end

   

    disp("Finished "+string(i)+"/"+string(size(table_of_only_neurons,1)));

end

table_of_best_representation(isnan(table_of_best_representation{:,"Cluster"}),:) = [];
%now only return the unique versions 
table_of_best_representation = unique(table_of_best_representation,"stable",'rows');

%remove any rows that have a negative snr
table_of_best_representation(table_of_best_representation{:,"SNR"}<=0,:) = [];
end