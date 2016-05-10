<Contents>
* To run shell script, type in terminal as follows: $sh scriptname.sh
* Locate id2phone.py, splitAlignments.py under ~/mycorpus
* Prepare the following files for your coprus:
	text, segments, wav.scp, utt2spk, spk2utt



1. INSTALLATION
	<Install Kaldi and Test out with YESNO corpus>
		installKaldi.sh

2. ACOUSTIC MODELING
	<Train Acoustic Model>
		kaldi_filePrepTrain.sh

3. FORCED ALIGNMENT
	<Perform ForcedAlignment>
		kaldi_FA.sh

	<Text Treatment>
		id2phone.py
		splitAlignments.py

	<TextGrid Creation>
		createtextgrid.praat
		=> Run this script in praat, not in terminal.