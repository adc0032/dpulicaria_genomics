# Reference-Guided Genome Assembly and Assessment of Two _Daphnia pulicaria_ Strains

### Background

#### Paper Abstract
> maybe we can include our Abstract

#### Repository Purpose
> This repository contains all scripts used to perform reference-guided genomic assembly and screen for contaminants on a supercomputer as was done in Clark et al. 2021. These scripts are designed to assemble the genomes for two strains of _Daphnia pulicaria_ using _Daphnia pulex_ (PA42) as a reference. This repository presents a simplified workflow/pipeline to run these analyses on a supercomputer and are separated into two parts, genomic assembly and contaminant screening.
plus some coding logic here

### Usage
> explanation of the scripts (hierarchially, from main array + all subsequent scripts within)

1. Reference-Guided Genome Assembly Pipeline
   - refg_assem_array.sh 
     - array script for running reference guided assembly
   - support scripts: 
     - run_fastqscreen.sh 
       - running fastqscreen for quality control
     - run_indexgen.sh 
       - indexing the reference genome
     - run_bwa.sh 
       - mapping using Burrows-Wheeler Aligner
     - run_GATK.sh
     - run_consensus.sh
2. Blobtools Contamination Screening Pipeline
   - blobtools_array.sh
     - array script
   - support scripts:
     - download_ncbi.sh
       -
     - run_nrdmnd.sh
       -
     - run_blobtaxify.sh
       -
     - run_blobfin.sh

### HPC Scheduler Modifications
> PBS and SLURM schedulers use slightly different commands to run jobs. These scripts were run on both schedulers. Below are example headers for bash scripts that demonstrate the subtle differences in commands between the two.   
##### ----------------PBS Parameters----------------- #
> ###### #PBS -l nodes=1:ppn=10,mem=100gb,walltime=15:00:00:00
> ###### ##send email -M mailuser -m ae is abort; end
> ###### #PBS -M 
> ###### #PBS -m ae
> ###### ##job name
> ###### #PBS -N RefGuide-Dpulicaria
> ###### #PBS -j oe
> ###### ##array
> ###### #PBS -t 1-2
##### ----------------SLURM Parameters-------------- #
> ###### ##nodes
> ###### #SBATCH -N 1
> ###### ##ppn
> ###### #SBATCH -n 10
> ###### ##memory
> ###### #SBATCH --mem=100gb
> ###### ##walltime
> ###### #SBATCH -t 15-00:00:00
> ###### #SBATCH --mail-user=
> ###### ##send email abort; begin; end
> ###### #SBATCH --mail-type ALL
> ###### ##job name
> ###### #SBATCH --job-name RefGuide-Dpulicaria
> ###### ##output file
> ###### #SBATCH -o refguideout 
> ###### ##array
> ###### #SBATCH --array=1-2
### Citing this Code and Repository
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4635402.svg)](https://doi.org/10.5281/zenodo.4635402)
