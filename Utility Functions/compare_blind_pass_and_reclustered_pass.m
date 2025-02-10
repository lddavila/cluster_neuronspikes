function [all_best_accuracies_array,all_best_overlaps_array,all_best_grades_array] = compare_blind_pass_and_reclustered_pass(blind_pass_best,reclustering_pass_best,table_of_accuracy_from_blind_pass,table_of_accuracy_from_reclustering_pass,dir_with_reclustering_pass_grades,grades_to_check,names_of_grades,dir_with_reclustering_pass_results,generic_blind_pass_grades_dir,generic_blind_pass_results_dir,dir_to_save_plots,make_plots)
unique_units = unique(table_of_accuracy_from_blind_pass.("unit_id"));
array_of_overlap_for_blind_pass = reshape(table_of_accuracy_from_blind_pass{:,"overlap_with_unit"},length(unique_units),[]); %add the column/row info as well as the reshape
array_of_overlap_for_reclustered_pass = reshape(table_of_accuracy_from_reclustering_pass{:,"overlap_with_unit"},length(unique_units),[]); %add the column/row info as well as the reshape

array_of_accuracy_for_blind_pass = reshape(table_of_accuracy_from_blind_pass{:,"accuracy"},length(unique_units),[]); %add the column/row info as well as the reshape
array_of_accuracy_for_reclustered_pass =  reshape(table_of_accuracy_from_reclustering_pass{:,"overlap_with_unit"},length(unique_units),[]); %add the column/row info as well as the reshape

array_of_names_blind_pass = reshape(table_of_accuracy_from_blind_pass{:,"og_tetr_and_clust_num"},length(unique_units),[]);
array_of_names_reclustered_pass = reshape(table_of_accuracy_from_reclustering_pass{:,"og_tetr_and_clust_num"},length(unique_units),[]);
unique_unit_names = string(unique_units); %add the column info

all_best_accuracies_array = nan(length(unique_units),1);
all_best_overlaps_array = nan(length(unique_units),1);

all_best_grades_array = nan(length(unique_units),length(grades_to_check));
for i=1:length(unique_unit_names)
    %look at row i of array_of_overlap_for_blind_pass and
    %array_of_overlap_for_reclustered_pass for the column with the highest
    %overlap percentage
    current_blind_pass_cluster_tetrode_and_z_score = array_of_names_blind_pass(i,:);
    current_reclustered_pass_cluster_and_tetrode = array_of_names_reclustered_pass(i,:);
    
    [bp_max_overlap,bp_max_overlap_index] = max(array_of_overlap_for_blind_pass(i,:));
    [rp_max_overlap,rp_max_overlap_index] = max(array_of_overlap_for_reclustered_pass(i,:));

    [bp_max_accuracy,bp_max_accuracy_index] = max(array_of_accuracy_for_blind_pass(i,:));
    [rp_max_accuracy,rp_max_accuracy_index] = max(array_of_accuracy_for_reclustered_pass(i,:));

    %in theory max accuracy and overlap should go hand in hand
    %if not then there's something weird going on 
    %and we should explore it 
    if bp_max_accuracy_index ~= bp_max_overlap_index || rp_max_accuracy_index ~= rp_max_overlap_index
        disp("Unit "+string(i)+ " Has differing indexes in max accuracy and max overlap")
        continue;        
    end
    name_of_highest_overlap_and_accuracy_bp = split(current_blind_pass_cluster_tetrode_and_z_score(bp_max_overlap_index),"_");
    name_of_highest_overlap_and_accuracy_rc = split(current_reclustered_pass_cluster_and_tetrode(rp_max_overlap_index),"_");

    rc_current_tetrode = name_of_highest_overlap_and_accuracy_rc(1);
    rc_cluster = str2double(name_of_highest_overlap_and_accuracy_rc(2));

    bp_current_tetrode = name_of_highest_overlap_and_accuracy_bp(1);
    bp_current_cluster = str2double(name_of_highest_overlap_and_accuracy_bp(2));
    bp_current_z_score = name_of_highest_overlap_and_accuracy_bp(4);
    dir_with_blind_pass_grades = strrep(generic_blind_pass_grades_dir,"!",bp_current_z_score);
    dir_with_blind_pass_results = strrep(generic_blind_pass_results_dir,"!",bp_current_z_score);


    %get_data_of_neurons_identified_as_clusters
    [grades_rc,output_rc,aligned_rc,reg_timestamps_of_the_spikes_rc,idx_rc]= import_data(dir_with_reclustering_pass_grades,dir_with_reclustering_pass_results,rc_current_tetrode,true); %% add the actual info to get reclustering pass data here
    [grades_bp,output_bp,aligned_bp,reg_timestamps_of_the_spikes_bp,idx_bp] = import_data(dir_with_blind_pass_grades,dir_with_blind_pass_results,bp_current_tetrode,true); %% add the actual info to get blind pass data here


    relevant_grades_bp = grades_bp(bp_current_cluster,grades_to_check);
    relevant_grades_rc = grades_rc(rc_cluster,grades_to_check);
    grades_for_bp_and_rc_pass = [relevant_grades_bp.',relevant_grades_rc.'];


    all_best_accuracies_array(i) = rp_max_accuracy -bp_max_accuracy ;

    all_best_overlaps_array(i) = rp_max_overlap -bp_max_overlap ;
    
    all_best_grades_array(i,:) =relevant_grades_rc- relevant_grades_bp;

    %I want to create a figure which reflects the increase/decrease in the
    %desired grades (bar graph maybe)
    %the array of grades should be a nx2 array
    %where the 1st column is the grades from the blind pass
    %and the second column is the grades from the reclustering pass
    %
    if ~exist(dir_to_save_plots,"dir") && make_plots
        mkdir(dir_to_save_plots)
        mkdir(dir_to_save_plots+"\change in accuracy and overlap between blind pass and reclustered pass")
        mkdir(dir_to_save_plots+"\change in grades between blind pass and reclustered pass")
    end
    if make_plots
        figure('units','normalized','OuterPosition',[0 0 1 1]);
        x_values = ["overlap","accuracy"];
        y_values = [bp_max_overlap,rp_max_overlap;
            bp_max_accuracy,rp_max_accuracy;];
        bar(x_values,y_values)
        title("Unit "+i)
        legend([strjoin(name_of_highest_overlap_and_accuracy_bp)+" BP",strjoin(name_of_highest_overlap_and_accuracy_rc)+"RP"])
        saveas(gcf,dir_to_save_plots+"\change in accuracy and overlap between blind pass and reclustered pass\Unit "+string(i)+".fig")

        figure('units','normalized','OuterPosition',[0 0 1 1])
        for j=1:size(grades_for_bp_and_rc_pass,1)
            subplot(1,size(grades_for_bp_and_rc_pass,1),j);
            y_values = grades_for_bp_and_rc_pass(j,:);
            bar(names_of_grades(j),y_values);
            % title(names_of_grades(j))
            if j==1
                legend([strjoin(name_of_highest_overlap_and_accuracy_bp)+" BP",strjoin(name_of_highest_overlap_and_accuracy_rc)+"RP"])
            end
        end
        sgtitle("Unit "+string(i));
        saveas(gcf,dir_to_save_plots+"\change in grades between blind pass and reclustered pass\Unit "+string(i)+".fig")
    end
    close all;
    disp("compare_blind_pass_and_reclustered_pass.m Finished "+string(i)+"/"+string(length(unique_unit_names)))
end


end