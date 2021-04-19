# About

This repository analyzes viral genomes using [Nextstrain](https://nextstrain.org) to understand how SARS-CoV-2, the virus that is responsible for the COVID-19 pandemic, evolves and spreads. This is forked from the main Nextstrain repository which creates builds out of the whole genome sequences of SARS-CoV-2. My goal was to modify the code to create gene-specific builds for the spike and nucleocapsid proteins. 

# Data source

SARS-CoV-2 sequence data can either be retrived through [GISAID](https://www.gisaid.org/) (which requires an account and registration) or [Genbank](https://www.ncbi.nlm.nih.gov/genbank/). In order to work with the Nextstrain pipeline, the sequence data and metadata must be properly formatted. I used Genbank data for this analysis, which can be downloaded and formatted using [ncov-ingest](https://github.com/nextstrain/ncov-ingest). Follow the instructions in that repo for downloading your own dataset. GISAID also supposedly maintains a dataset pre-formatted for use with Nextstrain, but there have been reports that this is [not accessible by all account holders](https://discussion.nextstrain.org/t/nextmeta-and-nextfasta-not-on-gisaid/224). So your mileage may vary.

# Overview
This repo contains builds and config files under "my_profiles" that are necessary to create spike and nucleocapsid alignments. The underlying snakemake code has also been modified, but it has not been thoroughly tested to see how compatible this is with Nextstrain's main pipeline. So this should be considered a one-off project. 
The main modifications are the following:
1. In each build.yaml file, the user must specify which parts of the genome to mask, leaving just the gene of interest. The nucleotide positions are relative to the  [SARS-CoV-2 reference strain](https://www.ncbi.nlm.nih.gov/nuccore/1798174254) gene annotation. 
2. Several parts of the pipeline rely on calculations of genetic distance between sequences. In the main Nextstrain pipeline, this appears to always be based on the spike protein. For this pipeline, the gene used to calculate distance can be user-specified in the build.yaml file. So for example, the nucleocapsid build calculates genetic distance between strains using the N protein. This is specified in `distance: "N"` in the build.yaml file. I added a `distance` entry to the defaults parameter.yaml file so that it will default to using spike if not user-specified in the build-specific config files.

# Usage
## Environment
Nextstrain runs with a conda environment. See [setup and installation](https://nextstrain.github.io/ncov/setup.html) for more details. The yaml file is also included in this repo. To set up, run 
```
conda env create --file environment.yaml
conda activate nextstrain
```

## Running the build
To re-run the builds for spike or nucleocapsid genes, run the following:
```
export AUGUR_RECURSION_LIMIT=10000
snakemake --cores 8 --profile ./my_profiles/n_only
snakemake --cores 8 --profile ./my_profiles/spike_only
```

## Results
To visualize results, drag and drop the auspice files created by pipeline (found in this repo in `./auspice/spike_global_genbank.json` and `./auspice/n_global_genbank.json` into [auspice.us](auspice.us). The phylogeny can be viewed interactively. Data for further downstream analysis of mutation frequencies in spike versus n was done by downloading the diversity panel data from auspice.
