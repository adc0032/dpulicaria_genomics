#! /bin/sh

ID=${2}
SM=`grep ${ID} ${3} | awk '{print $1}'`
PU=`grep ${ID} ${3} | awk '{print $4}'`
LB=`grep ${ID} ${3} | awk '{print $3}'`


bwa mem -t8 -R "@RG\tID:$ID\tSM:$SM\tLB:$LB\tPU:$PU\tPL:ILLUM" -v2 ${1} ${4} ${5} | samtools sort -@ 8 -o ${SM}.bam

samtools index ${SM}.bam

java -Xms2g -Xmx16g -jar /tools/picard-tools-2.4.1/picard.jar MarkDuplicates I=${SM}.bam O=${SM}.md.bam M=${SM}.MDmetrics.txt

samtools index ${SM}.md.bam

touch ${SM}.stats.txt && touch ${SM}.depth.txt

samtools flagstat ${SM}.md.bam > ${SM}.stats.txt

samtools depth ${SM}.md.bam |awk '{sum+=$3} END { print "Average = ",sum/NR}'> ${SM}.depth.txt

bedtools genomecov -ibam ${SM}.md.bam -bga |awk '$4 == 0' > ${SM}.zero.bed
