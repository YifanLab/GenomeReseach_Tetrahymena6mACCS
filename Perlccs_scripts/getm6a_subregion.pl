#!/usr/bin/perl

open ID,$ARGV[0];
while(<ID>){
	chomp;
	@ar=split(/\t/,$_);
	$tag="$ar[0]\_$ar[1]";
	#print "$tag\n";
	$hs_cov{$tag}=1;
	}

open FL,$ARGV[1];
while(<FL>){
	chomp;
	@all=split(/\t/,$_);
	@ele=split(/,/,$all[3]);
	for($i=0;$i<=$#ele;$i++){
		if($hs_cov{$ele[$i]}){
			$hs_ele{$_} += 1;
			#print "$_\n";
			}
		}
	}


foreach(keys %hs_ele){
	print "$_\t$hs_ele{$_}\n";
	}
