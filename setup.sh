# first thing's first clone stag if it's not here already
git clone https://github.com/lucren/stag-mwc.git ../stag-mwc

# go into the folder and pull changes (mostly to deal with a case where the repohas already been pulled)
cd ../stag-mwc
git checkout hpc_mod # the modded branch that we're working with
git pull