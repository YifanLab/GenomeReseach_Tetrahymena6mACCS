import pysam
import os.path
import uuid
import subprocess
import queue
import threading
import argparse



###multithreding##
class MyThread(threading.Thread):
	
	def __init__(self, queue):
		threading.Thread.__init__(self)
		self.queue = queue
		self.start()
	
	def run(self):
		while True:
			try:
				cmd = self.queue.get()
				subprocess.run(cmd, shell=True)
				self.queue.task_done()
			except Exception as e:
				break
			if self.queue.empty():
				break

class MyThreadPool():
	
	def __init__(self, queue, size):
		self.queue = queue
		self.pool = []
		for i in range(size):
			self.pool.append(MyThread(queue))
	
	def joinAll(self):
		for thd in self.pool:
			if thd.is_alive():
				thd.join()



##Pacbio pipeline##

class Pacbio:
	def __init__(self, bamfile):
		#self._genome = genome
		self._bam = bamfile
		self._outdir = str(uuid.uuid1())
		self._sortbam = os.path.join(self._outdir, os.path.splitext(self._bam)[0]+"sort.bam")
		self._hifibam = os.path.join(self._outdir, 'subread.hifi.bam')
		self._hififa = os.path.join(self._outdir, 'ccs2genome')
		self._refdir = os.path.join(self._outdir, 'ref_fasta')
		self._reffa = os.path.join(self._outdir, 'ccs2genome.fasta')
		self._ref2genome = os.path.join(self._outdir, 'ccs2genome.bam')
		self._ref2bed = os.path.join(self._outdir, 'ccs2genome.pos')
		self._bmdir = os.path.join(self._outdir, 'bam_sm')
		self._alignbam = os.path.join(self._outdir, 'bam_align')
		self._ipdcsv = os.path.join(self._outdir, 'ipd_csv')
		self._result = os.path.join(self._outdir, 'result_sta')
	
	def sortbm(self, thd):
		if os.path.exists(self._bam):
			thd = str(thd)
			pysam.sort("-t", "zm", "-m", "8G",  "--threads", thd , "-o",  self._sortbam, self._bam)
			pysam.index( self._sortbam)

	def makedir(self):
		if os.path.exists(self._outdir):
			pass
		else:
			os.mkdir(self._outdir)
			os.mkdir(self._refdir)
			os.mkdir(self._alignbam)
			os.mkdir(self._bmdir)
			os.mkdir(self._ipdcsv)
	
	def splitbam(self, thd):
		#smoutdir = self._outdir+"/bam_sm"
		#os.mkdir(smoutdir)
		#allzmnum = []
		zmtag_hold='unset'
		itr=0
		samfile = pysam.AlignmentFile(self._sortbam , "rb", check_sq=False, threads = thd)
		for read in samfile.fetch(until_eof = True):
			zmtag = read.get_tag('zm')
			if(zmtag != zmtag_hold or itr==0):
				if(itr !=0):
					split_file.close()
				zmtag_hold = zmtag
				#allzmnum.append(zmtag)
				itr+=1
				split_file = pysam.AlignmentFile("%s/m_%s.bam" %(self._bmdir, zmtag),'wb', template=samfile)
			split_file.write(read)
		split_file.close()
		samfile.close()
		#return allzmnum

	def getref(self):
		if os.path.exists(self._sortbam):
			subprocess.run("ccs --hifi-kinetics %s %s" %(self._sortbam, self._hifibam), shell=True)
		if os.path.exists(self._hifibam):
            #subprocess.run("bam2fasta -u %s -o %s" %(self._hifibam, self._reffa), shell=(True))
			subprocess.run("bam2fasta -u %s -o %s" %(self._hifibam, self._hififa), shell=True)
        #if os.path.exists(self._ref2genome):
			#subprocess.run("bedtools bamtobed -i %s > %s" %(self._ref2genome, self._ref2bed), shell=True)
		#if os.path.exists(self._ref2bed):
			#subprocess.run("bedtools getfasta -name  -fi %s -bed %s >%s" %(self._genome, self._ref2bed, self._reffa), shell=True)

	def splitfasta(self):
		if os.path.exists(self._reffa):
			ccsid = []
			with open(self._reffa, 'r') as f:
				fastaall = f.read().split('>')
				for i, j in enumerate(fastaall[1:], start=1):
					ccsid.append(j.split('/')[1])
					new_file_name = "m_"+j.split('/')[1]+".fasta"
					with open (os.path.join(self._refdir, new_file_name), 'w') as f:
						f.write('>' + j)
			self._ccsid = ccsid
					
	def cmdinq(self):
		q = queue.Queue()
		for zmn in self._ccsid:
			q.put("samtools faidx %s/m_%s.fasta %s/m_%s.fasta.fai" %(self._refdir, zmn, self._refdir, zmn))
		for zmn in self._ccsid:
			q.put("blasr %s/m_%s.bam %s/m_%s.fasta --bestn 10 --minMatch 12 --maxMatch 30 --nproc 24 --minSubreadLength 50 --minAlnLength 50 --minPctSimilarity 75 --minPctAccuracy 75 --printSAMQV --hitPolicy randombest --concordant --randomSeed 1 --refineConcordantAlignments --bam --out %s/m_%s.blasr.bam" %(self._bmdir, zmn, self._refdir, zmn, self._alignbam, zmn))
		for zmn in self._ccsid:
			q.put("pbindex %s/m_%s.blasr.bam" %(self._alignbam, zmn))
		for zmn in self._ccsid:
			q.put("ipdSummary %s/m_%s.blasr.bam --reference %s/m_%s.fasta --identify m6A --csv %s/m_%s.csv" %(self._alignbam, zmn, self._refdir, zmn, self._ipdcsv, zmn))
		return q

###Main function###
def main(bam, thd):
	prj1 = Pacbio(bam)
	prj1.makedir()
	prj1.sortbm(thd)
	prj1.splitbam(thd)
	prj1.getref()
	prj1.splitfasta()
	q = prj1.cmdinq()
	pool = MyThreadPool(queue = q, size = thd)
	pool.joinAll()

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    #parser.add_argument("ref", help="the reference genome")
    parser.add_argument("bam", help="pacbio raw subread bam")
    parser.add_argument("-t", "--thread",type = int,  default = 1, help="number of threads")
    args = parser.parse_args()
    if args.thread:
        print(args.bam, args.thread)
        main(args.bam, args.thread)
    else:
        main( args.bam, 1)
