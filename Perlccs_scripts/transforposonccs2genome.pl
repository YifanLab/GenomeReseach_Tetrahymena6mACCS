#!/usr/bin/perl

open POS,$ARGV[0];
while(<POS>){
	chomp;
	@ar=split(/\t/,$_);
	$tag="$ar[0]\t$ar[1]";
	$hs_tpos{$tag}=$ar[5];
	$hs_target{$ar[0]}=$ar[-2];
}

open FL,$ARGV[1];
while(<FL>){
	chomp;
	@gpos='';
	@all=split(/\t/,$_);
	$all[2]=~s/\s+//g;
	@ele=split(/:/,$all[2]);
	for($i=0;$i<=$#ele;$i++){
		$tmp="$all[0]\t$ele[$i]";
		if($hs_tpos{$tmp}){
			push @gpos, "$hs_tpos{$tmp}: ";
			}
		}
	@gpos = sort{$a <=> $b} @gpos;
	$gpos=join('', @gpos);
	$gpos=~s/: $//;
	print "$_\t$hs_target{$all[0]}\t$gpos\n";
	}
