function [table_of_cluster_classification] = grade_clusters_hpc(generic_dir_with_grades,generic_dir_with_outputs,possible_z_scores,list_of_tetrodes_to_check,debug,relevant_grades,relevant_grade_names,dir_to_save_figs_to,refinement_pass)
%relevant grades include
%2 cv 2
%3 percent short isi 3
%4 incompleteness 4
%8 template matching 8
%9 min bhat 9
%28 skewness of cluster
%29 measure the difference between the cluster's individual spikes and the
%cluster's spike templates
%30 Incompleteness using histogram symmetry
%31 Classification of cluster amplitude
%32 classification of cluster amplitude based only on rep wire
%34 min bhat distance from all the clusters in the current configuration which are likely to be co activation

%possible classifications
%probably a neuron - passes all tests that I care about so far
%might be a neuron - doesn't pass all the test, but is saved by its bhat distance from clusters identified as multiunit activity
%probably multi unit activity - a cluster which does not tie to a neuron, but may tie to a helpful multi unit activity cluster, therefore we do not purge it

%10000 default rows are preallocated as an upper bound on clusters
%its unlikely that all rows will be filled, and in case they are you can
%simply preallocate more
table_of_cluster_classification = table(repelem("default value",10000,1),repelem("default value",10000,1),nan(10000,1),nan(10000,1),'VariableNames',["category","tetrode","cluster","z-score"]);
art_tetr_array = build_artificial_tetrode();

row_counter=1;
if refinement_pass
    ending_point = 1;
else
    ending_point=length(possible_z_scores);
