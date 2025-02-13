#!/bin/bash 
#SBATCH -n 20 
#SBATCH -p general 
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab "run_overlap_checks_for_blind_pass('/home/lddavila/spike_gen_data','/home/lddavila/spike_gen_data/0_100Neuron300SecondRecordingWithLevel3Noise/initial_pass_results min z_score','/home/lddavila/spike_gen_data/0_100Neuron300SecondRecordingWithLevel3Noise/initial_pass min z_score');exit;"
