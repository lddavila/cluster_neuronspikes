function config = choose_best_config()
%choose_best_config will return a config file that will be used by
%return_best_config_of_cluster.m 

config = struct();

% Prints extra output
config.DEBUG = false;


config.SAVE_DIRECTORY = 'D:\cluster_neuronspikes\Data'; %where any important data will be saved to
config.MAX_EUC_DIST = 50; %serves as an upper bound of euclidean distance between cluster template wave forms to check when merging clusters 
config.UPDATE_CLASSIFICATION = false; %when true every grade will be updated with the latest classification using classify_clusters_based_on_grades_ver_3
config.OVERLAP = 80; %the minimum percentage that clusters must overlap to be counted as the same cluster
config.ONLY_OVERLAP_WITH_NEURONS =true; %when this is used return_best_config_of_cluster will only allow overlaps if the overlapping cluster is also a neuron 
config.GENERIC_GRADES_DIR = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass min z_score"; % a generic file path which can be modified to access grades of various cluster configurations
config.GENRIC_DIR_WITH_OUTPUTS = "D:\spike_gen_data\Recordings By Channel Precomputed\0_100Neuron300SecondRecordingWithLevel3Noise\initial_pass_results min z_score"; %a generic file path which can be modified to access the results of clustering
config.ONLY_NEURONS = true; %when set to true updated_table_of_other_appearences will only include neurons, when set to false it will also include clusters listed as MUA


end
