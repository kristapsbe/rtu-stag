#!/bin/bash
# we need to keep the samples from running in parallel - building up dummy environments for
# the individual samples
#
# move back to the base folder
cd ../..
rm -rf process/process_taxon_* # get rid of all of the old files

# work through all of the samples
for f in rtu-stag/samples/*.gz; do
    echo $f
    # get the trimmed down file name
    trimmed=$(echo $f | grep -o '[0-9]\+_[0-9]\+\.fq\.gz')
    # get the sample number
    sample=$(echo $f | grep -o '[0-9]\+_[0-9]\+\.fq\.gz' | grep -o '[0-9]\+_' | grep -o '[0-9]\+')

    # create the folder that his samples stag environment will live in
    # only do stuff if we've not set up this sample already
    if [ ! -d "process/process_taxon_$sample" ]; then 
        mkdir -p "process/process_taxon_$sample"
        # move stag into this samples folder
        cp -r stag-mwc "process/process_taxon_$sample/stag-mwc"
        cp rtu-stag/configs/config.taxon.yaml "process/process_taxon_$sample/stag-mwc/config.yaml" # changing the name to the default simplifies running
        mkdir "process/process_taxon_$sample/stag-mwc/input"
    fi
    # move the sample to the stag folder
    cp $f "process/process_taxon_$sample/stag-mwc/input/$trimmed"
done

# make directory for outputs in case it doesn't exist
mkdir outputs