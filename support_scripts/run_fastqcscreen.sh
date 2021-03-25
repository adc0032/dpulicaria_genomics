#! /bin/sh

#PBS -l nodes=1:ppn=10,mem=50gb,walltime=15:00:00:00
#PBS -M adc0032@auburn.edu
#PBS -m ae
#PBS -N Fastqcscreen-Dpulicaria
#PBS -j oe
#PBS -t 1-2

##Modules
module load perl/5.26.1

##Variables
wd="/scratch/adc0032/Daphnia"
sd="/home/adc0032/2021_Bioinformatics/FinalDpulicaria"
met="${wd}/dpulicaria.meta"
jf="${wd}/dpulicaria.jf"
rfp=`basename ${ref} | cut -d "." -f 1,2`

source activate qcnscreen

##Commands

cd ${sd}
sm=$( head -n ${PBS_ARRAYID} ${jf} | tail -n 1)

cd ${sm}/1_RRnQC

/home/adc0032/FastQ_Screen/FastQ-Screen-0.14.1/fastq_screen --aligner bowtie2 --outdir ../fastqscreen/ ${sm}*.fq.gz
