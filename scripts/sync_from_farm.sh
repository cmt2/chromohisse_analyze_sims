#!/bin/bash

# synchronize all
rsync -azP --exclude=".*/" mrmay@farm.cse.ucdavis.edu:chromohisse_analyze_sims/output/ ~/repos/chromohisse_analyze_sims/output/