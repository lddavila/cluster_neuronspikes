#!/bin/bash 
#SBATCH -n 37 
#SBATCH -p medium
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -batch "train_nn_to_predict_over_1_percent_overlap(); exit;"