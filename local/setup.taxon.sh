# clear out the old installation folders
cd ../..
rm -rf kraken2

# we need to download and compile kraken2 to avoid using the segfaulting conda version
#
# remeber that build-essential have to be installed (at least in the wsl ubuntu build)
# apt-get install build-essential
git clone https://github.com/DerrickWood/kraken2.git kraken2
cd kraken2
./install_kraken2.sh ../kraken2_installed
# get rid of the repo folder and move the installation dir to a nicer looking folder name
cd ..
rm -rf kraken2
mv kraken2_installed kraken2

# setting up the kraken2 taxon database
#
# purge any databases that we may have set up for this already
rm -rf databases/taxon_databases

# set up the kraken2 database that we'll be matching our taxons agains
mkdir -p databases/taxon_databases
cd databases/taxon_databases
../../kraken2/kraken2-build --use-ftp --download-taxonomy --db kraken_taxon --threads 12
../../kraken2/kraken2-build --use-ftp --no-masking --download-library archaea --db kraken_taxon --threads 12
../../kraken2/kraken2-build --use-ftp --no-masking --download-library bacteria --db kraken_taxon --threads 12
../../kraken2/kraken2-build --use-ftp --no-masking --download-library fungi --db kraken_taxon --threads 12
../../kraken2/kraken2-build --build --db kraken_taxon --threads 12
rm -rf kraken_taxon/library # get rid of the 4 gig library source files
# set up the refence database that we'll be using to filter the reads (note that it's the GRCh38 reference)
mkdir human_reference
mv kraken_taxon/taxonomy human_reference/taxonomy # this takes up around 30 gigs - if we can avoid downloading it again we should
../../kraken2/kraken2-build --use-ftp --no-masking --download-library human --db human_reference --threads 12
../../kraken2/kraken2-build --build --db human_reference --threads 12
rm -rf human_reference/library # get rid of the 76 gig taxonomy library files
rm -rf human_reference/taxonomy # get rid of the 30 gig taxonomy source files