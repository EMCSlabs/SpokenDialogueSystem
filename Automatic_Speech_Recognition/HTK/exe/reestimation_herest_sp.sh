#!/bin/bash

workingd=$1

for i in 6 7
do 
prev=$(($i-1))
HERest -T 1 \
       -C ${workingd}config/config2 \
       -t 250.0 150.0 1000.0 \
       -S ${workingd}scp/train.scp \
       -H ${workingd}models/HMM$prev/macros \
       -H ${workingd}models/HMM$prev/hmmdefs \
       -M ${workingd}models/HMM$i \
       -I ${workingd}mlf/phones1_5sp.mlf \
       ${workingd}list/phonesp.list 
done


# HVite -T 1 -t 250 -H hmm$i/MMF -S ../scp/smalltest.scp -i hmm$i/smalltest2.mlf -w ../gram/bg.lat ../dict/all_dict_no_variation.txt ../list/phone.list ;done
