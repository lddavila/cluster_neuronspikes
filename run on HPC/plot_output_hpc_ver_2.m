function [] = plot_output_hpc_ver_2(generic_dir_with_grades,generic_dir_with_outputs,table_of_best_rep,refinement_pass,grades_to_check,names_of_grades)

subset_of_best_rep = table_of_best_rep(:,["Tetrode","Z Score"]);
unique_rows_of_best_rep = unique(subset_of_best_rep,"rows");


% list_of_tetrodes_to_check = unique(table_of_best_rep,"stable","rows");
% number_of_times_the_for_loop_will_run = size(table_of_best_rep,1);

%slice the data
table_of_best_rep_in_cell_format = cell(1,size(table_of_best_rep,1));
for i=1:size(unique_rows_of_best_rep,1)
    current_z_score = table_of_best_rep{i,"Z Score"};
    current_tetrode = table_of_best_rep{i,"Tetrode"};
    current_cluster = table_of_best_rep{i,"Cluster"};
    table_of_best_rep_in_cell_format{i} = table_of_best_rep(table_of_best_rep{:,"Z Score"}==current_z_score & table_of_best_rep{:,"Tetrode"}==current_tetrode & table_of_best_rep{:,"Cluster"}==current_cluster,:);
end
number_of_times_the_for_loop_will_run = length(table_of_best_rep_in_cell_format);
parfor tetrode_counter=1:length(table_of_best_rep_in_cell_format)
    % current_tetrode = list_of_tetrodes_to_check(tetrode_counter);
    try
        art_tetr_array = build_artificial_tetrode();
        current_data = table_of_best_rep_in_cell_format{tetrode_counter};
        current_z_score = current_data{1,"Z Score"};
        current_clust = current_data{:,"Cluster"};
        current_clust = join(string(current_clust));
        current_tetrode = current_data{1,"Tetrode"};
        current_tetrode_number = str2double(strrep(current_tetrode,"t",""));

        channels_of_curr_tetr = art_tetr_array(current_tetrode_number,:);
        if ~refinement_pass
            dir_with_grades = generic_dir_with_grades + " "+string(current_z_score) + " grades";
            dir_with_outputs = generic_dir_with_outputs +string(current_z_score);
        else
            dir_with_grades = generic_dir_with_grades;
            dir_with_outputs = generic_dir_with_outputs;
        end
        [current_grades,~,aligned,~,idx_b4_filt] = import_data_hpc(dir_with_grades,dir_with_outputs,current_tetrode,refinement_pass);
        if any(isnan(current_grades))
            continue;
        end
        table_of_cluster_classification = table(repelem("default value",size(current_grades,1),1),repelem("default value",size(current_grades,1),1),nan(size(current_grades,1),1),nan(size(current_grades,1),1),'VariableNames',["category","tetrode","cluster","z-score"]);
        % list_of_clusters = 1:length(idx_b4_filt);
        % idx_aft_filt = cell(1,length(idx_b4_filt));
        for cluster_counter=1:size(current_grades,1)
            current_cluster_grades = current_grades(cluster_counter,:);
            current_cluster_category = classify_clusters_based_on_grades_ver_2(current_cluster_grades);
            table_of_cluster_classification{cluster_counter,1} = current_cluster_category;
            table_of_cluster_classification{cluster_counter,2} = current_tetrode;
            table_of_cluster_classification{cluster_counter,3} = cluster_counter;
            table_of_cluster_classification{cluster_counter,4} = current_z_score;

            % sprintf("%i / %i Finished",tetrode_counter,length(list_of_tetrodes_to_check))
        end


        disp(current_data{1,"Classification"}+" Finished "+string(tetrode_counter)+" /"+string(length(number_of_times_the_for_loop_will_run)))
        % clc;
        current_clusters_category = table_of_cluster_classification{:,"category"};
        current_clusters_max_overlap_perc_with_unit =current_data{:,"Max Overlap % With Unit"} ;
        current_clusters_max_overlap_unit = current_data{:,"Max Overlap Unit"};
        plot_the_clusters_hpc(channels_of_curr_tetr,{idx_b4_filt{str2double(current_clust)}},"before",aligned,current_clusters_category,current_tetrode,current_z_score,current_clust,grades_to_check,names_of_grades,current_grades,current_clusters_max_overlap_perc_with_unit,current_clusters_max_overlap_unit);
        close all;
    catch ME
        disp("############################################")
        disp("Tetrode "+string(tetrode_counter) + " Errored")
        disp(ME.identifier)
        disp(ME.message)
        disp(ME.cause)
        disp(ME.stack)
        disp(ME.Correction)
        disp("###########################################")
    end

end


end