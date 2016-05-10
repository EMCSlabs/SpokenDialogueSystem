#!/bin/bash

workingd=$1
MIX=$2

if ! test -d ${workingd}models/HMM$MIX.1 ; then
mkdir ${workingd}models/HMM$MIX.1
fi 

HERest -T 1 \
       -C ${workingd}config/config2 \
       -t 250.0 150.0 1000.0 \
       -S ${workingd}scp/train.scp \
       -H ${workingd}models/HMM$MIX.0/macros \
       -H ${workingd}models/HMM$MIX.0/hmmdefs \
       -M ${workingd}models/HMM$MIX.1 \
       -I ${workingd}mlf/phones1_5sp.mlf \
       ${workingd}list/phonesp.list 

if ! test -d ${workingd}models/HMM$MIX.2 ; then
mkdir ${workingd}models/HMM$MIX.2
fi 

HERest -T 1 \
       -C ${workingd}config/config2 \
       -t 250.0 150.0 1000.0 \
       -S ${workingd}scp/train.scp \
       -H ${workingd}models/HMM$MIX.1/macros \
       -H ${workingd}models/HMM$MIX.1/hmmdefs \
       -M ${workingd}models/HMM$MIX.2 \
       -I ${workingd}mlf/phones1_5sp.mlf \
       ${workingd}list/phonesp.list 

