#!/bin/bash 
#SBATCH -n 40 
#SBATCH -p general 
#SBATCH -o output_2.txt 
#SBATCH -e error_2.txt 
module load matlab/R2024b
matlab -batch "train_twin_neural_network_on_hpc();exit;"