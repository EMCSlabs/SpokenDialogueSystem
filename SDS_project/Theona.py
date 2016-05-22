'''
Theona is SDS system.
It is building on...
Please find simple_sds.py in SDS_tutorial folder
and understand whole SDS system briefly.
simple.sds script will help you to understand the algorithms.

                                                              Hyungwon Yang
                                                                 2015.05.10
                                                                   EMCS lab
Spoken Dialogue System (SDS)


'''


import re
import speech_recognition as sr
import requests
import nltk

from nltk import word_tokenize
from nltk import Nonterminal, nonterminals, Production, CFG
from nltk.parse import RecursiveDescentParser
from nltk.corpus import conll2000
from bs4 import BeautifulSoup

from main_process.grammar_generator import *
from sub_process.dialogues import *
from sub_process.Theona_voice import *
from sub_process.util import *

# Check list.

if internet_check() is False:
    raise ConnectionError

def Theona():

    intro1, intro2, intro3 = sentence_generation('open')
    audio_play('boost.wav')
    os.system(intro1)

    train_sents = conll2000.chunked_sents('train.txt', chunk_types=['NP'])
    print('Training data... It will take 2-4 minutes.')
    chunker = ConsecutiveNPChunker(train_sents)
    os.system(intro2)

    # Theona Introduction
    audio_play('start_up.wav')
    os.system(intro3)

    # Step1. ASR
    # Use recognizer to record the speech.
    recorder = sr.Recognizer()
    starting = sentence_generation('hello')
    with sr.Microphone() as mike:
        print('Hello. Please speaking.')
        audio_play('pong.wav')
        os.system(starting)
        my_sound = recorder.listen(mike)

    print('Processing...')

    # Speech signal to text. Supported by google Speech api: Internet needs to be connected.
    tmp_words = recorder.recognize_google(my_sound)
    words = str(tmp_words)

    # test printing...
    print(words)

    # Step2. SLU
    # 1. find the specific places to users.
    #words = 'show me starbucks'

    # Tokenize the sentence.
    tokenized = word_tokenize(words)

    # Parsing the sentence to find out goal and entity clearly.
    pos_tagged = nltk.pos_tag(tokenized)
    chunk_words = chunker.parse(pos_tagged)
    reorder_words = tree_reconstruct(chunk_words)

    # Build the grammar for parsing.
    GOAL_FIND,ENTITY_PLACE = nonterminals('GOAL_FIND,ENTITY_PLACE')
    usr_goal = ENTITY_PLACE
    usr_find = GOAL_FIND
    VP,NP,O = nonterminals('VP,NP,O')

    grammar = CFG_grammar()
    rd_parser = RecursiveDescentParser(grammar)

    # Parsing the sentence.
    parsed_words = []
    for parsing in rd_parser.parse(reorder_words):
        print(parsing)

    # Find GOAL and ENTITY
    for detect in parsing:
        if detect.label() == 'GOAL_FIND':
            usr_goal = detect.leaves()[0]
        if detect.label() == 'ENTITY_PLACE':
            usr_place = detect.leaves()[0]

    finding = sentence_generation('finding')
    finding = re.sub('<place>',usr_place,finding)
    audio_play('tone.wav')
    os.system(finding)

    # 2. Provide weather information to users.

    # Step3. DM
    # Collect information from the internet.
    # Location
    google_url = "https://www.google.co.kr/?gfe_rd=cr&ei=8YoTV-OdF8WL8AWGp5DgDg&gws_rd=ssl#newwindow=1&q="
    daum_url = 'http://search.daum.net/search?w=tot&DA=YZR&t__nil_searchbox=btn&sug=&sugo=&sq=&o=&q='

    # Connect to the internet to proceed the users' request: goal and entity.
    if usr_goal == 'find':
        # Searching in Daum.
        usr_request_url = daum_url + usr_place + '&tltm=1'
        request = requests.get(usr_request_url)
        soup = BeautifulSoup(request.content,'html.parser')

        # Searching in Google.
        #usr_request_url = google_url + usr_place
        #request = requests.get(usr_request_url)
        #soup = BeautifulSoup(request)

    # Collect information.
    # Find the closest 5 places around the location in which you start to request.
    all_data = soup.find_all('div',{'class','cont_place'})

    first_data = all_data[0]

    # Address
    address_info = all_data[0].find_all('a',{'class','more_address'})[0].text
    # Phone Number
    phone_info = all_data[0].find_all('span',{'class','f_url'})[0].text
    # Location (map)
    map_info = all_data[0].find('a').get('href')

    # Weather



    # Step4. NLG
    # Generate an appropriate sentence.
    answer_text = NLG_transoformation('find')

    # Adjust the words if it is Korean.
    address_info = lang_adjust(address_info)

    # Substitude the markers to proper words
    answer_text = re.sub('<place>',usr_place,answer_text)
    answer_text = re.sub('<address>',address_info,answer_text)
    answer_text = re.sub('<phone>',phone_info,answer_text)

    # Step5. TTS
    audio_play('tone.wav')
    os.system('say ' + answer_text)



if __name__ == '__main__':
    Theona()