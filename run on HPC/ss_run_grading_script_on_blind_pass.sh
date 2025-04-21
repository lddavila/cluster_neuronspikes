#!/bin/bash 
#SBATCH -n 40 
#SBATCH -p general 
#SBATCH -o output_2.txt 
#SBATCH -e error_2.txt 
module load matlab/R2024b
matlab -batch "run_grading_script_on_blind_pass('/home/lddavila/spike_gen_data/0_100Neuron300SecondRecordingWithLevel3Noise','/home/lddavila/data_to_be_copied_to_local_server','0_100Neuron300SecondRecordingWithLevel3Noise');exit;"
