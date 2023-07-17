#!/usr/bin/perl

open FL,$ARGV[0];
while(<FL>){
	chomp;
	@ar=split(/\t/,$_);
	$tag="$ar[0]\t$ar[1]\t$ar[2]\t$ar[3]\t$ar[5]";
	$hs_ele{$tag}.="$ar[-1],";
	$hs_dir{$tag}="$ar[5]";
}

open ID,$ARGV[1];
while(<ID>){
	chomp;
	@all=split(/\t/,$_);
	$id="$all[0]\t$all[1]\t$all[2]\t$all[3]\t$all[5]";
	$hs_tss{$id}=1;
}


foreach(keys %hs_tss){
	if($hs_ele{$_}){
		$hs_ele{$_}=~s/,$//;
		if($hs_dir{$_} eq '+'){
			print "$_\t$hs_ele{$_}\n";
		}else{
			@ele=split(/,/,$hs_ele{$_});
			$revele=join(',' ,reverse(@ele));
			print "$_\t$revele\n";
		}
	}
}
