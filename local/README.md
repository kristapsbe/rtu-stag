Scripts for setting up and processing samples on a local environment

the taxonomic setup script took a full night to run (the main bottleneck in its runtime is network speed though as it needs to download around 110 gigs of data)

fastp uses around 1.5 gigs of ram
host removal uses around 5 gigs of memory
taxon classification uses around 43 gigs of memory
whole process takes 20-25 minutes

groot uses around 1.8 gigs of ram
takes around 20 minutes to run

the issue with humann2 is that it requires python2 (and, as a result, is incompatible with snakemake) - I think the local conda environments are there to deal with that, but they don't seem to be getting used