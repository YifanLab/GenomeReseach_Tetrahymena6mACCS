import pandas as pd
import numpy as np

m6aipd = []

with open("breakpointadjdis.acblast.xls", 'r') as f:
    for line in f:
        row = line.strip().split("\t")
        m6aipd.append(int(row[-1]))
bin = np.linspace(0, 5000, 5000, endpoint=False)
s = pd.cut(m6aipd, bins = bin)
scount = s.value_counts()
scount.to_csv('allbreakpointclusizedisacblast.xls', header = False, sep = "\t")
