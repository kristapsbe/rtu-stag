

# https://github.com/conda/conda/issues/7980
source ~/anaconda3/etc/profile.d/conda.sh

# first thing's first clone stag if it's not here already
git clone https://github.com/lucren/stag-mwc.git ../stag-mwc

# go into the folder and pull changes (mostly to deal with a case where the repohas already been pulled)
cd ../stag-mwc
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
