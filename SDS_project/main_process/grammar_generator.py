'''
Grammar Generator.


                                                                    Written by Hyungwon Yang
                                                                                2016. 05. 20
                                                                                   EMCS Labs
'''

import nltk

from nltk import word_tokenize
from nltk import Nonterminal, nonterminals, Production, CFG
from nltk.parse import RecursiveDescentParser
from nltk.corpus import conll2000


### Generating a Context Free Grammar (CFG).

# Build the grammar for parsing.
def CFG_grammar():
    GOAL_FIND,ENTITY_PLACE = nonterminals('GOAL_FIND,ENTITY_PLACE')
    usr_goal = ENTITY_PLACE
    usr_find = GOAL_FIND
    VP,NP,O = nonterminals('VP,NP,O')

    # Build a CFG based on the symbols that generated above.
    grammar = CFG.fromstring("""
    VP -> GOAL_FIND O ENTITY_PLACE | GOAL_FIND ENTITY_PLACE
    NP -> P ENTITY_PLACE | ENTITY_PLACE
    GOAL_FIND -> 'find'
    GOAL_FIND  -> 'show'
    GOAL_FIND  -> 'tell'
    O -> 'me'
    P -> 'in'
    ENTITY_PLACE -> 'starbucks'
    ENTITY_PLACE -> 'the starbucks'
    ENTITY_PLACE -> 'a starbucks'
    ENTITY_PLACE -> 'coffee bean'
    ENTITY_PLACE -> 'the coffee bean'
    ENTITY_PLACE -> 'a coffee bean'

    """)
    return grammar


### Training corpus for better parsing (POS tagging)
test_sents = conll2000.chunked_sents('test.txt', chunk_types=['NP'])
train_sents = conll2000.chunked_sents('train.txt', chunk_types=['NP'])


class ChunkParser(nltk.ChunkParserI):
    def __init__(self, train_sents):
        train_data = [[(t,c) for w,t,c in nltk.chunk.tree2conlltags(sent)]
                      for sent in train_sents]
        self.tagger = nltk.TrigramTagger(train_data)

    def parse(self, sentence):
        pos_tags = [pos for (word,pos) in sentence]
        tagged_pos_tags = self.tagger.tag(pos_tags)
        chunktags = [chunktag for (pos, chunktag) in tagged_pos_tags]
        conlltags = [(word, pos, chunktag) for ((word,pos),chunktag)
        in zip(sentence, chunktags)]
        return nltk.chunk.conlltags2tree(conlltags)


#
class ConsecutiveNPChunkTagger(nltk.TaggerI):

    def __init__(self, train_sents):
        train_set = []
        for tagged_sent in train_sents:
            untagged_sent = nltk.tag.untag(tagged_sent)
            history = []
            for i, (word, tag) in enumerate(tagged_sent):
                featureset = npchunk_features(untagged_sent, i, history)
                train_set.append( (featureset, tag) )
                history.append(tag)
        self.classifier = nltk.MaxentClassifier.train(train_set, algorithm='megam', trace=0)

    def tag(self, sentence):
        history = []
        for i, word in enumerate(sentence):
            featureset = npchunk_features(sentence, i, history)
            tag = self.classifier.classify(featureset)
            history.append(tag)
        return zip(sentence, history)

class ConsecutiveNPChunker(nltk.ChunkParserI):
    def __init__(self, train_sents):
        tagged_sents = [[((w,t),c) for (w,t,c) in
                         nltk.chunk.tree2conlltags(sent)]
                        for sent in train_sents]
        self.tagger = ConsecutiveNPChunkTagger(tagged_sents)

    def parse(self, sentence):
        tagged_sents = self.tagger.tag(sentence)
        conlltags = [(w,t,c) for ((w,t),c) in tagged_sents]
        return nltk.chunk.conlltags2tree(conlltags)

## npchunk_features needs to be improved for better performance
def npchunk_features(sentence, i, history):
     word, pos = sentence[i]
     if i == 0:
          prevword, prevpos = "<START>", "<START>"
     else:
         prevword, prevpos = sentence[i-1]
     if i == len(sentence)-1:
         nextword, nextpos = "<END>", "<END>"
     else:
         nextword, nextpos = sentence[i+1]
     return {"pos": pos,
             "word": word,
             "prevpos": prevpos,
             "nextpos": nextpos,
             "prevpos+pos": "%s+%s" % (prevpos, pos),
             "pos+nextpos": "%s+%s" % (pos, nextpos),
             "tags-since-dt": tags_since_dt(sentence, i)}

def tags_since_dt(sentence, i):
     tags = set()
     for word, pos in sentence[:i]:
         if pos == 'DT':
             tags = set()
         else:
             tags.add(pos)
     return '+'.join(sorted(tags))

# Tree reconstruction.
def tree_reconstruct(text):

    string_box = []
    final_box = []
    for tree in text:
        tmp_box = []
        if type(tree) == nltk.tree.Tree:
            for node in tree:
                for single in node[::2]:
                    tmp_box.append(single)
            string_box = ' '.join(tmp_box)
            final_box.append(string_box)
        else:
            for node in tree[::2]:
                tmp_box.append(node)
            string_box = ' '.join(tmp_box)
            final_box.append(string_box)

    return final_box
