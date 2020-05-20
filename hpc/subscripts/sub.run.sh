#!/bin/bash
#PBS -N run_sample
#PBS -l nodes=1:ppn=8,pmem=6g
#PBS -l walltime=24:00:00
#PBS -q long
#PBS -j oe

# how many threads do we have?
threads=8
module activate conda
conda activate stag-mwc

trimmed=$(echo $0 | grep -o '[0-9]\+_[0-9]\+\.fq\.gz')
sample=$(echo $0 | grep -o '[0-9]\+_[0-9]\+\.fq\.gz' | grep -o '[0-9]\+_' | grep -o '[0-9]\+')
f="/scratch/kristaps_$sample"

# we need to move to the scratch dir to keep us from nuking their network infrastructure
cd /scratch
rm -rf $f # clear out the folder in case this sample has already been on this node
mkdir $f
# copy the database folder over
cp -r ~/databases $f
cp -r ~/stag-mwc $f
cp ~/rtu-stag/configs/config.hpc.yaml "$f/stag-mwc/config.yaml" # changing the name to the default simplifies running
mkdir "$f/stag-mwc/input"
cp $0 "$f/stag-mwc/input/$trimmed"
cp -r ~/kraken2 $f

cd "$f/stag-mwc"
snakemake --use-conda --cores $threads
cd ../.. # move back into the base dir
# run the humann2 stuff outside of stag - just ripping the whole thing to deal with dep conflicts between humann2 and snakemake
humann2_dir="$f/stag-mwc/output_dir/humann2/"
metaphlan_dir="$f/stag-mwc/output_dir/metaphlan/"
mkdir -p $humann2_dir
mkdir -p $metaphlan_dir
# at this point we know that host_removal samples exist due to them being made for groot
echo "#SampleID\t$sample" > mpa2_table-v2.7.7.txt
# metaphlan had to run before humann2
metaphlan --input_type fastq --nproc $threads --sample_id ${sample} --bowtie2out "${metaphlan_dir}${sample}.bowtie2.bz2" "$f/stag-mwc/output_dir/host_removal/${sample}_1.fq.gz","$f/stag-mwc/output_dir/host_removal/${sample}_2.fq.gz" -o "${metaphlan_dir}${sample}.metaphlan.txt"   
# looks like metaphlan 3 has broken downloads as well
#
# Convert MPA 3 output to something like MPA2 v2.7.7 output 
# so it can be used with HUMAnN2, avoids StaG issue #138.
# TODO: Remove this once HUMANn2 v2.9 is out.
sed '/#/d' "${metaphlan_dir}${sample}.metaphlan.txt" | cut -f1,3 >> "${humann2_dir}mpa2_table-v2.7.7.txt"
cat "$f/stag-mwc/output_dir/host_removal/${sample}_1.fq.gz" "$f/stag-mwc/output_dir/host_removal/${sample}_2.fq.gz" > "${humann2_dir}concat_input_reads.fq.gz"
# humann2
conda activate humann2
humann2 --input "${humann2_dir}concat_input_reads.fq.gz" --output $humann2_dir --nucleotide-database "databases/func_databases/humann2/chocophlan" --protein-database "databases/func_databases/humann2/uniref" --output-basename $sample --threads $threads --taxonomic-profile "${humann2_dir}mpa2_table-v2.7.7.txt" 
# normalize_humann2_tables
humann2_renorm_table --input "${humann2_dir}${sample}_genefamilies.tsv" --output "${humann2_dir}${sample}_genefamilies_relab.tsv" --units relab --mode community 
humann2_renorm_table --input "${humann2_dir}${sample}_pathabundance.tsv" --output "${humann2_dir}${sample}_pathabundance_relab.tsv" --units relab --mode community
# join_humann2_tables
humann2_join_tables --input $humann2_dir --output "${humann2_dir}all_samples.humann2_genefamilies.tsv" --file_name genefamilies_relab
humann2_join_tables --input $humann2_dir --output "${humann2_dir}all_samples.humann2_pathabundance.tsv" --file_name pathcoverage
humann2_join_tables --input $humann2_dir --output "${humann2_dir}all_samples.humann2_pathcoverage.tsv" --file_name pathabundance_relab
# cleanup after finishing    
rm -rf "$f/stag-mwc/output_dir/fastp/"
rm -rf "$f/stag-mwc/output_dir/host_removal/"
rm -rf "$f/stag-mwc/output_dir/logs/"
rm "$f/stag-mwc/output_dir/humann2/concat_input_reads.fq.gz"
rm -rf "$f/stag-mwc/output_dir/humann2/1_humann2_temp"
# save the output folder and free up the space taken
datestamp=$(date -d "today" +"%Y%m%d%H%M")
mv "$f/stag-mwc/output_dir" "~/outputs/output_dir_${sample}_${datestamp}"
rm -rf $f

cd /scratch
rm -rf $f # clean up after myself