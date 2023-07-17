#!/usr/bin/perl

open REG,$ARGV[0];
while(<REG>){
	chomp;
	@reg=split(/\t/,$_);
	$hs_reg{$reg[0]}="$reg[4]\t$reg[5]";
}


open FL,$ARGV[1];
while(<FL>){
	chomp;
	@ar=split(/\t/,$_);
	#print "$ARGV[0]\t$ARGV[1]\t$ARGV[2]\t$ARGV[3]\t$ar[-1]\t$ar[-3]\n";
	if($ar[-2] eq $ARGV[2] and $ar[-3]>= $ARGV[3] and $ar[-3]<= $ARGV[4]){
		print "$_\t$hs_reg{$ar[0]}\n";
		}
	}
