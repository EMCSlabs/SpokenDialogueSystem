'''
Theano voice for SDS


                                                                    Written by Hyungwon Yang
                                                                                2016. 05. 20
                                                                                   EMCS Labs
'''

import random
import time
import langid

############################################# SDS_project ######################################################

def sentence_generation(type):
    if type == 'open':
        alex1 = 'say -v alex Activate the system. Please wait for a moment before the system is stablized.'
        alex2 = 'say -v alex system stablized, activate theona'
        theona1 = 'say -v samantha hello, This is Theona, I am ready to have a nice chatting with you.'
        return alex1, alex2, theona1

    rand_num = random.randint(1,3)
    if type == 'hello':
        if rand_num == 1:
            gretting = 'say hello, howcan I help you'
        elif rand_num == 2:
            gretting = 'say good morning, whatcan I do for you today'
        elif rand_num == 3:
            gretting = 'say hi, please let me know what I have to do for you'

        return gretting

    if type == 'finding':
        finding = 'say finding <place>'
        return finding

    if type == 'searching':
        searching = 'say searching <place>'
        return searching


# NLG format

def NLG_transoformation(type):

    # request type: FIND
    if type == 'find':
        request = 'The closest <place> is located in <address> and the phone number is <phone>'
    # request type: SEARCH
    elif type == 'search':
        request = 'Today''s weather in <location> is <weather>'

    return request

# Detect language and adjust the sentence.
def lang_adjust(text):

    lang_label = langid.classify(text)
    if lang_label[0] == 'ko':
        lang_text = ';say -v yuna ' + text + ';say -v samantha '
    # English does need to be included in adjust function because English is default value.
    # Add more languages if possible.

    return lang_text

