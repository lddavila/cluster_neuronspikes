#!/bin/bash 
#SBATCH -n 6 
#SBATCH -p general 
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -nodisplay -r "run_overlap_checks_on_hpc;exit;"