
import numpy as np

def calrm(ncount, array):
    marry = []
    for x in range(50):
        inputarray = array
        #print(inputarray)
        if ncount % 2 == 1:
            marry.append(np.median(np.sort(np.diff(np.sort(np.random.choice(inputarray, size=ncount, replace=False))))[:-1]))
        else:
            marry.append(np.median(np.sort(np.diff(np.sort(np.random.choice(inputarray, size=ncount, replace=False))))))
    #print(marry)
    return(marry, np.median(marry[:-1]))


with open("mac.ATwithnewcutoff.xls", 'r') as f:
    lines = f.readlines()
    for line in lines:
        methystat = line.strip().split('\t')
        hemiarr = methystat[4].split(',')
        fullarr = methystat[3].split(',')
        hemiarr = np.array([int(x) for x in hemiarr])
        fullarr = np.array([int(x) for x in fullarr])
        fullarr = fullarr[::2]
        fuladjdis = np.sort(np.diff(np.sort(fullarr)))
        fuladjdis = [x for x in fuladjdis]
        allmethy = np.concatenate((hemiarr, fullarr))
        alladjdis = np.sort(np.diff(np.sort(allmethy)))
        alladjdis = [x for x in alladjdis]
        if hemiarr.shape[0] % 2 ==1:
            hemiarr_m = np.median(np.sort(np.diff(np.sort(hemiarr)))[:-1])
        else:
            hemiarr_m = np.median(np.sort(np.diff(np.sort(hemiarr))))
        if np.diff(np.sort(fullarr)).shape[0] % 2 ==1:
            fullarr_m = np.median(np.sort(np.diff(np.sort(fullarr))))
        else:
            fullarr_m = np.median(np.sort(np.diff(np.sort(fullarr)))[:-1])
        (rdarray, allmethy_m) = calrm(hemiarr.shape[0], allmethy)
        (rfarray, fumethy_m) = calrm(fullarr.shape[0], allmethy)
        rdarray = np.sort(rdarray)
        rdarray = [x for x in rdarray]
        rfarray = np.sort(rfarray)
        rfarray = [x for x in rfarray]
        fullpos = [x for x in fullarr]
        #print(methystat[0],"\t",fullarr.shape[0],"\t",methystat[2],"\t",fullpos,"\t",methystat[4],"\t",rdarray,"\t",hemiarr_m,"\t",allmethy_m, "\t", rfarray, "\t", fullarr_m, "\t", fumethy_m)
        ldsum = np.sum(np.array(alladjdis) >=60)+1
        if(np.array(fuladjdis).shape[0] ==2):
            if(np.sum(np.array(fuladjdis) > 60) == 2):
                fulld = 3
            elif(np.sum(np.array(fuladjdis) > 60) ==1):
                fulld = 2
            else:
                fulld = 1
            #d1 = np.sum(np.array(fuladjdis) < 60)
            print(methystat[0],"\t", fullarr.shape[0],"\t", methystat[2],"\t", fullpos,"\t",methystat[4],"\t",fuladjdis,"\t", alladjdis, "\t", fulld, "\t", ldsum)
