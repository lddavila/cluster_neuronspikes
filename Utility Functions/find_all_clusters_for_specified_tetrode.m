function [grades,output,aligned,reg_timestamps,idx] = find_all_clusters_for_specified_tetrode(precomputed_dir,specified_tetrode,current_z_score)
dir_with_grades = precomputed_dir+"\initial_pass min z_score "+string(current_z_score)+" grades";
dir_with_outputs = precomputed_dir+"\initial_pass_results min z_score"+string(current_z_score);
[grades,output,aligned,reg_timestamps,idx] =import_data(dir_with_grades,dir_with_outputs,specified_tetrode);

end