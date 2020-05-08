#!/bin/bash
# the goal of this script is to set up the databases and tools
# that we'll be using for functional classification
# 
# https://github.com/conda/conda/issues/7980
source ~/anaconda3/etc/profile.d/conda.sh
conda activate stag-mwc
# 09/05/2020 => metaphlan2 seems to be broken due to the database repo being set to private
echo "y" | conda install groot==0.8.4 bbmap==38.68 metaphlan==3.0

# move back to the base dir
cd ../..
rm -rf process/process_func_db # clear out the old database stag setup in case we've changed something
rm -rf databases/func_databases # get rid of the functional classification databases before recreating them

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
snakemake create_groot_index --cores 12
# set up metaphlan
metaphlan --install
# humann2 is being needlesly annoying due to dependency conflicts
# will just rip the commands out of stag and run it as is
# snakemake download_humann2_databases --cores 12
#
# setup a conda env running python 2
# pipe yes to overwrite the env
echo "y" | conda create --name humann2 python=2
conda activate humann2
# and add needed channels
conda config --add channels conda-forge
conda config --add channels bioconda
# pipe yes into the install to silence prompts
echo "y" | conda install -c bioconda -c conda-forge humann2==2.8.1 
# download_humann2_databases
cd ../../.. # path out of the stag copy and move back to the base dir
humann2_databases --download chocophlan full databases/func_databases/humann2
humann2_databases --download uniref uniref90_diamond databases/func_databases/humann2