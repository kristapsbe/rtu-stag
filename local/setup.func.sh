#!/bin/bash
# the goal of this script is to set up the databases and tools
# that we'll be using for functional classification
# 
# https://github.com/conda/conda/issues/7980
source ~/anaconda3/etc/profile.d/conda.sh
conda activate stag-mwc
echo "y" | conda install groot==0.8.4

# move back to the base dir
cd ../..
rm -rf process/process_func_db # clear out the old database stag setup in case we've changed something

# set up the new stag instance that we'll be using
mkdir -p process/process_func_db
cp -r stag-mwc process/process_func_db/stag-mwc
cp rtu-stag/configs/config.db.yaml process/process_func_db/stag-mwc/config.yaml # changing the name to the default simplifies running

# making fake input files to make stag happy (it throws errors without a sample to work with)
cd process/process_func_db/stag-mwc
mkdir input
touch input/1_1.fq.gz
touch input/1_2.fq.gz
# build up the databases using stag
snakemake create_groot_index
