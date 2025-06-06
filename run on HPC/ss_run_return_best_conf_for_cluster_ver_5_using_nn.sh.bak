#!/bin/bash 
#SBATCH -n 1
#SBATCH -p large 
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -batch "train_twin_nn_using_more_accuracy_cats();exit;"