#!/bin/bash
#PBS -N db_download
#PBS -l procs=2,pmem=6g
#PBS -l walltime=80:00:00
#PBS -q long
#PBS -j oe

cd stag-mwc
module load conda
conda init bash
source ~/.bashrc
conda activate stag-mwc
conda config --add channels conda-forge
conda config --add channels bioconda
conda install -c bioconda -c conda-forge snakemake
conda install humann2==2.8.1
conda install groot
snakemake create_groot_index