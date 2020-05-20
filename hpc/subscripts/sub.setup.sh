#!/bin/bash
#PBS -N setup_stag
#PBS -l nodes=1:ppn=8,pmem=6g
#PBS -l walltime=16:00:00
#PBS -q long
#PBS -j oe

# how many threads do we have?
threads=8

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


# set up the kraken2 database that we'll be matching our taxons agains
mkdir -p databases/taxon_databases
cd databases/taxon_databases
../../kraken2/kraken2-build --use-ftp --download-taxonomy --db kraken_taxon --threads $threads
../../kraken2/kraken2-build --use-ftp --no-masking --download-library archaea --db kraken_taxon --threads $threads
../../kraken2/kraken2-build --use-ftp --no-masking --download-library bacteria --db kraken_taxon --threads $threads
../../kraken2/kraken2-build --use-ftp --no-masking --download-library fungi --db kraken_taxon --threads $threads
../../kraken2/kraken2-build --build --db kraken_taxon --threads $threads
rm -rf kraken_taxon/library # get rid of the 4 gig library source files
# set up the refence database that we'll be using to filter the reads (note that it's the GRCh38 reference)
mkdir human_reference
mv kraken_taxon/taxonomy human_reference/taxonomy # this takes up around 30 gigs - if we can avoid downloading it again we should
../../kraken2/kraken2-build --use-ftp --no-masking --download-library human --db human_reference --threads $threads
../../kraken2/kraken2-build --build --db human_reference --threads $threads
rm -rf human_reference/library # get rid of the 76 gig taxonomy library files
rm -rf human_reference/taxonomy # get rid of the 30 gig taxonomy source files

# 09/05/2020 => metaphlan2 seems to be broken due to the database repo being set to private
echo "y" | conda install groot==0.8.4 bbmap==38.68 metaphlan==3.0

# move back to the base dir
cd ../..
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
snakemake create_groot_index --cores $threads
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
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
# pipe yes into the install to silence prompts
echo "y" | conda install -c bioconda -c conda-forge humann2==2.8.1 
# download_humann2_databases
cd ../../.. # path out of the stag copy and move back to the base dir
humann2_databases --download chocophlan full databases/func_databases/humann2
humann2_databases --download uniref uniref90_diamond databases/func_databases/humann2