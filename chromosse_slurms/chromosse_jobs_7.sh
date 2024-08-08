#!/bin/bash
#SBATCH --partition=med2
#SBATCH --account=brannalagrp
#SBATCH --job-name=chromosse_7
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
/home/$USER/revbayes/projects/cmake/rb chromosse_jobs/job_31.Rev &
/home/$USER/revbayes/projects/cmake/rb chromosse_jobs/job_32.Rev &
/home/$USER/revbayes/projects/cmake/rb chromosse_jobs/job_33.Rev &
/home/$USER/revbayes/projects/cmake/rb chromosse_jobs/job_34.Rev &
/home/$USER/revbayes/projects/cmake/rb chromosse_jobs/job_35.Rev;

wait;
