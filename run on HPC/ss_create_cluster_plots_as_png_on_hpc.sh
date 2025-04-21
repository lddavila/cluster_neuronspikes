#!/bin/bash 
#SBATCH -n 40 
#SBATCH -p general 
#SBATCH -o output_1.txt 
#SBATCH -e error_2.txt 
module load matlab/R2024b
matlab -batch "create_cluster_plots_as_png_on_hpc();exit;"
