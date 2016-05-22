'''
utils for asr and interpreter scripts.


                                                                    Written by Hyungwon Yang
                                                                                2016. 05. 02
                                                                                   EMCS Labs
'''

import requests
import os
import re
import pyaudio
import wave
import time

from sub_process.dialogues import language_form


# Internet connection check.
def internet_check():

    try:
        requests.get("http://www.google.com", timeout=3)
    except IOError:
        print('\n Internet is not connected. Please connect the internet first.')
        os.system('say Internet is not connected. Please check the internet connection and try again.')
        return False

def lang_check(sentence):
    ref_dict = language_form()
    lang_list = list(ref_dict.keys())
    box,tmp = [],[]
    for line in lang_list:
        tmp = re.findall(line,sentence)
        if tmp:
            box.append(tmp[0])
    return box

def audio_play(song):

    dir_path = os.path.abspath('source')
    name = os.path.join(dir_path,song)
    chunk = 1024
    wf = wave.open(name, 'rb')
    p = pyaudio.PyAudio()

    stream = p.open(
        format=p.get_format_from_width(wf.getsampwidth()),
        channels=wf.getnchannels(),
        rate=wf.getframerate(),
        output=True)
    data = wf.readframes(chunk)

    while len(data) > 0:
        stream.write(data)
        data = wf.readframes(chunk)

    stream.close()
    p.terminate()
