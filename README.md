notes

conda is expected to be installed

installation instructions => https://www.digitalocean.com/community/tutorials/how-to-install-anaconda-on-ubuntu-18-04-quickstart


samples should be placed into the samples folder (paired end reads expected with names that end with ..._<sample_id>_<direction_id>.fq.gz)

base path in config files that are in the configs folder should be updated to the path that the repo was cloned into

and 

./setup.core.sh

should be ran

Taxonomic classification can then be executed by going to the local folder and running

./setup.taxon.sh && ./build.taxon.sh && ./run.taxon.sh

Note that pulling the taxonomic database takes an age and a half (ran for a full night for me) and the classification, while running pretty quickly, eats up up to 44 gigs of ram

The functional classification as such isn't really there at the moment (only antibiotic resitomes get classified atm) it can then be executed by going to the local folder and running

./setup.func.sh && ./build.func.sh && ./run.func.sh

This has a pretty small memory footprint (up to 2 gigs) and is pretty quick to run

Once the script's been run for the first time subsequent runs require only 

./build.taxon.sh && ./run.taxon.sh

or 

./build.func.sh && ./run.func.sh

to be executed


Note! there is cleanup code after kraken to keep the taxonomic databases from eating up the whole hard drive, but there's no cleanup code after stag atm (means that each run creates 3 copies of the sample)