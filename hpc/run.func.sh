#!/bin/bash
#PBS -N stag
#PBS -l nodes=1:ppn=28,pmem=6g
#PBS -l walltime=80:00:00
#PBS -q long
#PBS -j oe

cd stag-mwc
module load bio/samtools-1.9
module load conda
conda init bash
source ~/.bashrc
conda env create -f /home/kristaps01/stag-mwc/envs/stag-mwc.yaml --force
conda env create -f /home/kristaps01/stag-mwc/envs/humann2.yaml --force
conda env create -f /home/kristaps01/stag-mwc/envs/metaphlan2.yaml --force
conda clean --yes --all
conda activate stag-mwc
snakemake --use-conda --cores 28
conda install bbmap
conda install groot
mkdir -p output_dir/logs/groot/4/
reformat.sh in1=output_dir/host_removal/4_1.fq.gz in2=output_dir/host_removal/4_2.fq.gz out1=output_dir/groot/4/4_1.size_window.fq.gz out2=output_dir/groot/4/4_2.size_window.fq.gz minlength=100 maxlength=150 tossbrokenreads 2> output_dir/logs/groot/4.reformat.log
groot align --fastq output_dir/groot/4/4_1.size_window.fq.gz,output_dir/groot/4/4_2.size_window.fq.gz --graphDir output_dir/groot/4/groot-graph --indexDir /home/kristaps01/databases/groot/arg-annot_index --processors 8 --logFile output_dir/logs/groot/4.groot_align.log > output_dir/groot/4/4.groot_aligned.bam
groot report --bamFile output_dir/groot/4/4.groot_aligned.bam --covCutoff 0.97 --plotCov --processors 8 --logFile output_dir/logs/groot/4.groot_report.log > output_dir/groot/4/4.groot_report.txt
mv groot-plots output_dir/groot/4/groot-plots