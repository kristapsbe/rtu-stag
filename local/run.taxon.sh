#!/bin/bash
#
# https://github.com/conda/conda/issues/7980
source ~/anaconda3/etc/profile.d/conda.sh
conda activate stag-mwc
# run through all of our built up taxon jobs
cd ../..
for f in process/process_taxon_*; do
    cd "$f/stag-mwc"
    snakemake --use-conda --cores 12
    cd ../../..
done