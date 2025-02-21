#!/bin/bash 
#SBATCH -n 40
#SBATCH -p general 
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -batch "generate_contamination_table('D:\spike_gen_data\Recording By Channel Ground Truth\0_100Neuron300SecondRecordingWithLevel3Noise.h5.mat',0.0004,'/home/lddavila/spike_gen_data/0_100Neuron300SecondRecordingWithLevel3Noise','/home/lddavila/timestamps/Recordings By Channel Timestamps/0_100Neuron300SecondRecordingWithLevel3Noise','/home/lddavila/data_to_be_copied_to_local_server'); exit;"
