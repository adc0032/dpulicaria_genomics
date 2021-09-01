# Reference-Guided Genome Assembly and Assessment of Two _Daphnia pulicaria_ Strains

### Background

![Heads and Tails!: A Close-Up of *Daphnia pulicaria*](img/Daphnia_coverart_sub.png)
#### Paper Abstract
   *Daphnia* species are well-suited for studying local adaptation and evolutionary responses to stress(ors) including those caused by algal blooms. Algal blooms, characterized by an overgrowth (bloom) of cyanobacteria, are detrimental to the health of aquatic and terrestrial members of freshwater ecosystems. Some strains of *Daphnia pulicaria* have demonstrated resistance to toxic algae and the ability to mitigate toxic algal blooms. Understanding the genetic mechanism associated with this toxin resistance requires adequate genomic resources. Using whole-genome sequence data mapped to the *Daphnia pulex* reference genome (PA42), we present reference-guided draft assemblies from one tolerant and one sensitive strain of *D. pulicaria*, Wintergreen-6 (WI-6), and Bassett-411 (BA-411), respectively. Assessment of the draft assemblies reveal low contamination levels, and high levels (95%) of genic content. Reference scaffolds had coverage breadths of 98.9–99.4%, and average depths of 33X and 29X for BA-411 and WI-6, respectively. Within, we discuss caveats and suggestions for improving these draft assemblies. These genomic resources are presented with a goal of contributing to the resources necessary to understand the genetic mechanisms and associations of toxic prey resistance observed in this species.

##### Citation
Amanda D Clark, Bailey K Howell, Alan E Wilson, Tonia S Schwartz, Draft genomes for one *Microcystis*-resistant and one *Microcystis*-sensitive strain of the water flea, *Daphnia pulicaria*, *G3 Genes|Genomes|Genetics*, 2021;, jkab266, https://doi.org/10.1093/g3journal/jkab266

#### Repository Purpose
This repository contains all scripts used to perform reference-guided genomic assembly from paired end sequence reads and screen for contaminants as was done in Clark et al. 2021. These scripts are designed to assemble the genomes for two strains of _Daphnia pulicaria_ using _Daphnia pulex_ (PA42) as a reference. This repository presents a simplified workflow/pipeline to run these analyses on a supercomputer and are separated into two parts, reference-guided genomic assembly and contamination screening.


### Usage
To use these scripts, you will need to update the header information in the array scripts based on your HPC (see [HPC Scheduler Modifications](#hpc-scheduler-modifications) below). **Certain regions of the code need to be specified for the user and their system.** The main regions of the code that require these updates are the variables within the array scripts (which can be fitted for a single job by hardcoding the `sm` variable). The save directory for the additional script will also need an update of the path. 


1. Reference-Guided Genome Assembly Pipeline
   - refg_assem_array.sh 
     -  array script for running reference guided assembly
   - support scripts: 
     - run_fastqscreen.sh 
       - running `fastqscreen` for quality control
     - run_indexgen.sh 
       - indexing the reference genome
     - run_bwa.sh 
       - mapping using Burrows-Wheeler Aligner (`bwa`)
     - run_GATK.sh
       - performing local realignment, identifying SNPs and INDELs, and filtering identified variants with `gatk`
     - run_consensus.sh
       - inserting SNPs into the reference genome to create consensus sequence and masking zero coverage and INDEL regions 
2. Blobtools Contamination Screening Pipeline
   - blobtools_array.sh
     - array script for screening for contaminants
   - support scripts:
     - download_ncbi.sh
         - downloads NBCI databases for contaminant identification 
     - run_nrdmnd.sh
         - runs `diamond blastx` against the NCBI NR database (alternatively `run_ntdcblast.sh` uses `blastnt` against the NCBI NT database) 
     - run_blobtaxify.sh
         - runs `blobtools taxify` to add TaxIDs to blast output from NCBI
     - run_blobfin.sh
         - runs `blobtools create` and all downstream commands to produce all plot outputs
3. Additional Scripts
   - download_blastdb.sh
     - script for downloading nr database


### HPC Scheduler Modifications
PBS and SLURM schedulers use slightly different commands to run jobs. These scripts were run on both schedulers. Below are example headers for bash scripts that demonstrate the subtle differences in commands between the two.


##### PBS Parameters
> ###### ## Resources, nodes, processors per node, memory, jobtime
> ###### #PBS -l nodes=1:ppn=10,mem=100gb,walltime=15:00:00:00
> ###### ##send email -M mailuser -m ae is abort; end
> ###### #PBS -M usr@host.edu
> ###### #PBS -m ae
> ###### ##job name
> ###### #PBS -N RefGuide-Dpulicaria
> ###### ## combine standard out and error in jobfile
> ###### #PBS -j oe
> ###### ##array
> ###### #PBS -t 1-2


##### SLURM Parameters
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
