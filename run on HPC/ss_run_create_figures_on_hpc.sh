#!/bin/bash 
#SBATCH -n 40 
#SBATCH -p general 
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -batch "create_cluster_plots_with_grades('/home/lddavila/data_to_be_copied_to_local_server','/home/lddavila/data_to_be_copied_to_local_server/Blind Pass Overlap Min Overlap Threshold 10/table of best appearences of cluster.mat','Best Clusters Min Overlap 10 Percent Plots','/home/lddavila/spike_gen_data/0_100Neuron300SecondRecordingWithLevel3Noise/initial_pass_results min z_score','/home/lddavila/spike_gen_data/0_100Neuron300SecondRecordingWithLevel3Noise/initial_pass min z_score');exit;"