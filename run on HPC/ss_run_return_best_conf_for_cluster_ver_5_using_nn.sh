#!/bin/bash 
#SBATCH -n 1
#SBATCH -p large 
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -batch "run_return_best_conf_for_cluster_ver_5_using_nn();exit;"