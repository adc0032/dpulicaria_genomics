#! /bin/bash


if [ ! -s ${2} ] || [ ! -s ${3} ] || [ ! -s ${4} ]; then
        echo "One or more neccessary files for overwriting the reference genome is emtpy or missing. Aborting."
        exit 1
else

sm=`basename ${2} | awk -F"." '{print $1}'`

bgzip ${3}
bcftools index ${3}.gz

bcftools consensus -f ${1} ${3}.gz -o ${sm}.snp.fa

bedtools maskfasta -fi ${sm}.snp.fa -bed ${4} -fo ${sm}.ind.fa
bedtools maskfasta -fi ${sm}.ind.fa -bed ${2} -fo ${sm}.fa

fi
