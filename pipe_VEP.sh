#!/bin/bash
#$ -S /bin/bash
#$ -cwd

REF=$1
SAMPLE=$2
OUTPUT_Path=$3
vepPath=$4
cache_version=$5
vep_cache_directory_Path=$6
vep_plugin_directory_Path=$7
assembly=$8

$vepPath/vep \
	-i $OUTPUT_Path${SAMPLE}.haplotype.INDEL.FILTER.PASS.vcf.gz \
	-o $OUTPUT_Path${SAMPLE}.haplotype.INDEL.FILTER.PASS.vep.vcf.gz \
        -v -assembly $assembly \
	--sift b --ccds --hgvs --symbol --numbers --domains --regulatory --canonical --protein --biotype --uniprot --tsl --appris \
	--gene_phenotype --af --af_1kg --af_esp --af_gnomad --max_af --pubmed --var_synonyms --variant_class --mane \
	--check_existing \
	--exclude_null_alleles \
	--compress_output gzip \
	--terms "SO" \
        --vcf \
        --format "vcf" \
        --force \
        --cache_version $cache_version \
        --cache --dir_cache $vep_cache_directory_Path \
        --dir_plugins $vep_plugin_directory_Path \
        --fasta $REF \
        --offline


$vepPath/vep \
	-i $OUTPUT_Path${SAMPLE}.haplotype.SNV.FILTER.PASS.vcf.gz \
	-o $OUTPUT_Path${SAMPLE}.haplotype.SNV.FILTER.PASS.vep.vcf.gz \
	-v -assembly $assembly \
	--sift b --ccds --hgvs --symbol --numbers --domains --regulatory --canonical --protein --biotype --uniprot --tsl --appris \
	--gene_phenotype --af --af_1kg --af_esp --af_gnomad --max_af --pubmed --var_synonyms --variant_class --mane \
	--check_existing \
	--exclude_null_alleles \
	--compress_output gzip \
	--terms "SO" \
	--vcf \
	--format "vcf" \
	--force \
	--cache_version $cache_version \
	--cache --dir_cache $vep_cache_directory_Path \
	--dir_plugins $vep_plugin_directory_Path \
	--fasta $REF \
	--offline


#--custom ${jarvis_bed_DIR}/jarvis.All.both-features.sorted.hg38.bed.gz,jarvis,bed,exact,0

