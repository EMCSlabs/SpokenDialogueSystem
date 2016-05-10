#!/bin/bash

workingd=$1
MIX=$2

HVite -T 1 \
	-t 250.0 \
	-H ${workingd}models/HMM$MIX.2/macros \
	-H ${workingd}models/HMM$MIX.2/hmmdefs \
	-S ${workingd}scp/smalltest.scp \
	-i ${workingd}models/HMM$MIX.2/smalltest.mlf \
	-w ${workingd}gram/bg.lat \
	${workingd}dict/all_dict_no_variation_sp.txt \
	${workingd}list/phonesp.list
