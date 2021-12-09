#!/bin/bash
#$ -cwd
#$ -S /bin/bash

# basic argument
REF=$1
dbSNP=$2
INPUT_Path=$3
SAMPLE=$4
OUTPUT_Path=$5

# print start time
date

gatk --java-options "-Xmx8g -Djava.io.tmpdir=$DIR/temp/" HaplotypeCaller \
--reference $REF \
--input $INPUT_Path${SAMPLE}.bam \
--output $OUTPUT_Path${SAMPLE}.haplotype.vcf \
--dont-use-soft-clipped-bases \
--dbsnp $dbSNP
