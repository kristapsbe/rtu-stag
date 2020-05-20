#!/bin/bash
#
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
module load conda
conda init bash
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

# clear out the old installation folders
cd ..
rm -rf kraken2

# we need to download and compile kraken2 to avoid using the segfaulting conda version
#
# remeber that build-essential have to be installed (at least in the wsl ubuntu build)
# apt-get install build-essential
git clone https://github.com/DerrickWood/kraken2.git kraken2
cd kraken2
./install_kraken2.sh ../kraken2_installed
# get rid of the repo folder and move the installation dir to a nicer looking folder name
cd ..
rm -rf kraken2
mv kraken2_installed kraken2

# setting up the kraken2 taxon database
#
# purge any databases that we may have set up for this already
rm -rf databases/taxon_databases
rm -rf process/process_func_db # clear out the old database stag setup in case we've changed something
rm -rf databases/func_databases # get rid of the functional classification databases before recreating them

# remember that you're in the home dir (and we're expecting the repo to be cloned in the home dir)
# and there's a bit of an odd issue in that I can only use git in the login node for some reason
cd rtu-stag/hpc/subscripts
qsub sub.setup.sh