# 2016-04-22 INSTALLATION OF KALDI
# This script helps you install Kaldi and test it out with example data

#--------- cloning the GitHub repository of Kaldi
cd
git clone https://github.com/kaldi-asr/kaldi.git

#--------- install files under kaldi/tools
# change directory
cd kaldi/tools/

# to see if there are any system-level installations or modifications you need to do.
extras/check_dependencies.sh

# install important prerequisites
# 1. OpenFst
# 2. IRSTLM
# 3. sph2pipe
# 4. sclite
# 5. ATLAS
# 6. CLAPACK
make
# (check the number of CPUs of your computer with sysctl -n hw.ncpu and do a parallel build)
# (e.g. you have 4 CPUs then, run the line below)
# make -j 4 

# install a language modeling toolkit IRSTLM
extras/install_irstlm.sh
source tools/env.sh 


#--------- install files under kaldi/src
cd ../src/
./configure
make depend
make
# make depend -j 4
# make -j 4


#--------- testing Kaldi out with the YESNO example recipe
cd ../egs/yesno/s5
source ./path.sh
./run.sh
