function [] = save_results_of_mua_or_not(file_with_og_plots,dir_to_save_plots_to,table_to_plot_from)

for i=1:size(table_to_plot_from,1)
    current_z =table_to_plot_from{i,"Z Score"};
    current_tetr =table_to_plot_from{i,"Tetrode"};
    current_clust =table_to_plot_from{i,"Cluster"};
    %Z Score 3 Tetrode t1 Cluster 1 Channels1 and 97
    current_grades = table_to_plot_from{i,"grades"}{1};
    channels = current_grades{49};
    first_dim = current_grades{42};
    sec_dim = current_grades{43};

    is_neuron = table_to_plot_from{i,"mua_or_not_by_nn"};
    
    file_string ="Z Score "+string(current_z)+" Tetrode "+current_tetr+" Cluster "+string(current_clust)+" Channels"+string(channels(first_dim))+" and "+string(channels(sec_dim))+".png";
    
    original_image = imread(fullfile(file_with_og_plots,file_string));
    if is_neuron
        imwrite(original_image,fullfile(dir_to_save_plots_to,"Neuron",file_string))
    else
        imwrite(original_image,fullfile(dir_to_save_plots_to,"MUA",file_string))
    end

end

end