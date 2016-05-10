#!/bin/bash
HLStats -T 1 -o -b $bigramstat $word_list $word_mlf
HBuild -T 1 -n $bigramstat $word_list $bigram_lattice
