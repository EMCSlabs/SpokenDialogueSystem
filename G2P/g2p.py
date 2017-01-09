# -*- coding: utf-8 -*-
'''
g2p.py
~~~~~~~~~~

This script converts Korean graphemes to romanized phones and then to pronunciation.

    (1) graph2phone: convert Korean graphemes to romanized phones
    (2) phone2prono: convert romanized phones to pronunciation
    (3) graph2phone: convert Korean graphemes to pronunciation

Usage:  $ python 'g2p.py' '국어는 즐겁다'

Yejin Cho (scarletcho@gmail.com)
Jaegu Kang (jaekoo.jk@gmail.com)
Hyungwon Yang (hyung8758@gmail.com)
Yeonjung Hong (yvonne.yj.hong@gmail.com)

Created: 2016-08-11
Last updated: 2017-01-10 Yejin Cho
'''

import datetime as dt
import re
import math
import sys

reload(sys)
sys.setdefaultencoding('utf-8')


def readfileUTF8(fname):
    f = open(fname, 'r')
    corpus = []

    while True:
        line = f.readline()
        line = unicode(line.encode("utf-8"))
        line = re.sub(u'\n', u'', line)
        if line != u'':
            corpus.append(line)
        if not line: break

    f.close()
    return corpus


def writefile(body, fname):
    out = open(fname, 'w')
    for line in body:
        out.write('{}\n'.format(line))
    out.close()


def readRules(rule_book):
    f = open(rule_book, 'rb')

    rule_in = []
    rule_out = []

    while True:
        line = f.readline()
        line = unicode(line.encode("utf-8"))
        line = re.sub(u'\n', u'', line)

        if line != u'':
            IOlist = line.split('\t')
            rule_in.append(IOlist[0])
            if IOlist[1]:
                rule_out.append(IOlist[1])
            else:   # If output is empty (i.e. deletion rule)
                rule_out.append(u'')
        if not line: break
    f.close()

    return rule_in, rule_out


def isHangul(charint):
    hangul_init = 44032
    hangul_fin = 55203
    return charint >= hangul_init and charint <= hangul_fin


def checkCharType(var_list):
    #  1: whitespace
    #  0: hangul
    # -1: non-hangul
    checked = []
    for i in range(len(var_list)):
        if var_list[i] == 32:   # whitespace
            checked.append(1)
        elif isHangul(var_list[i]): # Hangul character
            checked.append(0)
        else:   # Non-hangul character
            checked.append(-1)
    return checked


def graph2phone(graphs):
    # Encode graphemes as utf8
    graphs = graphs.decode('utf8')
    integers = []
    for i in range(len(graphs)):
        integers.append(ord(graphs[i]))

    # Romanization (according to Korean Spontaneous Speech corpus; 성인자유발화코퍼스)
    phones = ''
    ONS = ['k0', 'kk', 'nn', 't0', 'tt', 'rr', 'mm', 'p0', 'pp',
           's0', 'ss', 'oh', 'c0', 'cc', 'ch', 'kh', 'th', 'ph', 'hh']
    NUC = ['aa', 'qq', 'ya', 'yq', 'vv', 'ee', 'yv', 'ye', 'oo', 'wa',
           'wq', 'wo', 'yo', 'uu', 'wv', 'we', 'wi', 'yu', 'xx', 'xi', 'ii']
    COD = ['', 'kf', 'kk', 'ks', 'nf', 'nc', 'nh', 'tf',
           'll', 'lk', 'lm', 'lb', 'ls', 'lt', 'lp', 'lh',
           'mf', 'pf', 'ps', 's0', 'ss', 'oh', 'c0', 'ch',
           'kh', 'th', 'ph', 'hh']

    # Pronunciation
    idx = checkCharType(integers)
    iElement = 0
    while iElement < len(integers):
        if idx[iElement] == 0:  # not space characters
            base = 44032
            df = int(integers[iElement]) - base
            iONS = int(math.floor(df / 588)) + 1
            iNUC = int(math.floor((df % 588) / 28)) + 1
            iCOD = int((df % 588) % 28) + 1

            s1 = '-' + ONS[iONS - 1]  # onset
            s2 = NUC[iNUC - 1]  # nucleus

            if COD[iCOD - 1]:  # coda
                s3 = COD[iCOD - 1]
            else:
                s3 = ''
            tmp = s1 + s2 + s3
            phones = phones + tmp

        elif idx[iElement] == 1:  # space character
            tmp = ' '
            phones = phones + tmp

        phones = re.sub('-(oh)', '-', phones)
        iElement += 1
        tmp = ''

    # 초성 이응 삭제
    phones = re.sub('^oh', '', phones)
    phones = re.sub('-(oh)', '', phones)

    # 받침 이응 'ng'으로 처리 (Velar nasal in coda position)
    phones = re.sub('oh-', 'ng-', phones)
    phones = re.sub('oh$', 'ng', phones)
    phones = re.sub('oh ', 'ng ', phones)

    # Remove all characters except Hangul and syllable delimiter (hyphen; '-')
    phones = re.sub('(\W+)\-', '\\1', phones)
    phones = re.sub('\W+$', '', phones)
    phones = re.sub('^\-', '', phones)
    return phones


