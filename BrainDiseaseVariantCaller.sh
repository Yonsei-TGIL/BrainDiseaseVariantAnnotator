#!/bin/bash
#$ -S /bin/bash
#$ -cwd

# Basic Argument
PROJECT=Post-Genome
DIR=/data/project/$PROJECT
REF=/data/resource/reference/human/UCSC/hg38/BWAIndex/genome.fa
dbSNP=/data/public/dbSNP/b155/GRCh38/GCF_000001405.39.re.common.vcf.gz

vepPath=/opt/Yonsei/ensembl-vep/104.3/
cache_version=104
vep_cache_directory_Path=/data/public/VEP/$cache_version
vep_plugin_directory_Path=/data/public/VEP/$cache_version/Plugins
assembly="GRCh38"

BAM_Path=$DIR/3.aligned/
BAM=SH_Lee.RGadded.marked.fixed.bam

VCF_Path=$DIR/4.analysis/HaplotypeCaller/

SAMPLE=${INPUT_BAM%%.bam}

echo '=============START running============='
echo ${BAM_Path}/${BAM}
echo ${VCF_Path}

sh pipe_HaplotypeCaller.sh ${REF} $dbSNP $BAM_Path $SAMPLE $VCF_Path

sh pipe_HaplotypeCaller_VariantFiltration.sh $REF $SAMPLE $VCF_Path

sh pipe_VEP.sh $REF $SAMPLE $VCF_Path $vepPath $cache_version $vep_cache_directory_Path $vep_plugin_directory_Path $assembly

python pipe_BrainDiseaseVariantCaller.py $VCF_Path${SAMPLE}.haplotype.SNV.FILTER.PASS.vep.vcf.gz

python pipe_BrainDiseaseVariantCaller.py $VCF_Path${SAMPLE}.haplotype.INDEL.FILTER.PASS.vep.vcf.gz 

echo '=============END============='
