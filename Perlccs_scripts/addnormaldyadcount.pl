#!/usr/bin/perl

open DYA,$ARGV[0];
while(<DYA>){
	chomp;
	@ar=split(/\t/,$_);
	$hs_tag{$ar[3]}=$ar[-1];
}

open FL,$ARGV[1];
while(<FL>){
	chomp;
	@all=split(/\t/,$_);
	#print "$all[0]\n";
	for($i=1;$i<=2;$i++){
		$tag="$all[0]_$i";
		if($hs_tag{$tag}){
			$hs_all{$all[0]}.="$hs_tag{$tag}\t";
			}else{
			$hs_all{$all[0]}.="0\t";
			}
		}
	}

foreach(keys %hs_all){
	print "$_\t$hs_all{$_}\n";
}