def phone2prono(phones, rule_in, rule_out):
    # Apply g2p rules
    for pattern, replacement in zip(rule_in, rule_out):
        # print pattern
        phones = re.sub(pattern, replacement, phones)
        prono = phones
    return prono


def addPhoneBoundary(phones):
    # Add a comma (,) after every second alphabets to mark phone boundaries
    ipos = 0
    newphones = ''
    while ipos + 2 <= len(phones):
        if phones[ipos] == u'-':
            newphones = newphones + phones[ipos]
            ipos += 1
        elif phones[ipos] == u' ':
            ipos += 1
            
        newphones = newphones + phones[ipos] + phones[ipos+1] + u','
        ipos += 2

    # Remove final comma
    if newphones[-1] == u',':
        newphones = newphones[0:-1]

    return newphones


def addSpace(phones):
    ipos = 0
    newphones = ''
    while ipos < len(phones):
        if ipos == 0:
            newphones = newphones + phones[ipos] + phones[ipos + 1]
        else:
            newphones = newphones + ' ' + phones[ipos] + phones[ipos + 1]
        ipos += 2

    return newphones


def testG2P(rulebook, testset):
    [testin, testout] = readRules(testset)
    cnt = 0
    body = []
    for idx in range(0, len(testin)):
        item_in = testin[idx]
        item_out = testout[idx]
        ans = graph2phone(item_out)
        ans = re.sub(u'-', u'', ans)
        ans = addSpace(ans)

        [rule_in, rule_out] = readRules(rulebook)
        pred = graph2prono(item_in, rule_in, rule_out)

        if pred != ans:
            print('G2P ERROR:  [result] ' + pred + '\t[ans] ' + item_in + ' [' + item_out + '] ' + ans)
            cnt += 1
        else:
            body.append('[result] ' + pred + '\t[ans] ' + item_in + ' [' + item_out + '] ' + ans)

    print('Total error item #: ' + str(cnt))
    writefile(body,'good.txt')


def graph2prono(graphs, rule_in, rule_out):
    romanized = graph2phone(graphs)
    romanized_bd = addPhoneBoundary(romanized)
    pronunciation = phone2prono(romanized_bd, rule_in, rule_out)

    pronunciation = re.sub(u',', u' ', pronunciation)
    pronunciation = re.sub(u' $', u'', pronunciation)

    return pronunciation

# ----------------------------------------------------------------------
# [ G2P Test ]
# beg = dt.datetime.now()

# [rule_in, rule_out] = readRules('rulebook_reduced.txt')
# testG2P('rulebook_reduced.txt', 'testset.txt')

# end = dt.datetime.now()
# print('Total time: ')
# print(end - beg)
# ----------------------------------------------------------------------


# Usage:
graph = sys.argv[1]

rulebook_path = 'rulebook.txt'
[rule_in, rule_out] = readRules(rulebook_path)

prono = graph2prono(unicode(graph), rule_in, rule_out)
print(prono)


