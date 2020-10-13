#!/bin/bash
verify_checksums=false

mkdir -p ~/outputs

if $verify_checksums; then
    # work out if all files have downloaded properly by verifying checksums
    cd ../samples
    all_good=true

    for f in *.fq.gz
    do
        checksum="$(shasum -a512 $f)"

        if ! grep -q "$checksum" checksums.txt ; then
            echo "The checksum for $f could not be matched - please either delete the sample or redownload it"
            all_good=false
        fi
    done

    if ! $all_good; then
        echo "Please review damaged sample files and restart the script"
        exit 1
    fi
fi

cd ~/
home_path="$PWD"
shared_path="/home/groups/lu_kpmi/"
sample_path="/home/groups/lu_kpmi/affixed_samples/"

cd ~/rtu-stag/hpc/subscripts/

for f in ${sample_path}*_1.fq.gz; do # don't want to trigger twice - limiting myself to the first file of the pair
    sample=$(echo $f | grep -o '[0-9]\+_[0-9]\+\.fq\.gz' | grep -o '[0-9]\+_' | grep -o '[0-9]\+')
    qsub sub.run.sh -F "$sample $home_path $shared_path $sample_path" # create jobs for all of the samples
done
