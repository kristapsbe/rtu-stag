#!/bin/bash
mkdir -p "~/outputs"

cd "~/"
home_path="$PWD"

cd "~/rtu-stag/hpc/subscripts"

for f in "~/rtu-stag/samples/*_1.fq.gz"; do # don't want to trigger twice - limiting myself to the first file of the pair
    sample=$(echo $f | grep -o '[0-9]\+_[0-9]\+\.fq\.gz' | grep -o '[0-9]\+_' | grep -o '[0-9]\+')
    qsub sub.run.sh -F "$sample $home_path" # create jobs for all of the samples
done
