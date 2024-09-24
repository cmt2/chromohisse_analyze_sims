#!/bin/bash

# define template file
template_fn="scripts/chromosse_template_low_mu.Rev"

# make job files
for i in {1..100}; do
  echo $i
  sed "s/PLACEHOLDER/$i/g" $template_fn > "chromosse_jobs_low_mu/job_$i.Rev"
done