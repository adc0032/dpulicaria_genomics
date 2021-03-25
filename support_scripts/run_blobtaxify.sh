#! /bin/sh

#source activate qcnscreen
if [ ! -s ${2}/Taxonomy/prot.accession2taxid.FULL ]; then

	echo "Protein accession to TaxID file is not found. Download from NCBI using ~/workflow/download_ncbi.sh. Aborting."
	exit 1
else

for i in `ls ${2}/Taxonomy/x*`
do

split=`basename $i`
${3}/blobtools taxify \
-f ${4} \
-m ${i} \
-s 0 \
-t 1 \
-o ${split}

done

txOP=`basename ./xaa.${1}.*.taxified.out|cut -d '.' -f 1 --complement`
cat xa*.${1}.*.out > xall.${txOP}
sort -V xall.${txOP} |uniq |awk '$2 !~"N/A"' > ${txOP}
rm xa*
fi

