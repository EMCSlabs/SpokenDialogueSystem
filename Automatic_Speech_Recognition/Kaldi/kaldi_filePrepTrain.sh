# 2016-04-22 TRAIN ACOUSTIC MODELS
# This script creates necessary files and train acoustic models

# N.B.
# -- nj option for e.g. make_mfcc.sh should be specified as speaker number: 
# Example:
# --nj 2
# if your data is gathered from 2 speakers


#######################################
####  (2) Prepare necessary files  ####
#######################################


cd kaldi/egs
mkdir mycorpus

#--------- Make soft links to the following directories
cd mycorpus
ln -s ../wsj/s5/steps .
ln -s ../wsj/s5/utils .
ln -s ../../src .
cp ../wsj/s5/path.sh .
# edit directory in the first line of path.sh 
ed -s path.sh <<< $'1d\nw'
ed -s path.sh <<< $'Hexport KALDI_ROOT=`pwd`/../../\nw'
echo -e 'export KALDI_ROOT=`pwd`/../../'\n > path.sh

echo 'soft link has created'

#--------- Create the following directories in mycorpus: 
# exp, conf, data
cd mycorpus
mkdir exp
mkdir conf
mkdir data

cd data
mkdir train
mkdir lang
mkdir local

cd local
mkdir lang
echo 'Directories are created'

### Necessary files ##

# In data/train

# 1) text (prepared)
# 2) words.txt
# 3) segments (prepared)
# 4) wav.scp (prepared)
# 5) utt2spk (prepared)
# 6) spk2utt

# In data/local/lang

# 7) nonsilence_phones.txt
# 8) silence_phones.txt
# 9) optional_silence.txt
# 10) lexicon.txt (prepared)

#--------- Create necessary files

# 1) text (prepared)
# File format: utt_id    WORD1 WORD2 WORD3 WORD4 ...
# Example:
#
# 110236_20091006_82330_F_0001 I'M WORRIED ABOUT THAT
# 110236_20091006_82330_F_0002 AT LEAST NOW WE HAVE THE BENEFIT
# 110236_20091006_82330_F_0003 DID YOU EVER GO ON STRIKE
# ...
# 120958_20100126_97016_M_0285 SOMETIMES LESS IS BETTER
# 120958_20100126_97016_M_0286 YOU MUST LOVE TO COOK

# 2) words.txt
cd ../../
cut -d ' ' -f 2- ./data/train/text | tr ' ' '\n' | sort -u > ./data/train/words.txt
# remove the first blank line
ed -s ./data/train/words.txt <<< $'1d\nw'
echo 'words.txt ... created'
# remove the FIRST BLANK LINE in words.txt if exists

# 3) segments (prepared)
# File format: utt_id    file_id    start_time    end_time
# utt_id = utterance ID
# file_id = file ID
# start_time = start time in seconds
# end_time = end time in seconds

# Example:
# 110236_20091006_82330_F_001 110236_20091006_82330_F 0.0 3.44
# 110236_20091006_82330_F_002 110236_20091006_82330_F 4.60 8.54
# 110236_20091006_82330_F_003 110236_20091006_82330_F 9.45 12.05
# 110236_20091006_82330_F_004 110236_20091006_82330_F 13.29 16.13
# 110236_20091006_82330_F_005 110236_20091006_82330_F 17.27 20.36
# 110236_20091006_82330_F_006 110236_20091006_82330_F 22.06 25.46

# 4) wav.scp (prepared)
# --> you should change wav file directories in wav.scp
# File format: file_id    path/file
# Example:
# 110236_20091006_82330_F path/110236_20091006_82330_F.wav
# 111138_20091215_82636_F path/111138_20091215_82636_F.wav
# 111138_20091217_82636_F path/111138_20091217_82636_F.wav

# 5) utt2spk (prepared)
# File format: utt_id    spkr
# Example:
# 110236_20091006_82330_F_0001 110236
# 110236_20091006_82330_F_0002 110236
# 110236_20091006_82330_F_0003 110236
# 110236_20091006_82330_F_0004 110236

# 6) spk2utt
cd mycorpus
utils/fix_data_dir.sh data/train
echo 'spk2utt.txt ... created'

