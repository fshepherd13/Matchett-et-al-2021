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
## Builds
There are several directories within `./my_profiles` which refer to different builds. *The builds used in the manuscript Matchett et al., 2021 are `./my_profiles/n_only` and `./my_profiles/spike_only`.* These builds result in a downsampled set of ~1900 sequences by splitting the data into geographic region and months, and sampling about 200 strains per region from the most recent four months (Jan-Apr 2021) and 200 strains per region from the months before that. For instructions on creating your own builds, see the resources on [Nextstrain](https://nextstrain.org).

There are additional builds that are not part of the manuscript that are meant to sample strains from before and after September 2020 (`./my_profiles/n_only_pre_sept` and `./my_profiles/spike_only_pre_sept`) and the other subsampling strains after September 2020 (`./my_profiles/n_only_post_sept` and `./my_profiles/spike_only_post_sept`). Here, each build specifies the sampling date cutoff for the sequences, and takes 100 sequences per country, per month to create a downsampled set of SARS-CoV-2 sequences. These are in progress.

## Running the build
To re-run the builds for spike or nucleocapsid genes, run the following after compiling raw data from Genbank (see above):
```
export AUGUR_RECURSION_LIMIT=10000
snakemake --cores 8 --profile ./my_profiles/n_only
snakemake --cores 8 --profile ./my_profiles/spike_only
```

# Results
To visualize full results, drag and drop the auspice files created by pipeline (found in this repo in `./auspice/spike_global_genbank.json` and `./auspice/n_global_genbank.json` into [auspice.us](auspice.us). The phylogeny can be viewed interactively. Data for further downstream analysis of mutation frequencies in spike versus n was done by downloading the diversity panel data from auspice (described next).

## Diversity panel data
Diversity panel data can be viewed in several ways in auspice, including per site entropy for amino acids or nucleotides, and mutational events for AA and NTs. Events refer to the number of nodes in the phylogenetic tree that undergo a change at a given gene or protein position. Entropy refers to the diversity of AA or NT identities at a site in the dataset as a whole. CSV-formatted data was downloaded from auspice and visualized with R for publication. See the data and R code under `./diversity_panel_data`.