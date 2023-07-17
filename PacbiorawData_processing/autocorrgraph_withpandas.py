import numpy as np
import pandas as pd
from statsmodels.tsa.stattools import acf

corr={}
with open('mac.allidencodeforauto.fmt.xls', 'r') as file:
    for line in file:
        row = line.strip().split(",")
        if row[0] not in corr.keys():
            corr[row[0]]=[]
        avalue = row[1:len(row)]
        avalue = [float(x) for x in avalue]
        acorr = acf(avalue, nlags=len(avalue)-1)
        #print(avalue)
        #autos = pd.Series(avalue)
        #print(len(row), autos)
        #for x in np.arange(0, len(avalue)-1):
            #print(x)
        #    autoss = autos.autocorr(lag=x)
        #    print(x, autoss)
        #acorr = [autos.autocorr(lag=int(x)) for x in np.arange(0,len(avalue)-1, 1, dtype=int)]
        #acorr = ccf(avalue[0:len(avalue)],avalue[0:len(avalue)])
        acorr = [float(x) for x in acorr]
        print(row[0],"\t",acorr)


#for key in corr.keys():
#    print(key, corr[key])

