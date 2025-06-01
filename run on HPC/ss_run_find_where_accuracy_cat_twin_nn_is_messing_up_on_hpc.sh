#!/bin/bash 
#SBATCH -n 10
#SBATCH -p general 
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -nodisplay -r "run_find_where_accuracy_cat_twin_nn_is_messing_up_on_hpc();exit;"