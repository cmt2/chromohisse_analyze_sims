#!/bin/bash

# synchronize all
# rsync -azP --exclude=".*/" mrmay@farm.cse.ucdavis.edu:chromohisse_analyze_sims/output/ ~/repos/chromohisse_analyze_sims/output/
rsync -azP --exclude=".*/" mrmay@farm.cse.ucdavis.edu:chromohisse_analyze_sims/output_low_mu/ ~/repos/chromohisse_analyze_sims/output_low_mu/