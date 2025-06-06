#!/bin/bash 
#SBATCH -n 40
#SBATCH -p large 
#SBATCH -o output_1.txt 
#SBATCH -e error_1.txt 
module load matlab/R2024b
matlab -batch "train_twin_nn_using_more_accuracy_cats();exit;"