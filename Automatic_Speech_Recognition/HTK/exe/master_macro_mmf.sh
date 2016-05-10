#!/bin/bash

workingd=$1 

#HHEd 	-w hmmdefs		Making single master macro MMF
#     	-d ./		Reading files from current directory or wherever
#	-M hmm0		Output dircectory
#	/dev/null	H2HEd needs editscript but in this case no script
#			is need. So null device is always used
#	../mono.list	Monophone list file

HHEd -T 1 \
     -w hmmdefs \
     -d ${workingd}models/HMM0 \
     -M ${workingd}models/HMM0 \
     /dev/null \
    ${workingd}list/phone.list
