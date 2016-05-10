#!/bin/bash
workingd=$1
WAV=$2
MIXNUM=$3
MFC=$(echo $WAV |sed s/wav/mfc/)
echo $MFC


HVite -T 1 \
	-a \
	-m \
	-b sil \
	-P ESPS \
	-y lab \
	-L ${workingd}wordlab/ \
	-H ${workingd}models/HMM$3.2/macros \
	-H ${workingd}models/HMM$3.2/hmmdefs \
	-l ${workingd}esps/ \
	${workingd}dict/all_dict_no_variation_sp.txt \
	${workingd}list/phonesp.list \
	${workingd}mfc/$MFC
