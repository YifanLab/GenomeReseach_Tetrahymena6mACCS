#!/usr/bin/perl
#
#
open FL,$ARGV[0];
while(<FL>){
	chomp;
	@ar=split(/\t/,$_);
	@full=split(/, /,$ar[3]);
	@hemi=split(/, /,$ar[4]);
	for($i=0;$i<=$#full;$i++){
		$hash_pos{$full[$i]}='Full';
	}
	for($j=0;$j<=$#hemi;$j++){
		$hash_pos{$hemi[$j]}='Hemi';
	}
}


open SM,$ARGV[1];
while(<SM>){
	chomp;
	@ipd=split(/,/,$_);
	if($hash_pos{$ipd[1]} and $ipd[3] eq 'A'){
		if($ipd[2]==0){
			$ipdv= log($ipd[-2])/log(2);
			print "$ipd[1]\t$hash_pos{$ipd[1]}\_W\t$ipdv\n";
		}else{
			$ipdv= -log($ipd[-2])/log(2);
			print "$ipd[1]\t$hash_pos{$ipd[1]}\_C\t$ipdv\n";
		}
	}
}

