#!/bin/bash
#PBS -N stag
#PBS -l nodes=1:ppn=2,pmem=6g
#PBS -l walltime=4:00:00
#PBS -q long
#PBS -j oe

# clear out the old installation folders
cd ../..
rm -rf stag-mwc

# first thing's first clone stag if it's not here already
git clone https://github.com/lucren/stag-mwc.git stag-mwc

# go into the folder and pull changes (mostly to deal with a case where the repohas already been pulled)
cd stag-mwc
git checkout hpc_mod # the modded branch that we're working with
git pull

# create a conda env 
# pipe yes to overwrite the env
echo "y" | conda create --name stag-mwc python=3
conda activate stag-mwc

# and add needed channels
#
# order matters - https://forum.biobakery.org/t/metaphlan3-installation-fails/350/2
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

# at this point we've cloned stag and need to run their setup process - conda is expected to be installed already
# pipe yes into the install to silence prompts
echo "y" | conda install -c bioconda -c conda-forge snakemake==5.5.4