end
for z_score_counter=1:ending_point
    if ~refinement_pass
        current_z_score = possible_z_scores(z_score_counter);
    else
        current_z_score = NaN;
    end
    for tetrode_counter=1:length(list_of_tetrodes_to_check)
        current_tetrode = list_of_tetrodes_to_check(tetrode_counter);
        channels_of_curr_tetr = art_tetr_array(tetrode_counter,:);
        if ~refinement_pass
            dir_with_grades = generic_dir_with_grades + " "+string(current_z_score) + " grades";
            dir_with_outputs = generic_dir_with_outputs +string(current_z_score);
        else
            dir_with_grades = generic_dir_with_grades;
            dir_with_outputs = generic_dir_with_outputs;
        end
        [current_grades,~,~,~,idx_b4_filt] = import_data_hpc(dir_with_grades,dir_with_outputs,current_tetrode,refinement_pass);
        if any(isnan(current_grades))
            continue;
        end
        list_of_clusters = 1:length(idx_b4_filt);
        idx_aft_filt = cell(1,length(idx_b4_filt));
        current_clusters_category = [];
        for cluster_counter=1:size(current_grades,1)
            current_cluster_grades = current_grades(cluster_counter,:);
            if size(idx_b4_filt{cluster_counter},1) <=100
                current_cluster_category = "Not Enough Data c1";
                idx_aft_filt{cluster_counter} = idx_b4_filt{cluster_counter};
            elseif current_cluster_grades(37) <1.1
                current_cluster_category = "Probably Multi Unit Activity c2";
            elseif current_cluster_grades(37) > 10
                current_cluster_category = "Probably a Neuron c3";
            elseif current_cluster_grades(2) < 0.1 && current_cluster_grades(31) > 1 && current_cluster_grades(30) < 7 && current_cluster_grades(31) > 1
                current_cluster_category = "Probably A Neuron c4";
                idx_aft_filt{cluster_counter} = idx_b4_filt{cluster_counter};
            elseif current_cluster_grades(2) < 0.1  && current_cluster_grades(30) < 7 && current_cluster_grades(32) > 1
                current_cluster_category = "Probably A Neuron c5";
                idx_aft_filt{cluster_counter} = idx_b4_filt{cluster_counter};
            elseif current_cluster_grades(34) > 20 && (current_cluster_grades(33) == 2 || current_cluster_grades(33)==1) && ~isinf(current_cluster_grades(34))
                current_cluster_category =  "Probabaly A Neuron c6";
                idx_aft_filt{cluster_counter} = idx_b4_filt{cluster_counter};
            elseif current_cluster_grades(34)>12 && current_cluster_grades(33) == 2  && current_cluster_grades(32) >1
                current_cluster_category = "Probably A Neuron c7";
            elseif current_cluster_grades(34)>12 && current_cluster_grades(33) ==2
                current_cluster_category = "Maybe a Neuron c8";
                idx_aft_filt{cluster_counter} = idx_b4_filt{cluster_counter};
            elseif current_cluster_grades(2) > 0.1&& current_cluster_grades(34)>4 && (current_cluster_grades(33) == 2 || current_cluster_grades(33) == 1)
                current_cluster_category = "Probably Multi Unit Activity c9";
            elseif current_cluster_grades(34)>4 && (current_cluster_grades(33) == 2 || current_cluster_grades(33) == 1)
                current_cluster_category = "Maybe multi unit actvity c10";
                idx_aft_filt{cluster_counter} = idx_b4_filt{cluster_counter};
            elseif current_cluster_grades(34) > 4 && current_cluster_grades(33) ~=1
                current_cluster_category = "Might Be a Neuron c11";
                idx_aft_filt{cluster_counter} = idx_b4_filt{cluster_counter};
            elseif current_cluster_grades(33) == 1
                current_cluster_category = "Probably Multi Unit Activity c12";
                idx_aft_filt{cluster_counter} = idx_b4_filt{cluster_counter};
            elseif current_cluster_grades(33) == 2 && current_cluster_grades(31) ==1
                current_cluster_category = "Probably Multi Unit Activity c13";
            elseif current_cluster_grades(33) == 2
                current_cluster_category = "Might Be Multi Unit Activity c14";
                idx_aft_filt{cluster_counter} = idx_b4_filt{cluster_counter};
            else
                current_cluster_category = "No category";
                idx_aft_filt{cluster_counter} = idx_b4_filt{cluster_counter};
            end

            %   if contains(current_cluster_category,"Multi) %a special case to try and save multi unit activity to check if they are possibly bursting
            %check_for_cross_correlation_between_clusters(aligned,idx_b4_filt,debug,cluster_counter,ts)
            if current_cluster_grades(41) > 0.7
                current_cluster_category = current_cluster_category + " Hi Burst Ratio";
            end
            %            end

            %table_of_cluster_classication = table(repelem("default value",10000,1),repelem("default value",10000,1),nan(10000,1),nan(10000,1),'VariableNames',["category","tetrode","cluster","z-score"]);
            table_of_cluster_classification{row_counter,1} = current_cluster_category;
            table_of_cluster_classification{row_counter,2} = current_tetrode;
            table_of_cluster_classification{row_counter,3} = cluster_counter;
            table_of_cluster_classification{row_counter,4} = current_z_score;

            row_counter = row_counter+1;
            idx_aft_filt{cluster_counter} = idx_b4_filt{cluster_counter};
        end
        list_of_clusters(isnan(list_of_clusters)) = [];

        if debug
            clc;
            current_clusters_category = table_of_cluster_classification{table_of_cluster_classification{:,"tetrode"} == "t"+tetrode_counter,"category"};
            disp(current_clusters_category);
            
            %plot_the_clusters_ver_2(1:length(idx_b4_filt),channels_of_curr_tetr,idx_b4_filt,"Min Z Score "+ string(default_z_score)+"Before",current_grades,aligned,relevant_grades,relevant_grade_names);
            plot_the_clusters_ver_3(list_of_clusters,channels_of_curr_tetr,idx_aft_filt,"Min Z Score "+string(current_z_score) +"After",current_grades,aligned,relevant_grades,relevant_grade_names,current_clusters_category,dir_to_save_figs_to,current_tetrode);
            close all;
        end
        disp("Z Score:"+string(current_z_score)+" Finished "+string(tetrode_counter)+ "/"+string(length(list_of_tetrodes_to_check)));
        
    end
end

%remove any empty rows
%table_of_cluster_classification(table_of_cluster_classification(:,1)=="default value",:) = [];
table_of_cluster_classification(find(strcmpi(table_of_cluster_classification.category,"default value")),:) = [];

end