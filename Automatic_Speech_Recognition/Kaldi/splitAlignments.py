# -*- coding: utf-8 -*-
"""
Created by Yeonjung Hong 2016-04-27

"""
model2use = "tri2a_ali"

#%%
import sys,os
results=[]



cwd = os.getcwd()
cpath = cwd+"/exp/"+model2use+"/"
flist = []
with open(cpath + "final_ali2.txt") as f:
        for line in f:
            columns=line.split("\t")
            if columns[1] not in flist:
                flist.append(columns[1])
                #name = name of first text file in final_ali.txt
                name = str(flist[0])
                #name_fin = name of final text file in final_ali.txt
                name_fin = str(flist[-1])
#%%
# create a folder "FA"
if not os.path.exists(cpath+"FA"):
    os.makedirs(cpath+"FA")

# split list by file and write a text file for each 
try:
    with open(cpath + "final_ali2.txt") as f:
        for line in f:
            columns=line.split("\t")
            name_prev = name
            name = columns[1]
            if (name_prev != name):
                try:   
                    with open(cpath+"FA/"+name_prev+".txt",'w') as fwrite:
                        fwrite.write('utt_id\tfile_id\tphone_id\tutt_num\tstart_ph_inutt\tdur_ph\tphone\tstart_utt\tend_utt\tstart_ph\tend_ph')
                        fwrite.writelines('\n'+i for i in results)
                #print name
                except Exception, e:
                    print "Failed to write file",e
                    sys.exit(2)
                del results[:]
                results.append(line[0:-1])
            else:
                results.append(line[0:-1])
except Exception, e:
    print "Failed to read file",e
    sys.exit(1)
# this prints out the last textfile (nothing following it to compare with)
try:
    with open(cpath+"FA/"+name_prev+".txt",'w') as fwrite:
        fwrite.write('utt_id\tfile_id\tphone_id\tutt_num\tstart_ph\tdur_ph\tphone\tstart_utt\tend_utt\tstart_real\tend_real')
        fwrite.writelines('\n'+i for i in results)
                #print name
except Exception, e:
    print "Failed to write file",e
    sys.exit(2)
#%%
print 'splitting final_ali.txt by file is done'            