#!/bin/bash 
#SBATCH -n 1
#SBATCH -p medium
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -batch "run_update_cluster_table();exit;"