#!/bin/bash 
#SBATCH -n 37 
#SBATCH -p medium
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -batch "train_agent_with_various_mp_in_more_verbose_single_dim_space(); exit;"