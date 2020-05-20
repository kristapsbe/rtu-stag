#!/bin/bash
mkdir -p ~/outputs

cd ~/rtu-stag/hpc/subscripts

for f in ~/rtu-stag/samples/*.gz; do
    qsub sub.run.sh $f # create jobs for all of the samples
    