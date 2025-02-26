#!/bin/bash 
#SBATCH -n 40
#SBATCH -p general 
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -batch "run_overlap_checks_for_blind_pass_using_cont_table('/home/lddavila/data_to_be_copied_to_local_server','/home/lddavila/spike_gen_data/0_100Neuron300SecondRecordingWithLevel3Noise/initial_pass_results min z_score','/home/lddavila/spike_gen_data/0_100Neuron300SecondRecordingWithLevel3Noise/initial_pass min z_score','/home/lddavila/ground_truth/Recording By Channel Ground Truth','/home/lddavila/timestamps/Recordings By Channel Timestamps','/home/lddavila/data_to_be_copied_to_local_server/contamination table 2 with time delta 0.0004/contamination_table.mat'); exit;"