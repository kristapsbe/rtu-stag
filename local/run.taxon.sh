#!/bin/bash
#
# https://github.com/conda/conda/issues/7980
source ~/anaconda3/etc/profile.d/conda.sh
conda activate stag-mwc
# run through all of our built up taxon jobs
cd ../..
for f in process/process_taxon_*; do
    # get the sample number
    sample=$(echo $f | grep -o '[0-9]\+')
    cd "$f/stag-mwc"
    snakemake --use-conda --cores 12
    cd ../../..
    # cleanup after finishing
    rm -rf "$f/stag-mwc/output_dir/fastp/"
    rm -rf "$f/stag-mwc/output_dir/host_removal/"
    rm -rf "$f/stag-mwc/output_dir/logs/"
    rm "$f/stag-mwc/output_dir/kraken2/1.kraken"
    # save the output folder and free up the space taken
    datestamp=$(date -d "today" +"%Y%m%d%H%M")
    mv "$f/stag-mwc/output_dir" "outputs/output_dir_${sample}_taxon_${datestamp}"
    rm -rf $f
done