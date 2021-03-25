#! /bin/sh

sm=`basename ${2} |awk -F"." '{print $1}'`

gatk --java-options "-Xmx100g" HaplotypeCaller --reference ${1} --input ${2} --output ${sm}_allvar.vcf

gatk SelectVariants --variant ${sm}_allvar.vcf \
--select-type-to-include SNP \
--output ${sm}_allSNP.vcf;

gatk SelectVariants --variant ${sm}_allvar.vcf \
--select-type-to-include INDEL \
--output ${sm}_allIND.vcf;


gatk VariantFiltration --reference ${1} --variant ${sm}_allSNP.vcf \
--filter-expression "QD < 2.0" --filter-name "QD2" \
--filter-expression "QUAL < 30.0" --filter-name "QUAL30" \
--filter-expression "SOR > 3.0" --filter-name "SOR3" \
--filter-expression "FS > 60.0" --filter-name "FS60" \
--filter-expression "MQ < 40.0" --filter-name "MQ40" \
--filter-expression "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
--filter-expression "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
--G-filter "GQ < 30.0" --G-filter-name "GQ30" \
--output ${sm}_fltrSNP.vcf

gatk VariantFiltration --reference ${1} --variant ${sm}_allIND.vcf \
--filter-expression "QD < 2.0" --filter-name "QD2" \
--filter-expression "QUAL < 30.0" --filter-name "QUAL30" \
--filter-expression "FS > 200.0" --filter-name "FS200" \
--filter-expression "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" \
--G-filter "GQ < 30.0" --G-filter-name "GQ30" \
--output ${sm}_fltrIND.vcf
