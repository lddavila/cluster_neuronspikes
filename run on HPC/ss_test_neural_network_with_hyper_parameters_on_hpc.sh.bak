#!/bin/bash 
#SBATCH -n 40 
#SBATCH -p general 
#SBATCH -o output_1.txt 
#SBATCH -e error_1.txt 
module load matlab/R2024b
matlab -batch "test_neural_network_with_hyper_parameters_on_hpc();exit;"
