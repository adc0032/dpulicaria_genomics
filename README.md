# Reference-Guided Genome Assembly and Assessment of Two _Daphnia pulicaria_ Strains

### Background

#### Paper Abstract
> maybe we can include our Abstract

#### Repository Purpose
> plus some coding logic here

### Usage
> explanation of the scripts (hierarchially, from main array + all subsequent scripts within)

#### Reference-Guided Genome Assembly Pipeline

#### Blobtools Contamination Screening Pipeline

### HPC Scheduler Modifications
> PBS and SLURM schedulers use slightly different commands to run jobs. These scripts were run on both schedulers. Below are example headers for bash scripts that demonstrate the subtle differences in commands between the two.   
##### ----------------PBS Parameters----------------- #
###### #PBS -l nodes=1:ppn=10,mem=100gb,walltime=15:00:00:00
###### ##send email -M mailuser -m ae is abort; end
###### #PBS -M 
###### #PBS -m ae
###### ##job name
###### #PBS -N RefGuide-Dpulicaria
###### #PBS -j oe
###### ##array
###### #PBS -t 1-2
##### ----------------SLURM Parameters-------------- #
###### ##nodes
###### #SBATCH -N 1
###### ##ppn
###### #SBATCH -n 10
###### ##memory
###### #SBATCH --mem=100gb
###### ##walltime
###### #SBATCH -t 15-00:00:00
###### #SBATCH --mail-user=
###### ##send email abort; begin; end
###### #SBATCH --mail-type ALL
###### ##job name
###### #SBATCH --job-name RefGuide-Dpulicaria
###### ##output file
###### #SBATCH -o refguideout 
###### ##array
###### #SBATCH --array=1-2
### Citing this Code and Repository
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4635402.svg)](https://doi.org/10.5281/zenodo.4635402)
