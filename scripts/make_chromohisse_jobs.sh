#!/bin/bash

# define template file
template_fn="scripts/chromohisse_template.Rev"

# make job files
for i in {1..100}; do
  echo $i
  sed "s/PLACEHOLDER/$i/g" $template_fn > "chromohisse_jobs/job_$i.Rev"
done