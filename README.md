This is a project that's intended to wrap [StaG-mwc](https://github.com/ctmrbio/stag-mwc) with the goal of automating and expanding it's usage when all samples cannot be processed at the same time.

# Pre-usage assumptions

Conda is expected to be installed on the host environment - https://www.digitalocean.com/community/tutorials/how-to-install-anaconda-on-ubuntu-18-04-quickstart can be used as installation instructions to set it up on a local environment.

# How to use

If you wish to run the project without fiddling with any of the configuration files you should clone it into your home directory.

The project is divided into 4 folders:
* `configs`: holds configuration files that both the local and the cluster jobs work
* `hpc`: holds scripts intended to be ran on the [Riga Technical Universities cluster](https://hpc.rtu.lv/)
* `local`: holds scripts intended for running on a local system (or a remote system with no queueing system)
* `samples`: intended to hold all of your samples (paired end reads expected with names that end with `..._<sample_id>_<direction_id>.fq.gz`)

# Notes

Kraken2 seems to be pretty unreliable at downloading all required references (it looks like the NCBI ftp server starts timing out download request after a little while). I would, intstead, recommend using [Minikraken](https://ccb.jhu.edu/software/kraken2/index.shtml?t=downloads) when running these scripts locally (assuming you have less than 192 gigabytes of RAM) if you're using a cluster (or have more than 192 gigabytes of ram available locally) a reference database containing all [bacteria](https://ftp.ncbi.nlm.nih.gov/refseq/release/bacteria/), [archaea](https://ftp.ncbi.nlm.nih.gov/refseq/release/archaea/) and [fungi](https://ftp.ncbi.nlm.nih.gov/refseq/release/fungi/) *.genomic.fna.gz files has been [made available via google drive](https://drive.google.com/file/d/1PSdMtl6LDXdn7VvjjIwVTPEtISoQqXmm/view).

The scripts have been made for use in the [Universities of Latvia Institute of Clinical and Preventitive Medicine](https://www.kpmi.lu.lv/en-gb/).