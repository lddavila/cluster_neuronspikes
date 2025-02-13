#!/bin/bash 
#SBATCH -n 20 
#SBATCH -p general 
#SBATCH -o output.txt 
#SBATCH -e error.txt 
module load matlab/R2024b
matlab -nodisplay -r "create_figures_on_hpc('/home/lddavila/spike_gen_data','/home/lddavila/cluster_neuronspikes/run on HPC/Reclustered Pass Min Overlap Percentage 5','/home/lddavila/spike_gen_data/TEST refinement_pass_results min amp 0 Top 4 Channels','/home/lddavila/spike_gen_data/TEST refinement_pass_results min amp 0 Top 4 Channels grades');exit;"