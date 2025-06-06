#!/bin/bash 
#SBATCH -n 40
#SBATCH -p large 
#SBATCH -o output_2.txt 
#SBATCH -e error_2.txt 
module load matlab/R2024b
matlab -batch "train_accuracy_classification_based_on_waveform();exit;"