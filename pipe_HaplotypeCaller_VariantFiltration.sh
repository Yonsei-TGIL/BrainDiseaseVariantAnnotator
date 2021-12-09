#!/bin/bash
#$ -cwd
#$ -S /bin/bash


# basic argument
REF=$1
SAMPLE=$2
OUTPUT_Path=$3

# print start time
date

# 1-1. Extract the SNPs from the call set
gatk --java-options "-Xmx8g -Djava.io.tmpdir=$DIR/temp/" SelectVariants \
-R $REF \
-V $OUTPUT_Path${SAMPLE}.haplotype.vcf \
-O $OUTPUT_Path${SAMPLE}.haplotype.SNV.vcf \
--select-type-to-include SNP

# 1-2. Filter to the SNP call set
gatk --java-options "-Xmx8g -Djava.io.tmpdir=$DIR/temp/" VariantFiltration \
-R $REF \
-V $OUTPUT_Path${SAMPLE}.haplotype.SNV.vcf \
-O $OUTPUT_Path${SAMPLE}.haplotype.SNV.FILTER.vcf \
--filter-expression "MQ0 >= 4 && ((MQ0 / (1.0 * DP)) > 0.1)" \
--filter-name "HARD_TO_VALIDATE" \
--filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || HaplotypeScore > 13.0 || MappingQualityRankSum < -12.5 || ReadPosRankSum < -8.0" \
--filter-name "GATK_SNP_RECOMMENDATION" \
--filter-expression "DP < 5 " \
--filter-name "LowCoverage" \
--filter-expression "QUAL < 30.0 " \
--filter-name "VeryLowQual" \
--filter-expression "QUAL > 30.0 && QUAL < 50.0 " \
--filter-name "LowQual" \
--filter-expression "QD < 1.5 " \
--filter-name "LowQD" \
--filter-expression "SB > -10.0 " \
--filter-name "StrandBias"

gatk --java-options "-Xmx8g -Djava.io.tmpdir=$DIR/temp/" SelectVariants \
-R $REF \
-V $OUTPUT_Path${SAMPLE}.haplotype.SNV.FILTER.vcf \
-O $OUTPUT_Path${SAMPLE}.haplotype.SNV.FILTER.PASS.vcf \
--exclude-filtered


# 2-1. Extract the Indels from the call set
gatk --java-options "-Xmx8g -Djava.io.tmpdir=$DIR/temp/" SelectVariants \
-R $REF \
-V $OUTPUT_Path${SAMPLE}.haplotype.vcf \
-O $OUTPUT_Path${SAMPLE}.haplotype.INDEL.vcf \
--select-type-to-include INDEL


# 2-2. Filter to the Indel call set
gatk --java-options "-Xmx8g -Djava.io.tmpdir=$DIR/temp/" VariantFiltration \
-R $REF \
-V $OUTPUT_Path${SAMPLE}.haplotype.INDEL.vcf \
-O $OUTPUT_Path${SAMPLE}.haplotype.INDEL.FILTER.vcf \
--filter-expression "MQ0 >= 4 && ((MQ0 / (1.0 * DP)) > 0.1)" \
--filter-name "HARD_TO_VALIDATE" \
--filter-expression "QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0" \
--filter-name "GATK_INDEL_RECOMMENDATION" \
--filter-expression "DP < 5 " \
--filter-name "LowCoverage" \
--filter-expression "QUAL < 30.0 " \
--filter-name "VeryLowQual" \
--filter-expression "QUAL > 30.0 && QUAL < 50.0 " \
--filter-name "LowQual" \
--filter-expression "QD < 1.5 " \
--filter-name "LowQD" \
--filter-expression "SB > -10.0 " \
--filter-name "StrandBias"

gatk --java-options "-Xmx8g -Djava.io.tmpdir=$DIR/temp/" SelectVariants \
-R $REF \
-V $OUTPUT_Path${SAMPLE}.haplotype.INDEL.FILTER.vcf \
-O $OUTPUT_Path${SAMPLE}.haplotype.INDEL.FILTER.PASS.vcf \
--exclude-filtered

bgzip $OUTPUT_Path${SAMPLE}.haplotype.SNV.FILTER.PASS.vcf
tabix -p vcf $OUTPUT_Path${SAMPLE}.haplotype.SNV.FILTER.PASS.vcf.gz

bgzip $OUTPUT_Path${SAMPLE}.haplotype.INDEL.FILTER.PASS.vcf
tabix -p vcf $OUTPUT_Path${SAMPLE}.haplotype.INDEL.FILTER.PASS.vcf.gz

#print end time
date
