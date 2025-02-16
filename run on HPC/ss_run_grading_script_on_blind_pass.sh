#!/bin/bash 
#SBATCH -n 40 
#SBATCH -p general 
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -batch 'run_grading_script_on_blind_pass("/home/lddavila/spike_gen_data/0_100Neuron300SecondRecordingWithLevel3Noise","","","0_100Neuron300SecondRecordingWithLevel3Noise");exit;'
