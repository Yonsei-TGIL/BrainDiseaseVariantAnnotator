# BrainDiseaseVariantCaller
**BrainDiseaseVariantCaller** is a pipeline for selecting brain disease related germline variants from a alignment file.

**BrainDiseaseVariantCaller** currently covers Alzheimer's Disease, Autism, Dystonia, Parkinson's Disease, Epliepsy, Stroke, brain cancers, and is contantly updated along with [BrainBase](http://ngdc.cncb.ac.cn/brainbase/index) database.

<p align = 'center'><img src="https://user-images.githubusercontent.com/56012432/145349432-99b996d6-c7c4-48a9-8fde-50bd26d5fc16.png" width = "500"></p>

+ Requirement:
  +  Linux
  +  Python 2.7 or higher
  +  GATK 4.0 or higher
  +  VEP

To run the pipeline :

* Edit mandatory paths on the ***BrainDiseaseVariantCaller.sh***
* Run ***BrainDiseaseVariantCaller.sh***

  ``
  sh BrainDiseaseVariantCaller.sh [INPUT.bam]
  ``
  
  
 > <sub>This research was supported by a grant of the Korea Health Technology R&D Project through the Korea Health Industry Development Institute (KHIDI), funded by the Ministry of Health & Welfare, Republic of Korea (grant number : HI16C-1986).</sub>
