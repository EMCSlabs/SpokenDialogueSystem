# -*- coding: utf-8 -*-
"""
Created by Yeonjung Hong 2016-04-26

"""

model2use = "tri2a_alignme"


#%%
import os
cwd = os.getcwd() #~/mycorpus
ph = cwd + "/data/lang/phones.txt"
seg = cwd + "/data/alignme/segments"
ctm_origin = cwd + "/exp/" + model2use + "/merged_alignment.txt"
ctm_final = cwd + "/exp/" + model2use + "/final_ali2.txt"
#%%
# read the three files required
phones = []
with open(ph) as a:
    data = a.readlines()
    for line in data:
        phones.append(line.split())
        
segments = [] 
with open(seg) as b:
    data = b.readlines()
    for line in data:
        segments.append(line.split())

ctm = []       
with open(ctm_origin) as c:
    data = c.readlines()
    for line in data:
        ctm.append(line.split())
        
       
#%%
ctm_new = []
for k in phones:
    for i in ctm:
        if i[4] == k[1]:
            new = i + list([k[0]]) # merge phones and ctm by phone_id
            ctm_new.append(new)
ctm_new2 = []
for n in segments:
    for m in ctm_new:
        if n[0] == m[0]:
            # utt_id, file_id, phone_id, utt_num, start_ph, dur_ph, phone, start_utt, end_utt, start_real, end_real
            start_real = str(float(n[2]) + float(m[2]))
            end_real = str(float(start_real) + float(m[3]))
            new = [n[0],n[1],m[4],m[1],m[2],m[3],m[5],n[2],n[3],start_real,end_real]
            ctm_new2.append(new)

#%% write a text file "final_ali.txt"
with open (ctm_final,"w")as f:
    f.writelines('\t'.join(i) + '\n' for i in ctm_new2)
#%%
print 'final_ali.txt is sucessfully created'            