#!/bin/bash 
#SBATCH -n 40 
#SBATCH -p general 
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -batch "generate_all_cluster_plots_for_bp('/home/lddavila/data_to_be_copied_to_local_server','Best Clusters Min Overlap 10 Percent Plots','/home/lddavila/spike_gen_data/0_100Neuron300SecondRecordingWithLevel3Noise/initial_pass_results min z_score','/home/lddavila/data_to_be_copied_to_local_server/0_100Neuron300SecondRecordingWithLevel3Noise/initial_pass min z_score');exit;"