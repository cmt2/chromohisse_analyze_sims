#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chromohisse_2
#SBATCH --output=slurm-%x.out
#SBATCH --mail-user=mikeryanmay@gmail.edu
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --time=168:00:00

# load dependencies
module load gcc
module load cmake
module load boost

# change to the repo directory
cd /home/$USER/chromohisse_analyze_sims/

# runs
# (assume 4 core each)
/home/$USER/revbayes/projects/cmake/rb chromohisse_jobs_low_mu/job_6.Rev &
/home/$USER/revbayes/projects/cmake/rb chromohisse_jobs_low_mu/job_7.Rev &
/home/$USER/revbayes/projects/cmake/rb chromohisse_jobs_low_mu/job_8.Rev &
/home/$USER/revbayes/projects/cmake/rb chromohisse_jobs_low_mu/job_9.Rev &
/home/$USER/revbayes/projects/cmake/rb chromohisse_jobs_low_mu/job_10.Rev;

wait;
