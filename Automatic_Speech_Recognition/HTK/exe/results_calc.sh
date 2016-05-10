#!/bin/bash
workingd=$1
MIX=$2

HResults -T 1 \
	-I ${workingd}mlf/testword.mlf \
	${workingd}dict/all_dict_no_variation.txt \
	${workingd}models/HMM$MIX.2/smalltest.mlf
