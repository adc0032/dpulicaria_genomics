#! /bin/bash

#PBS -l nodes=1:ppn=10,mem=100gb,walltime=15:00:00:00
#PBS -M adc0032@auburn.edu
#PBS -m ae
#PBS -N RefGuide-Dpulicaria
#PBS -j oe
#PBS -t 1-2

##Modules
module load bedtools/2
module load vcftools/v0.1.14-14
module load bcftools/1.3.1
module load perl/5.26.0
module load xz/5.2.2
module load java/1.8.0_91
module load htslib
module load samtools/1.6
module load gatk/4.1.2.0
module load fastqc/11.5
module load bwa/0.7.17

##Variables
dd="/home/adc0032/DaphniaGenomics19/GenomeOrg/Data"
wd="/scratch/adc0032/Daphnia"
sd="/home/adc0032/2021_Bioinformatics/FinalDpulicaria"
ref="${wd}/Dpulex.scaffolds.fa"
met="${wd}/dpulicaria.meta"
jf="${wd}/dpulicaria.jf"
rfp=`basename ${ref} | cut -d "." -f 1,2`

##Commands

cd ${wd}
sm=$( head -n ${PBS_ARRAYID} ${jf} | tail -n 1)
rdpfx=`grep "${sm}" ${met} |awk '{print $1}'`

##Setting up directories for each genome; subdirectories for different processes

if [ -d ${sm} ]; then
	echo "${sm} directory exists. Will not overwrite current data, aborting"
	exit 1
else
mkdir ${sm}
gndir="${wd}/${sm}"

mkdir ${gndir}/1_RRnQC

cp ${dd}/${rdpfx}*_1.fq.gz ${gndir}/1_RRnQC/${rdpfx}_1.fq.gz &&
cp ${dd}/${rdpfx}*_2.fq.gz ${gndir}/1_RRnQC/${rdpfx}_2.fq.gz

## Read QC
zcat ${gndir}/1_RRnQC/${rdpfx}_1.fq.gz |fastqc --outdir=${gndir}/1_RRnQC stdin

## Read Screen
qsub run_fastqcscreen.sh

fi
## Reference Indexing

if [ -s ${rfp}.dict ] && [ -s ${rfp}.bwt ]; then
	echo "Reference has previously been index, check ${wd} for verification."
else

source ~/workflow/run_indexgen.sh ${rfp} ${ref}
fi
## Mapping
rrds=(`ls ${gndir}/1_RRnQC/${rdpfx}_*.fq.gz`)

mkdir ${gndir}/2_BAMs

source ~/workflow/run_bwa.sh ${rfp} ${sm} ${met} ${rrds[0]} ${rrds[1]} ;
chmod -R 777 ${gndir}
rm ${rdpfx}.bam
mv ${rdpfx}.* ${gndir}/2_BAMs

## Variant Calling
MDB="${gndir}/2_BAMs/${rdpfx}.md.bam"

mkdir ${gndir}/3_Variants

if [ ! -s $MDB ]; then
	echo "${MDB} is empty or does not exist. Aborting."
	exit 1
else

source ~/workflow/run_GATK.sh ${ref} ${MDB};
chmod -R 777 ${gndir}

mv ${rdpfx}_* ${gndir}/3_Variants
fi
## Consensus Generation
ZRO="${gndir}/2_BAMs/${rdpfx}.zero.bed"
SNP="${gndir}/3_Variants/${rdpfx}_fltrSNP.vcf"
IND="${gndir}/3_Variants/${rdpfx}_fltrIND.vcf"

mkdir ${gndir}/4_FASTAs

source ~/workflow/run_consensus.sh  ${ref} ${ZRO} ${SNP} ${IND};
chmod -R 777 ${gndir}

mv ${rdpfx}*.fa ${gndir}/4_FASTAs

## Summary Generation
if [ ! -s ${gndir}/4_FASTAs/${rdpfx}.fa ]; then
	echo "The final file, ${rdpfx}.fa, was not created. Check that the preceding necessary files are correct and in the expected directory."
	exit 1
else
echo "${rdpfx}.summary contains a summary of the run."

touch ${rdpfx}.summary

echo "Run Info for refg_assem.sh" >> ${rdpfx}.summary; date >> ${rdpfx}.summary;
echo >> ${rdpfx}.summary
echo "Reference Guided Assembly for sample: ${rdpfx}" >> ${rdpfx}.summary ; echo "" >> ${rdpfx}.summary
echo "Depth from Samtools: " >> ${rdpfx}.summary
cat ${gndir}/2_BAMs/${rdpfx}.depth.txt >> ${rdpfx}.summary
echo "" >> ${rdpfx}.summary
echo "Mapping Stats from Samtools: " >> ${rdpfx}.summary
cat ${gndir}/2_BAMs/${rdpfx}.stats.txt >> ${rdpfx}.summary
echo >> ${rdpfx}.summary
echo "Final data saved to ${sd}" >> ${SM}.summary

echo "WARNING ::Ensure previous runs in the save directory are protected from overwriting"
fi

## Data Compression & Relocation
cp ${met} ${gndir}
mv ${rdpfx}.summary ${gndir}

tar -cvzf ${rdpfx}_assem.tar ${gndir}
mv ${rdpfx}_assem.tar ${sd}
rm -Rf ${gndir}
