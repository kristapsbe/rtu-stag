#!/bin/bash
# the goal of this script is to set up the databases and tools
# that we'll be using for functional classification
# 
# https://github.com/conda/conda/issues/7980
source ~/anaconda3/etc/profile.d/conda.sh

# move back to the base dir
cd ../..
rm -rf process/process_func_db # clear out the old database stag setup in case we've changed something

# set up the new stag instance that we'll be using
mkdir -p process/process_func_db
cp -r stag-mwc process/process_func_db/stag-mwc
cp rtu-stag/configs/config.func.yaml process/process_func_db/stag-mwc/config.yaml # changing the name to the default simplifies running
# mkdir process/process_func_db/stag-mwc/input # I hope I don't need this