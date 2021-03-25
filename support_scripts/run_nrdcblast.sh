#! /bin/sh


blastn -task dc-megablast \
-query ${2} \
-db nr \
-outfmt 6 \
-max_target_seqs 1 \
-max_hsps 1 \
-evalue 1e-25 \
-out ${1}.vs.nr.mts1.hsp1.1e25.dc_megablast.out


