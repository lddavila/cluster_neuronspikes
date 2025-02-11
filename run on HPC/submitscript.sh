#!/bin/bash 
#SBATCH -n 6 
#SBATCH -p general 
#SBATCH -o output.txt 
#SBATCH -e error.txt 
source /opt/intel/oneapi/setvars.sh -ofi_internal=1 --force
module load matlab/R2024b
matlab run_overlap_checks_on_hpc -np 6