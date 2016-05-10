#!/bin/bash

workingd=$1 
echo $workingd
#H2CompV  \
#	-T 1	\	#Debugging level 1
#	-C config2 \	#Config file
#	-f 0.01 \ #(floor variance)
#	-m		\ #mean
#	-S $workingd/scp/train.scp	\ #Training data list file
# 	$workingd/config/proto		# Proto file.
tt=${workingd}config/config2
echo $tt
HCompV -T 1 \
	   -C ${workingd}config/config2 \
	   -f 0.01 \
	   -m \
	   -S ${workingd}scp/train.scp \
	   -M ${workingd}models/HMM0 \
	    ${workingd}config/proto		




#H2HEd 	-w MMF		Making single master macro MMF
#     	-d .		Reading files from current directory or wherever
#	-M hmm0		Output dircectory
#	/dev/null	H2HEd needs editscript but in this case no script
#			is need. So null device is always used
#	../mono.list	Monophone list file

