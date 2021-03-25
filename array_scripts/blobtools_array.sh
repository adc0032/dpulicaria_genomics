#! /bin/bash

#PBS -l nodes=1:ppn=10,mem=100gb,walltime=15:00:00:00
#PBS -M adc0032@auburn.edu
#PBS -m ae
#PBS -N Blobtools-Dpulicaria
#PBS -j oe
#PBS -t 1-2

##Modules
module load perl/5.26.0
module load xz/5.2.2
module load java/1.8.0_91
module load htslib
module load samtools/1.6
module load bwa/0.7.17
module load diamond/1
module load ncbi-blast/2.9.0+
module load bedtools/2

##Variables
wd="/scratch/adc0032/Daphnia/Blob"
dd="/home/adc0032/2021_Bioinformatics/FinalDpulicaria"
met="${wd}/dpulicaria.meta"
jf="${wd}/dpulicaria.jf"
dbd="/scratch/Bio_Omics_Databases/NCBI_db"
blbd="/home/adc0032/blobtools-blobtools_v1.1.1/"

##Commands

cd ${wd}
sm=$( head -n ${PBS_ARRAYID} ${jf} | tail -n 1)
rdpfx=`grep "${sm}" ${met} |awk '{print $1}'`

##Setting up directories for each genome; subdirectories for different processes

sd="${dd}/${sm}"

if [ -d ${sm}_blob ]; then

	echo "${sm}_blob directory exists. Will attempt to work with exisiting files"
	gndir="${wd}/${sm}_blob"
#	exit 1

else

mkdir ${sm}_blob
gndir="${wd}/${sm}_blob"

fi

## Database Check

if [[ ! `ls -A "${dbd}/nt_BlastDB"` ]] || [[ ! `ls -A "${dbd}/Taxonomy"` ]]; then

source ~/workflow/download_ncbi.sh ${dbd}
chmod -R 777 ${dbd}
cd ${wd}

else

echo "Databases have been downloaded. Proceeding..."

fi

## Reference Indexing

cp ${sd}/4_FASTAs/${rdpfx}.fa .

ref="${wd}/${rdpfx}.fa"
rfp=`basename ${ref} | cut -d "." -f 1`

if [ -s ${rfp}.dict ] && [ -s ${rfp}.bwt ]; then
	echo "Reference has previously been index, check ${wd} for verification."
else
source ~/workflow/run_indexgen.sh ${rfp} ${ref}
fi

## Mapping
MDB="${gndir}/2_Cov/${rdpfx}.md.bam"

if [ ! -s ${MDB} ]; then

rrds=(`ls ${sd}/1_RRnQC/${rdpfx}_*.fq.gz`)
mkdir ${gndir}/2_Cov

source ~/workflow/run_bwa.sh ${rfp} ${sm} ${met} ${rrds[@]} ;

chmod -R 777 ${gndir}
mv ${rdpfx}.* ${gndir}/2_Cov
mv ${gndir}/2_Cov/${rdpfx}.fa .

else

echo "Coverage file previously created. Will not overwrite. Proceeding to Hits file creation..."

fi

## Taxon Hits
if [ ! -s ${gndir}/3_Hits/${rdpfx}.*.taxified.out ]; then
mkdir ${gndir}/3_Hits

if [ ! -s ${gndir}/3_Hits/${rdpfx}.*.dmd.out ]; then

if [ ! -s $MDB ]; then
	echo "${MDB} is empty or does not exist.No coverage file created. Aborting."
	exit 1
else

source ~/workflow/run_nrdmnd.sh ${rdpfx} ${ref};
ogHIT="${gndir}/3_Hits/${rdpfx}.*.dmd.out"
source ~/workflow/run_blobtaxify.sh ${rdpfx} ${dbd} ${blbd} ${ogHIT};
chmod -R 777 ${gndir}
mv ${rdpfx}*.out ${gndir}/3_Hits
fi

else
ogHIT="${gndir}/3_Hits/${rdpfx}.*.dmd.out"
source ~/workflow/run_blobtaxify.sh ${rdpfx} ${dbd} ${blbd} ${ogHIT};
chmod -R 777 ${gndir}
mv ${rdpfx}*.out ${gndir}/3_Hits
fi

else

echo "Hits file previously created. Will not overwrite. Proceeding to BlobDB creation..."

fi

## BlobDB & Blobplot Generation
txHIT="${gndir}/3_Hits/${rdpfx}.*.taxified.out"

mkdir ${gndir}/4_Blobs

source ~/workflow/run_blobfin.sh ${rdpfx}_clean.fa ${MDB} ${txHIT} ${rdpfx} ${blbd};

chmod -R 777 ${gndir}

mv ${rdpfx}.blobDB.* ${gndir}/4_Blobs
mv ${rdpfx}.*.cov ${gndir}/4_Blobs
## Clean UP and Compression

cp ${met} ${gndir}
rm ${gndir}/2_Cov/${rdpfx}.bam

tar -cvzf ${rdpfx}_blob.tar ${sm}_blob
mv ${rdpfx}_blob.tar ${sd}
rm -Rf ${gndir}
