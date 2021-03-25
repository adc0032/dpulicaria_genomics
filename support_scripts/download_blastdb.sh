#! /bin/sh

module load ncbi-blast/2.9.0+

sd="/scratch/Bio_Omics_Databases/NCBI_db/nr_BlastDB"

cd ${sd}

update_blastdb.pl --decompress nr [*]

cd -
