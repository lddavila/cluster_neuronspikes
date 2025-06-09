#!/bin/bash 
#SBATCH -n 40 
#SBATCH -p medium 
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -batch "train_nn_that_takes_probs_from_mean_wave_and_grades_acc_cat();exit;"
