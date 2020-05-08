#!/bin/bash
#
# https://github.com/conda/conda/issues/7980
source ~/anaconda3/etc/profile.d/conda.sh
# run through all of our built up taxon jobs
cd ../..
for f in process/process_func_*; do
    # get the sample number
    sample=$(echo $f | grep -o '[0-9]\+')
    cd "$f/stag-mwc"
    conda activate stag-mwc
    snakemake --use-conda --cores 12
    cd ../../.. # move back into the base dir
    # run the humann2 stuff outside of stag - just ripping the whole thing to deal with dep conflicts between humann2 and snakemake
    humann2_dir="$f/stag-mwc/output_dir/humann2/"
    mkdir -p $humann2_dir
    # at this point we know that host_removal samples exist due to them being made for groot
    echo "#SampleID\t$sample" > mpa2_table-v2.7.7.txt
    # metaphlan had to run before humann2
    metaphlan --input_type fastq --nproc 12 --sample_id ${sample} --bowtie2out "$f/stag-mwc/output_dir/metaphlan/${sample}.bowtie2.bz2" "$f/stag-mwc/output_dir/host_removal/${sample}_1.fq.gz","$f/stag-mwc/output_dir/host_removal/${sample}_2.fq.gz" -o "$f/stag-mwc/output_dir/metaphlan/${sample}.metaphlan.txt"   
    # looks like metaphlan 3 has broken downloads as well
    #
    # Convert MPA 3 output to something like MPA2 v2.7.7 output 
    # so it can be used with HUMAnN2, avoids StaG issue #138.
    # TODO: Remove this once HUMANn2 v2.9 is out.
    sed '/#/d' "$f/stag-mwc/output_dir/metaphlan/${sample}.metaphlan.txt" | cut -f1,3 >> "${humann2_dir}mpa2_table-v2.7.7.txt"
    cat "$f/stag-mwc/output_dir/host_removal/${sample}_1.fq.gz" "$f/stag-mwc/output_dir/host_removal/${sample}_2.fq.gz" > "${humann2_dir}concat_input_reads.fq.gz"
    # humann2
    conda activate humann2
    humann2 --input "${humann2_dir}concat_input_reads.fq.gz" --output $humann2_dir --nucleotide-database "databases/func_databases/humann2/chocophlan" --protein-database "databases/func_databases/humann2/uniref" --output-basename $sample --threads 12 --taxonomic-profile "${humann2_dir}mpa2_table-v2.7.7.txt" 
    # normalize_humann2_tables
    #humann2_renorm_table --input {input.genefamilies} --output {output.genefamilies} --units {params.method} --mode {params.mode} 
    #humann2_renorm_table --input {input.pathabundance} --output {output.pathabundance} --units {params.method} --mode {params.mode}
    # join_humann2_tables
    #humann2_join_tables --input {params.output_dir} --output {output.genefamilies} --file_name {params.genefamilies}
    #humann2_join_tables --input {params.output_dir} --output {output.pathcoverage} --file_name pathcoverage
    #humann2_join_tables --input {params.output_dir} --output {output.pathabundance} --file_name {params.pathabundance}
done