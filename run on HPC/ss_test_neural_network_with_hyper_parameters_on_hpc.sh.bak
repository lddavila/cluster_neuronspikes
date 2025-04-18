#!/bin/bash 
#SBATCH -n 40 
#SBATCH -p general 
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -batch "build_tables_of_to_id_overlap_on_hpc();exit;"
