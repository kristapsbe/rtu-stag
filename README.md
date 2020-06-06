notes

conda is expected to be installed

installation instructions => https://www.digitalocean.com/community/tutorials/how-to-install-anaconda-on-ubuntu-18-04-quickstart


samples should be placed into the samples folder (paired end reads expected with names that end with ..._<sample_id>_<direction_id>.fq.gz)

base path in config files that are in the configs folder should be updated to the path that the repo was cloned into

and 

./setup.sh

should be ran

Classification can then be executed by going to the local folder and running

./run.sh

Note that pulling the taxonomic database takes an age and a half (ran for a full night for me) and the classification, while running pretty quickly, eats up up to 44 gigs of ram

IMPORTANT - the repo expects to be located in the home dir at the moment

The goal of this file is to give step-by-step instructions on how to tackle specific tasks with these scripts