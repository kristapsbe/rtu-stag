#!/bin/bash
# the goal of this script is to get the environment as a whole set up 
# 
# https://github.com/conda/conda/issues/7980
source ~/anaconda3/etc/profile.d/conda.sh

# clear out the old installation folders (mostly to deal with the kraken2 install)
cd ../..
rm -rf stag-mwc
rm -rf kraken2

# first thing's first clone stag if it's not here already
git clone https://github.com/lucren/stag-mwc.git stag-mwc

# go into the folder and pull changes (mostly to deal with a case where the repohas already been pulled)
cd stag-mwc
git checkout hpc_mod # the modded branch that we're working with
git pull

# create a conda env 
# pip yes to overwrite the env
echo "y" | conda create --name stag-mwc python=3
conda activate stag-mwc

# and add needed channels
conda config --add channels conda-forge
conda config --add channels bioconda

# at this point we've cloned stag and need to run their setup process - conda is expected to be installed already
# pipe yes into the install to silence prompts
echo "y" | conda install -c bioconda -c conda-forge snakemake==5.5.4

# we need to download and compile kraken2 to avoid using the segfaulting conda version
#
# remeber that build-essential have to be installed (at least in the wsl ubuntu build)
# apt-get install build-essential
git clone https://github.com/DerrickWood/kraken2.git ../kraken2
cd ../kraken2
./install_kraken2.sh ../kraken2_installed
# get rid of the repo folder and move the installation dir to a nicer looking folder name
cd ..
rm -rf kraken2
mv kraken2_installed kraken2

# setting up the kraken2 taxon database
#
# purge any databases that we may have set up for this already
rm -rf taxon_databases

# start by setting up the kraken2 database
mkdir taxon_databases
cd taxon_databases
../kraken2/kraken2-build --use-ftp --download-taxonomy --db kraken_taxon --threads 12
../kraken2/kraken2-build --use-ftp --no-masking --download-library archaea --db kraken_taxon --threads 12
../kraken2/kraken2-build --use-ftp --no-masking --download-library bacteria --db kraken_taxon --threads 12
../kraken2/kraken2-build --use-ftp --no-masking --download-library fungi --db kraken_taxon --threads 12
../kraken2/kraken2-build --build --db kraken_taxon --threads 12
# and the refence database that we'll be using to filter the reads (note that it's the GRCh38 reference)
../kraken2/kraken2-build --use-ftp --download-taxonomy --db human_reference --threads 12
../kraken2/kraken2-build --use-ftp --no-masking --download-library human --db human_reference --threads 12
../kraken2/kraken2-build --build --db human_reference --threads 12