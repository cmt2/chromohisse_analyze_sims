#!/bin/bash

# define template file
template_fn="scripts/chromosse_template.Rev"

# make job files
for i in {1..100}; do
  echo $i
  sed "s/PLACEHOLDER/$i/g" $template_fn > "chromosse_jobs/job_$i.Rev"
done