#!/usr/bin/perl

open NUC,$ARGV[0];
while(<NUC>){
	chomp;
	@ar=split(/\t/,$_);
	$nuc_count{$ar[3]}=$ar[4];
}


open FL,$ARGV[1];
while(<FL>){
	chomp;
	@all=split(/\t/,$_);
	if($nuc_count{$all[3]}){
		$per=$nuc_count{$all[3]}/$all[4];
		print "$_\t$per\n";
	}else{
		print "$_\t0\n";
	}
}
