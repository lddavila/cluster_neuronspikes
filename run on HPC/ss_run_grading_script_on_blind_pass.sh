#!/bin/bash 
#SBATCH -n 39 
#SBATCH -p large 
#SBATCH -o output_2.txt 
#SBATCH -e error_2.txt 
module load matlab/R2024b
matlab -batch "run_grading_script_on_blind_pass('/scratch/lddavila/data_from_local_machine/0_100_neuron_level_3_nosie_blind_pass','0_100Neuron300SecondRecordingWithLevel3Noise');exit;"
