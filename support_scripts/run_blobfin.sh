#! /bin/sh

#source activate qcnscreen

${5}/blobtools create \
--db ${5}/data/nodesDB.txt \
-i ${1} \
-b ${2} \
-t ${3} \
-o ${4}

blobtools view \
-i ${4}.*.json

blobtools plot \
-i ${4}.*.json \
-p 8

blobtools covplot \
-i ${4}.*.json

