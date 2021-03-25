#! /bin/sh

module load ncbi-blast/2.9.0+

if [ ! `ls -A ${1}/nr_BlastDB` ]; then

cd ${1}/nr_BlastDB
update_blastdb.pl --decompress nr [*]

else
echo "NR Blast Database is already in ${1}/nr_BlastDB. Proceeding..."
fi

if [ ! `ls -A ${1}/Taxonomy` ]; then

cd ${1}/Taxonomy
wget "https://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/prot.accession2taxid.FULL.gz" &&
gunzip prot.accession2taxid.FULL.gz

else
echo "TaxID Mapping file is already in ${1}/Taxonomy. Proceeding..."
fi

