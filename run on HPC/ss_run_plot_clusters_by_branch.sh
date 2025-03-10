#!/bin/bash 
#SBATCH -n 40
#SBATCH -p general 
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -batch "plot_all_clusters_by_branch('/home/lddavila/data_from_local_server/table_of_only_neurons_before_choosing_best.mat'); exit;"