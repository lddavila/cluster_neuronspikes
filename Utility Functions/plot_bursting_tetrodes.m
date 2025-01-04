function [] = plot_bursting_tetrodes(tetrode_to_start_with,tetrode_to_end_with,dir_with_grades,dir_with_outputs,z_score,names_of_grades,relevant_grades)
list_of_tetrodes = strcat("t",string(1:285));
art_tetr_array = build_artificial_tetrode();
for tetrode_counter =tetrode_to_start_with:tetrode_to_end_with
    current_tetrode =list_of_tetrodes(tetrode_counter);
    [grades,output,aligned,reg_timestamps,idx] = import_data(dir_with_grades,dir_with_outputs,current_tetrode);
    figure;
    plot_counter=1;
    for first_dimension=1:4
        for second_dimension=first_dimension+1:4
            subplot(2,3,plot_counter);
            new_plot_proj_ver_5(idx,aligned,first_dimension,second_dimension,art_tetr_array(tetrode_counter,:),current_tetrode,z_score,plot_counter,string(1:size(grades,1)))
            plot_counter= plot_counter+1;
        end
    end
    sgtitle([current_tetrode,strjoin(string(art_tetr_array(tetrode_counter,:)))])

    figure
    heatmap(names_of_grades,string(1:size(grades,1)),grades(:,relevant_grades))
    title(current_tetrode)
    close all;
end
end