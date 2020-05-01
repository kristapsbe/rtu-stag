Scripts for setting up and processing samples on a local environment

scripts tested on a 8700k with 64gb of ram running windows 10 with wsl (ubuntu)

the taxonomic setup script took a full night to run (the main bottleneck in its runtime is network speed though as it needs to download around 110 gigs of data)

fastp uses around 1.5 gigs of ram
host removal uses around 5 gigs of memory
taxon classification uses around 43 gigs of memory
whole process takes 20-25 minutes

groot uses around 1.8 gigs of ram