#!/bin/bash

workingd=$1
INC=$2
PRED=${workingd}models/HMM$(($INC-1)).2
TRGT=${workingd}models/HMM$INC.0
mixnum=$INC
EDITSCRIPT=${workingd}config/mix$INC.hed

### Edit script making
if ! test -f $EDITSCRIPT; then
	echo "SH" > $EDITSCRIPT
	echo "MU $INC {*.state[2-4].mix}" >> $EDITSCRIPT
    echo "SH" >> $EDITSCRIPT
fi
###

if ! test -d $TRGT ; then
	mkdir $TRGT
fi

HHEd -T 1 \
	-H ${PRED}/macros \
	-H ${PRED}/hmmdefs \
	-M $TRGT \
	$EDITSCRIPT \
	${workingd}list/phonesp.list 


