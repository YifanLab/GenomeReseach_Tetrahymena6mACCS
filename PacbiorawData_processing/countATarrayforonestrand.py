import pysam
import os.path
import uuid
import subprocess
import queue
import threading
import argparse
import os
import re
import statistics
from Bio import SeqIO
import pandas as pd
import numpy as np


m6aipd_Ax = []
m6aipd_AA = []
m6aipd_AT = []
m6aipd_AC = []
m6aipd_AG = []

def opencsv(file):
    with open(file, 'r') as f:
        for line in f:
            row = line.strip().split('\t')
            #m6aipd_Ax.append(float(row[-3]))
            #if(row[-1] == 'AA'):
                #m6aipd_AA.append(float(row[-3]))
            if(row[-1] == 'AT'):
                m6aipd_AT.append(float(row[-2]))
            #if(row[-1] == 'AC'):
                #m6aipd_AC.append(float(row[-3]))
            #if(row[-1] == 'AG'):
                #m6aipd_AG.append(float(row[-3]))



def macount(ipdall, ipdout):
    ipdall = np.array(ipdall)
    ipdall = np.log2(ipdall[ipdall !=  0])
    bin = np.linspace(-5, 5, 200, endpoint=False)
    s = pd.cut(ipdall, bins=bin)
    scount = s.value_counts()
    scount.to_csv(ipdout, header = False, sep="\t")


opencsv("mac.ribo_WwithCgt3.03.csv")
#macount(m6aipd_Ax, 'macribo.ax_ipd.csv')
#macount(m6aipd_AA, 'macribo.aa_ipd.csv')
macount(m6aipd_AT, 'macribo.Wstrand_ipd.csv')
#macount(m6aipd_AC, 'macribo.ac_ipd.csv')
#macount(m6aipd_AG, 'macribo.ag_ipd.csv')
