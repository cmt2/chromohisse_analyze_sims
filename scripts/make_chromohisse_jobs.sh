#!/bin/bash

# define template file
template_fn="scripts/chromohisse_template.Rev"

# make job files
for i in {1..100}; do
  template_fn > "chromohisse_jobs/job_{i}.Rev"
  # echo $i
done