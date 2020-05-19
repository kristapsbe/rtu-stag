#!/bin/bash
#PBS -N stag
#PBS -l nodes=1:ppn=2,pmem=6g
#PBS -l walltime=16:00:00
#PBS -q long
#PBS -j oe
cd rtu-stag/local # move back into our project
./setup.taxon.sh # run the same setup script that the local instance would use