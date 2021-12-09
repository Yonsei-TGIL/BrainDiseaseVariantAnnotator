import os
import sys
import collections
import gzip


def read_annotation(INFO) :
	INFO = INFO.split(';')
	annotation = {}
	for i in INFO :
		if i[0:4] == 'CSQ=' :
			ANN = i.split('|')
	annotation['TYPE'] = ANN[1]
	annotation['IMPACT'] = ANN[2]
	annotation['GENE'] = ANN[3]
	annotation['HGVSc'] = ANN[10]
	annotation['HGVSp'] = ANN[11]
	annotation['Existing_variation'] = ANN[17]
	annotation['SIFT'] = ANN[36]
	annotation['gnomAD_EAS_AF'] = ANN[51]
	return annotation

def read_DATA(FORMAT, DATA) :
	data = {}
	for index, value in enumerate(FORMAT) :
		data[value] = DATA[index]
	return data

def read_brainDB(db) :
	DB = open(db,'r')
	db_dic = {}
	for DBline in DB :
		DBtab = DBline.split('\t')
		db_dic[DBtab[0]] = DBtab[1].rstrip('\n')
	return db_dic

def write_header(output_file) :
	output_file.write('CHR\tPOS\tREF\tALT\tREF_count\tALT_count\tAF\tID\tGENE\tTYPE\tIMPACT\tHGVS.c\tHGVS.p\tSIFT\tgnomAD_EAS_AF\tBrain_DB\n')
	
if __name__== '__main__' :

	vcf_file = sys.argv[1]
	output_path = os.path.dirname(vcf_file)
	filename = os.path.basename(vcf_file).rstrip('vcf.gz')

	vcf_file = gzip.open('%s'%vcf_file,'rb')
	output1_file = open('%s/%s.tsv'%(output_path,filename),'w')
	output2_file = open('%s/%s.rare.tsv'%(output_path,filename),'w')
	output3_file = open('%s/%s.rare.brain.tsv'%(output_path,filename),'w')

	write_header(output1_file)
	write_header(output2_file)
	write_header(output3_file)	

	brainDB = read_brainDB("BrainDB.txt")

	for line in vcf_file :
		if line[:1] == '#' : continue
		line = line.rstrip()
		col = line.split('\t')

		CHROM = col[0]
		POS = col[1]
		ID = col[2]
		REF = col[3]
		ALT = col[4]
		INFO = col[7]
		FORMAT = col[8].split(':')
		DATA = col[9].split(':')

		key = CHROM+'\t'+POS+'\t'+REF+'\t'+ALT
		annotation = read_annotation(INFO)
		data = read_DATA(FORMAT, DATA)

		AD = data['AD'].split(',')
		try :
			AF = float(AD[1]) / ( float(AD[0]) + float(AD[1]) )
		except :
			print (AD)
			continue

		try :
			output_line = '\t'.join([key, AD[0], AD[1], str(round(AF,2)), annotation['Existing_variation'], annotation['GENE'],annotation['TYPE'],annotation['IMPACT'],annotation['HGVSc'],annotation['HGVSp'],annotation['SIFT'],annotation['gnomAD_EAS_AF'], brainDB[annotation['GENE']]])+'\n'
		except :
			output_line = '\t'.join([key, AD[0], AD[1], str(round(AF,2)), annotation['Existing_variation'] , annotation['GENE'],annotation['TYPE'],annotation['IMPACT'],annotation['HGVSc'],annotation['HGVSp'],annotation['SIFT'],annotation['gnomAD_EAS_AF'],''])+'\n'

		output1_file.write(output_line)

		try :
			EAS_AF = float(annotation['gnomAD_EAS_AF'])
			if EAS_AF > 0.01 : continue
		except :
			EAS_AF = ''
		if ID == '.'  and annotation['IMPACT'] == 'HIGH' :
			output2_file.write(output_line)
			if annotation['GENE'] in brainDB :
				output3_file.write(output_line)
		if ID == '.'  and annotation['SIFT'].split('(')[0] == 'deleterious' :
			output2_file.write(output_line)
			if annotation['GENE'] in brainDB :
				output3_file.write(output_line)
