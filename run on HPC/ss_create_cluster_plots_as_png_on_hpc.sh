#!/bin/bash 
#SBATCH -n 40 
#SBATCH -p general 
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -batch "create_cluster_plots_as_png_on_hpc();exit;"
