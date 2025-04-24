#!/bin/bash 
#SBATCH -n 40 
#SBATCH -p general 
#SBATCH -o output_1.txt 
#SBATCH -e error_2.txt 
module load matlab/R2024b
matlab -batch "test_image_class_neural_network_hyper_parameters();exit;"
