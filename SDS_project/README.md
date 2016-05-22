# SDS_project (Theona) + Interpreter
                                                                         Hyungwon Yang
                                                                            2016.05.20
                                                                              EMCS lab    

Linux and MacOSX (This script is not tested on Window)
---

Python 3.5
(This script was not tested on the other versions.)


PREREQUEISTE
------------
### SDS_project & Interpreter

- python 3 is required. This package is not running on python 2.
- Download the package and navigate to the SDS_project directory.
- Type '$python3 setup.py install' in the command line. (It only works on python3)


DIRECTION
---
### SDS_project


### Interpreter
1. Due to the tts issue, this program is running on mac.
    - voice : samantha
    - To install samantha voice..
        - Go System preference.
        - Click Dictation & Speech.
        - In the text to speech section, click customize.. or samantha in system voice bar.
        - Choose samantha and install the voice.
2. Two options are provided. 'slow' and 'fast'
    - slow(default): type '$python3 interpreter.py' or '$python3 interpreter.py slow'
                   in the terminal command line. It is tutorial mode which shows
                   all the procedures of interpretation.
    - fast: tyep '$python3 interpreter.py fast' then it will skip all the tutorial lines
          and activate fast translating mode.

CONTENTS
---
Spoken Dialogue System (SDS) and Interpreting System.


CONTACTS
---

Hosung Nam / hnam@korea.ac.kr

Hyungwon Yang / hyung8758@gmail.com


VERSION HISTORY
---
1.0. (2016.05.20)
1. It has three main scripts.
- simple_sds.py: simple sds tutorial that shows users of the procedures of the system.
- Theona.py: This is main script for sds project. I will focuse on this script.
- interpreter.py: Just for fun, this is basic interpreting system.


