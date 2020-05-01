This folder contains three config files:
* config.db.yaml => an essentially empty config that will be used when pulling databases via StaG
* config.func.yaml => a config for performing functional classification (uses humann2 and groot)
* config.func.yaml => a config for performing taxonomic classification (uses kraken2)

NB: The configs should be usable as-is with the only required change being - base_path has to be updated to the path that the repo was cloned into