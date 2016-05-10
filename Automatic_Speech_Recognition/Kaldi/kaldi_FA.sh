############# Forced Alignment #############
# Created by Yeonjung Hong 2016-04-27

#------ parameter settings
# which acoustic model you're going to use?
model="tri2a"
# number of jobs/speakers used in MFCC feature extraction
append="_ali"
nj="2"

#------ put files in data/train with new transcript and wav files
cd ~/kaldi/egs/mycorpus/data
mkdir alignme
echo 'Create (1)text (2)segements (3)wav.scp (4)utt2spk (5)spk2utt and put them in mycorpus/data/alignme'
read -rp $'Are you sure you followed the instruction above? (y/n) : '
#------ extract MFCC features
cd ~/kaldi/egs/mycorpus
mfccdir=mfcc
train_cmd="run.pl"
decode_cmd="run.pl —mem 2G"

for x in data/alignme; do
steps/make_mfcc.sh --cmd "$train_cmd" --nj $nj $x exp/make_mfcc/$x $mfccdir
utils/fix_data_dir.sh data/alignme
steps/compute_cmvn_stats.sh $x exp/make_mfcc/$x $mfccdir
utils/fix_data_dir.sh data/alignme
done

#------ align data

steps/align_si.sh --nj $nj --cmd "$train_cmd" data/alignme data/lang exp/$model  exp/$model$append || exit1;

#------ obtain CTM output from alignment files

for i in exp/$model$append/ali.*gz;
do src/bin/ali-to-phones --ctm-output exp/$model/final.mdl ark:"gunzip -c $i|" -> ${i%.gz}.ctm;

done;

#------ concatenate CTM file
cd ~/kaldi/egs/mycorpus/exp/$model$append
cat *.ctm > merged_alignment.txt

#------ convert time marks and phone IDs

# move the directory to 'mycorpus'
cd ~/kaldi/egs/mycorpus
python id2phone.py


#------ split final_ali.txt by file
python splitAlignments.py

#------ create TextGrid
#/Applications/Praat.app/Contents/MacOS/Praat --run createtextgrid.praat








