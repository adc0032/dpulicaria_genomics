#! /bin/sh

diamond blastx \
--query ${2} \
--db /scratch/Bio_Omics_Databases/NCBI_db/nr_DiamondDB/nr_dm.dmnd \
--outfmt 6 \
--sensitive \
--max-target-seqs 1 \
--evalue 1e-25 \
--threads 16 \
--out ${1}.vs.nr.mts1.1e25.dmd.out

