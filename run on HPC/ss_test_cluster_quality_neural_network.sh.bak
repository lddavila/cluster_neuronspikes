#!/bin/bash 
#SBATCH -n 40 
#SBATCH -p general 
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -batch "test_cluster_quality_neural_network();exit;"