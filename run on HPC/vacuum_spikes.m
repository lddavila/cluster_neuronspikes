function [] = vacuum_spikes(table_of_neurons_to_vacuum,config)
if config.ON_HPC
    gen_grades_dir = config.GENERIC_GRADES_DIR_ON_HPC;
    gen_output_dir = config.GENRIC_DIR_WITH_OUTPUTS_ON_HPC;
else
    gen_grades_dir = config.GENERIC_GRADES_DIR;
    gen_output_dir = config.GENRIC_DIR_WITH_OUTPUTS;
end
for i=1:size(table_of_neurons_to_vacuum,1)
    current_z_score = table_of_neurons_to_vacuum{i,"Z Score"};
    current_tetrode = table_of_neurons_to_vacuum{i,"Tetrode"};
    current_cluster = table_of_neurons_to_vacuum{i,"Cluster"};
    current_grades = table_of_neurons_to_vacuum{i,"grades"}{1};
    current_expand_or_dont = current_grades{61};



    dir_with_grades = gen_grades_dir + " "+string(current_z_score)+ " grades";
    dir_with_outputs = gen_output_dir +string(current_z_score);

    [~,~,aligned,reg_timestamps_of_the_spikes,idx,failed_to_load] = import_data_hpc(dir_with_grades,dir_with_outputs,current_tetrode,0);

    current_cluster_idxs = idx{current_cluster};

    first_dim = current_grades{42};
    sec_dim = current_grades{43};

    all_peaks = get_peaks(aligned, true);

   cluster_peaks = all_peaks([first_dim,sec_dim],current_cluster_idxs);


    %calculate cluster center
    cluster_center = mean(cluster_peaks,2);
    cluster_std = std(cluster_peaks,0,2);

    

end
end