function [] = find_auxilary_overlap_clusters(table_of_overlapping_clusters,tetrodes_to_look_for,z_score_to_look_for,table_of_only_neurons)
overlapping_clusters_containing_tetr = cell2table(cell(0,6),'VariableNames',["Tetrode","Z Score","Cluster #","Overlap %","Other Appearences","Other Appearence Tetrode"]);

for i=1:size(table_of_overlapping_clusters,1)
    current_list_of_other_appearences = table_of_overlapping_clusters{i,"Tetrode"};
    current_list_of_other_appearences_z_scores = table_of_overlapping_clusters{i,"Other Appearences"};
    has_any = false;
    % all_data = squeeze(split(z_score_to_look_for," "));
    % z_score = squeeze(split(all_data(:,1),":"));
    % z_score =str2double(z_score(:,2));
    % cluster =str2double(all_data(:,3));

    % if ismember(table_of_overlapping_clusters{i,"Z Score"}, z_score) && ismember(table_of_overlapping_clusters{i,"Cluster #"},cluster)
        for j=1:length(tetrodes_to_look_for)

            if contains(current_list_of_other_appearences,tetrodes_to_look_for(j)) || contains(current_list_of_other_appearences_z_scores,z_score_to_look_for(j))
                has_any=true;
            end

        end
    % else
    %     continue
    % end
    if has_any
        single_row = table(table_of_only_neurons{i,2},table_of_overlapping_clusters{i,1},table_of_overlapping_clusters{i,2},table_of_overlapping_clusters{i,3},table_of_overlapping_clusters{i,4},table_of_overlapping_clusters{i,5},'VariableNames',["Tetrode","Z Score","Cluster #","Overlap %","Other Appearences","Other Appearence Tetrode"]);
        overlapping_clusters_containing_tetr = [overlapping_clusters_containing_tetr;single_row];
    end
end

% now that you have the lists of where the tetrodes you want to debug appear 
% we want to find the lists that exclude one of the tetrodes you're looking

array_of_exclusionary_lists = cell(1,length(tetrodes_to_look_for));
for i=1:length(array_of_exclusionary_lists)
    contains_one_without_the_other = boolean(zeros(size(overlapping_clusters_containing_tetr,1),1));
    current_formatted_data = tetrodes_to_look_for(i) +" "+ z_score_to_look_for(i); 
    for j=1:size(overlapping_clusters_containing_tetr,1)
        current_z_score_and_cluster_data = split(overlapping_clusters_containing_tetr{j,"Other Appearences"},"|");
        current_other_tetrode_data = split(overlapping_clusters_containing_tetr{j,"Other Appearence Tetrode"},"|");
        formatted_z_score_cluster_and_tetrode = strcat(current_other_tetrode_data," ",current_z_score_and_cluster_data);

        if ismember(current_formatted_data,formatted_z_score_cluster_and_tetrode)
            contains_one_without_the_other(j) = true;
        end


        for k=1:length(array_of_exclusionary_lists)
            if k==i
                continue;
            end
            other_formatted_data = tetrodes_to_look_for(k) + " " + z_score_to_look_for(k);
            if ismember(other_formatted_data,formatted_z_score_cluster_and_tetrode)
                contains_one_without_the_other(j)=false;
            end
        end


    end
    array_of_exclusionary_lists{i} = overlapping_clusters_containing_tetr(contains_one_without_the_other,:);
end

end