function [] = cull_noise_clusters(unique_clusters,associated_tetrodes,dir_with_nth_pass_grades,dir_with_nth_pass_results,plot_the_original_ouput,grade_to_use,less_than_or_greater,min_grade_threshold)
    function [] = plot_a_useful_example(dir_with_nth_pass_results,current_tetrode,list_of_tetrodes,just_tetrode_number,grades,current_cluster)
        output = importdata(dir_with_nth_pass_results+"\"+current_tetrode+" output.mat");
        aligned = importdata(dir_with_nth_pass_results+"\"+current_tetrode+" aligned.mat");
        idx = extract_clusters_from_output(output(:,1),output,spikesort_config);
        for first_dimension = 1:length(list_of_tetrodes(just_tetrode_number,:))
            for second_dimension = first_dimension+1:length(list_of_tetrodes(just_tetrode_number,:))
                new_plot_proj_ver_3(idx,aligned,first_dimension,second_dimension,list_of_tetrodes(just_tetrode_number,:),current_tetrode,current_cluster,grades(:,2),grades(:,8),grades(:,9));
            end
        end
    end
%use this function to remove noise clusters and co activation clusters to remove computation cost later
list_of_tetrodes = build_artificial_tetrode();
couldnt_load = 0;
for i=1:length(unique_clusters)
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
    table_of_grades = cell2table(cell(length(tetrodes_associated_with_current_cluster),6),'VariableNames',["OG tetrode","tightness","%Short ISI","Incompleteness","Template Matching","Min Bhat"]);
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
            disp("Tetrode: " + current_tetrode + " reported to have "+ string(current_cluster)+ " but grades say there are only "+string(size(grades,1))+ " clusters")
            continue;
        else
            grades_for_associated_clusters(j,:) = grades(current_cluster,relevant_grades);
        end
        table_of_grades{j,1} = {current_tetrode};
        table_of_grades{j,2} = {grades_for_associated_clusters(j,1)};
        table_of_grades{j,3} = {grades_for_associated_clusters(j,2)};
        table_of_grades{j,4} = {grades_for_associated_clusters(j,3)};
        table_of_grades{j,5} = {grades_for_associated_clusters(j,4)};
        table_of_grades{j,6} = {grades_for_associated_clusters(j,5)};

        if plot_the_original_ouput && less_than_or_greater==0
            condition = table_of_grades.(grade_to_use);
            condition = condition{j} < min_grade_threshold;
            if any(condition,"all")
                plot_a_useful_example(dir_with_nth_pass_results,current_tetrode,list_of_tetrodes,just_tetrode_number,grades,current_cluster)
                disp("Found possible noise cluster");
            end
        elseif plot_the_original_ouput && less_than_or_greater == 1
            condition = table_of_grades.(grade_to_use);
            condition = condition(j) >min_grade_threshold;
            if any(condition,"all")
                plot_a_useful_example(dir_with_nth_pass_results,current_tetrode,list_of_tetrodes,just_tetrode_number,grades,current_cluster)
                disp("Found possible noise cluster");
            end
        end
        original_tetrodes = [original_tetrodes;current_tetrode];
    end
    if couldnt_load
        couldnt_load = 0;
    else
        disp(table_of_grades)
    end
    channels_in_tetrode = unique(channels_in_tetrode);
    disp("Finished "+ string(i)+"/"+string(length(unique_clusters)));
end


end