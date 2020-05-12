Scripts for setting up and processing samples on a local environment

the taxonomic setup script took a full night to run (the main bottleneck in its runtime is network speed though as it needs to download around 110 gigs of data)

fastp uses around 2 gigs of ram
host removal uses around 5 gigs of memory
taxon classification uses around 43 gigs of memory

groot uses around 2 gigs of ram

the issue with humann2 is that it requires python2 (and, as a result, is incompatible with snakemake) - I think the local conda environments are there to deal with that, but they don't seem to be getting used

bowtie2 uses less than 2 gigs of ram
diamond running as part of the humann2 call eats around 15 gigs of ram (may have used more at some point, but was able to fit within a total of 64 gigs - finished during the night)
