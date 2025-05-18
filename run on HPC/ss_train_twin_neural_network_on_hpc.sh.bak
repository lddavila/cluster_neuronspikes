#!/bin/bash 
#SBATCH -n 40 
#SBATCH -p general 
#SBATCH -o output_2.txt 
#SBATCH -e error_2.txt 
module load matlab/R2024b
matlab -batch "run_vacuum_spikes_test_on_cluster();exit;"