# 7) nonsilence_phones.txt
cut -d ' ' -f 2- ./data/local/lang/lexicon.txt | tr ' ' '\n' | sort -u > ./data/local/lang/nonsilence_phones.txt
# remove the first blank line
ed -s ./data/local/lang/nonsilence_phones.txt <<< $'1d\nw'
echo 'nonsilence_phones.txt ... created'

# 8) silence_phones.txt
echo -e "<SIL>\n<oov>" > ./data/local/lang/silence_phones.txt
echo 'silence_phones.txt'

# 9) optional_silence.txt
echo '<SIL>' > ./data/local/lang/optional_silence.txt
echo 'optional_silence.txt'

# 10) lexicon.txt (prepared)
# Example:
# WORD        W ER D
# LEXICON     L EH K S IH K AH N

# For the first line in lexicon.txt, you should add <oov> <oov>
# Type as follows to add <oov> <oov>:
ed -s ./data/local/lang/lexicon.txt <<< $'1i\n<oov> <oov>\n.\nwq'
# remove the first blank line
# ed -s ./data/local/lang/lexicon.txt <<< $'1d\nw'


#######################################
####   (3) Train acoustic models   ####
#######################################


#--------- Set the parallelization wrapper
train_cmd="run.pl"
decode_cmd="run.pl --mem 2G"

#--------- Create mfcc.conf file in conf folder
echo -e '--use-energy=false\n--sample-frequency=16000' >> ./conf/mfcc.conf

#--------- Create files for data/lang
utils/prepare_lang.sh ./data/local/lang '<oov>' ./data/local/lang ./data/lang

#--------- Extract MFCC features
mfccdir=mfcc
for x in data/train; do
steps/make_mfcc.sh --cmd "$train_cmd" --nj 2 $x exp/make_mfcc/$x $mfccdir
utils/fix_data_dir.sh data/train
steps/compute_cmvn_stats.sh $x exp/make_mfcc/$x $mfccdir
utils/fix_data_dir.sh data/train
done
echo 'MFCCs have been extracted'

#--------- Monophone training and alignment
# Specify total number of wav files (1859)
utils/subset_data_dir.sh --first data/train 1859 data/train_10k

# Train monophones
train_cmd="run.pl"
decode_cmd="run.pl --mem 2G"

steps/train_mono.sh --boost-silence 1.25 --nj 2 --cmd "$train_cmd" \
data/train_10k data/lang exp/mono_10k
echo 'Monophones ... trained'

# Align monophones
steps/align_si.sh --boost-silence 1.25 --nj 2 --cmd "$train_cmd" \
data/train data/lang exp/mono_10k exp/mono_ali || exit 1;
echo 'Align monophones ... trained'

#--------- Triphone training and alignment
steps/train_deltas.sh --boost-silence 1.25 --cmd "$train_cmd" \
2000 10000 data/train data/lang exp/mono_ali exp/tri1 || exit 1;

# Align delta-based triphones
steps/align_si.sh --nj 2 --cmd "$train_cmd" \
data/train data/lang exp/tri1 exp/tri1_ali || exit 1;

# Train delta + delta-delta triphones
steps/train_deltas.sh --cmd "$train_cmd" \
2500 15000 data/train data/lang exp/tri1_ali exp/tri2a || exit 1;

# Align delta + delta-delta triphones
steps/align_si.sh --nj 2 --cmd "$train_cmd" \
--use-graphs true data/train data/lang exp/tri2a exp/tri2a_ali || exit 1;

# Train LDA-MLLT triphones
steps/train_lda_mllt.sh --cmd "$train_cmd" \
3500 20000 data/train data/lang exp/tri2a_ali exp/tri3a || exit 1;

# Align LDA-MLLT triphones with FMLLR
steps/align_fmllr.sh --nj 2 --cmd "$train_cmd" \
data/train data/lang exp/tri3a exp/tri3a_ali || exit 1;

# Train SAT triphones
steps/train_sat.sh --cmd "$train_cmd" \
4200 40000 data/train data/lang exp/tri3a_ali exp/tri4a || exit 1;

# Align SAT triphones with FMLLR
steps/align_fmllr.sh --nj 2 --cmd "$train_cmd" \
data/train data/lang exp/tri4a exp/tri4a_ali || exit 1;

