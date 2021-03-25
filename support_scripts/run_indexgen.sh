#! /bin/bash

bwa index -p ${1} ${2} 
samtools faidx ${2}
java -Xms2g -Xmx14g -jar /tools/picard-tools-2.4.1/picard.jar CreateSequenceDictionary R=${2} O=${1}.dict
