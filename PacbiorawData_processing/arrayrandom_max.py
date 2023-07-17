
import numpy as np

def calrm(ncount, array):
    marry = []
    for x in range(999):
        inputarray = array
        marry.append(np.amax(np.sort(np.diff(np.sort(np.random.choice(inputarray, size=ncount, replace=False))))))
    #print(marry)
    return(marry, np.median(marry[:-1]))


with open("mac.fullandhemi_count.xls", 'r') as f:
    lines = f.readlines()
    for line in lines:
        methystat = line.strip().split('\t')
        hemiarr = methystat[4].split(',')
        fullarr = methystat[3].split(',')
        hemiarr = np.array([int(x) for x in hemiarr])
        fullarr = np.array([int(x) for x in fullarr])
        #fullarr = fullarr[::2]
        #print(hemiarr)
        allmethy = np.concatenate((hemiarr, fullarr))
        #if hemiarr.shape[0] % 2 ==1:
        #hemiarr_m = np.maximum(np.sort(np.diff(np.sort(hemiarr)))[:-1])
        #else.
        #print(hemiarr)
        hemiarr_m = np.amax(np.sort(np.diff(np.sort(hemiarr))))
        #if np.diff(np.sort(fullarr)).shape[0] % 2 ==1:
        fullarr_m = np.amax(np.sort(np.diff(np.sort(fullarr))))
        #else:
        #fullarr_m = np.median(np.sort(np.diff(np.sort(fullarr)))[:-1])
        (rdarray, allmethy_m) = calrm(hemiarr.shape[0], allmethy)
        (rfarray, fumethy_m) = calrm(fullarr.shape[0], allmethy)
        fullgt = np.sum(np.array(rfarray) > fullarr_m)
        fullgt_p = (np.array(rfarray).shape[0]-fullgt)/np.array(rfarray).shape[0]
        hemigt = np.sum(np.array(rdarray) > hemiarr_m)
        hemigt_p = (np.array(rdarray).shape[0] - hemigt)/np.array(rdarray).shape[0]
        rdarray = np.sort(rdarray)
        rdarray = [x for x in rdarray]
        rfarray = np.sort(rfarray)
        rfarray = [x for x in rfarray]
        fullpos = [x for x in fullarr]
        print(methystat[0],"\t",fullarr.shape[0],"\t",methystat[2],"\t",fullpos,"\t",methystat[4],"\t",rdarray,"\t",hemiarr_m,"\t",allmethy_m,"\t", hemigt_p, "\t", rfarray, "\t", fullarr_m, "\t", fumethy_m, "\t", fullgt_p)
