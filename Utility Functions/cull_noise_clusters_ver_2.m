function [associated_tetrodes_without_noise,cluster_timestamps_without_noise] = cull_noise_clusters_ver_2(unique_clusters,associated_tetrodes,dir_with_nth_pass_grades,dir_with_nth_pass_results,plot_the_original_ouput,condition_names_to_use,conditions,values_to_compare_against,min_amplitude)
    function [] = plot_a_useful_example(dir_with_nth_pass_results,current_tetrode,list_of_tetrodes,just_tetrode_number,grades,current_cluster,test_it_failed_on)
        output = importdata(dir_with_nth_pass_results+"\"+current_tetrode+" output.mat");
        aligned = importdata(dir_with_nth_pass_results+"\"+current_tetrode+" aligned.mat");
        idx = extract_clusters_from_output(output(:,1),output,spikesort_config);
        for first_dimension = 1:length(list_of_tetrodes(just_tetrode_number,:))
            for second_dimension = first_dimension+1:length(list_of_tetrodes(just_tetrode_number,:))
                if size(grades(:,2),1) == 1
                    return;
                end
                new_plot_proj_ver_3(idx,aligned,first_dimension,second_dimension,list_of_tetrodes(just_tetrode_number,:),current_tetrode,current_cluster,grades(:,2),grades(:,8),grades(:,9),test_it_failed_on);
            end
        end
    end
%use this function to remove noise clusters and co activation clusters to remove computation cost later
list_of_tetrodes = build_artificial_tetrode();
couldnt_load = 0;
associated_tetrodes_without_noise = cell(1,length(unique_clusters));
cluster_timestamps_without_noise = cell(1,length(unique_clusters));
for i=2:length(unique_clusters)
    if isempty(unique_clusters{i})
        continue;
    end
    if isempty(associated_tetrodes{i})
        continue
    end
    tetrodes_associated_with_current_cluster = associated_tetrodes{i};
    %relevant grades include
    %tightness 2
    %percent short isi 3
    %incompleteness 4
    %template matching 8
    %min bhat 9
    relevant_grades = [2 3 4 8 9];
    grades_for_associated_clusters = zeros(length(tetrodes_associated_with_current_cluster),5);
    grades_for_associated_clusters = grades_for_associated_clusters ./ 0;
    channels_in_tetrode = [];
    original_tetrodes = [];
    e_r = {"",inf,inf,inf,inf,inf,-inf};
    table_of_grades = table(e_r{1},e_r{2},e_r{3},e_r{4},e_r{5},e_r{6},e_r{7},'VariableNames',{'OG tetrode','tightness','%Short ISI','Incompleteness','Template Matching','Min Bhat','Is_Noise'});
    timestamps_in_noise_clusters = [];
    for j=1:length(tetrodes_associated_with_current_cluster)
        current_tetrode_and_cluster= tetrodes_associated_with_current_cluster(j);
        current_tetrode_and_cluster = split(current_tetrode_and_cluster," ");
        current_tetrode = current_tetrode_and_cluster(1);
        just_tetrode_number = str2double(strrep(current_tetrode(),"t",""));
        channels_in_tetrode = [channels_in_tetrode,list_of_tetrodes(just_tetrode_number,:)];
        current_cluster = str2double(current_tetrode_and_cluster(2));
        try
            load(dir_with_nth_pass_grades+"\"+current_tetrode+".mat",'grades');
        catch
            couldnt_load=1;
            continue;
        end

        if current_cluster > size(grades,1)
            disp("Tetrode: " + current_tetrode + " reported to have "+ string(current_cluster)+ " but grades say there are only "+string(size(grades,1))+ " clusters");
            continue;
        else
            grades_for_associated_clusters(j,:) = grades(current_cluster,relevant_grades);
        end

        current_grades = table(current_tetrode+" "+string(current_cluster),(grades_for_associated_clusters(j,1)),grades_for_associated_clusters(j,2),grades_for_associated_clusters(j,3),grades_for_associated_clusters(j,4),grades_for_associated_clusters(j,5),NaN,'VariableNames',["OG tetrode","tightness","%Short ISI","Incompleteness","Template Matching","Min Bhat","Is_Noise"]);
        table_of_grades = [table_of_grades;current_grades];
        [does_it_meet_minimum_qualifications,test_it_failed_on]= apply_noise_conditions_for_table(current_grades,condition_names_to_use,conditions,values_to_compare_against,1);
        if ~does_it_meet_minimum_qualifications %if it fails the other tests it might pass based on amplitude alone
            [does_it_meet_minimum_qualifications,compare_wire,mean_of_compare_wire] =check_amplitude(dir_with_nth_pass_results,current_cluster,current_tetrode,min_amplitude);
            if ~does_it_meet_minimum_qualifications
                test_it_failed_on = "Amplitude" + " Mean of Compare Wire("+string(compare_wire)+"):" + string(mean_of_compare_wire + " Min Amp Thr: "+string(min_amplitude));
            end
        end
        table_of_grades{j+1,7} = ~does_it_meet_minimum_qualifications;

        if ~does_it_meet_minimum_qualifications
            output_of_current_tetrode = importdata(dir_with_nth_pass_results+"\"+current_tetrode+" output.mat");
            idx_of_current_tetrode = extract_clusters_from_output(output_of_current_tetrode(:,1),output_of_current_tetrode,spikesort_config);
            timestamps_of_current_tetrode = importdata(dir_with_nth_pass_results+"\"+current_tetrode+" reg_timestamps.mat");
            timestamps_of_current_cluster = timestamps_of_current_tetrode(idx_of_current_tetrode{current_cluster});
            timestamps_in_noise_clusters = [timestamps_in_noise_clusters,timestamps_of_current_cluster.'];
        end
        if plot_the_original_ouput %&& ~does_it_meet_minimum_qualifications
             plot_a_useful_example(dir_with_nth_pass_results,current_tetrode,list_of_tetrodes,just_tetrode_number,grades,current_cluster,test_it_failed_on)
             % disp("Found possible noise cluster");
             % close all;
        end
        original_tetrodes = [original_tetrodes;current_tetrode];
    end
    if couldnt_load
        couldnt_load = 0;
    else
        disp(table_of_grades)
        table_of_only_non_noise_clusters =table_of_grades{table_of_grades.("Is_Noise")==false,:};
        associated_tetrodes_without_noise{i} = table_of_only_non_noise_clusters(:,1);

        cluster_timestamps_without_noise{i} = setdiff(unique_clusters{i},timestamps_in_noise_clusters);
    end
    channels_in_tetrode = unique(channels_in_tetrode);

    disp("Finished "+ string(i)+"/"+string(length(unique_clusters)));
end

 % clusters_without_noise_clusters = clusters_without_noise_clusters(~cellfun('isempty',clusters_without_noise_clusters)) ; 
end