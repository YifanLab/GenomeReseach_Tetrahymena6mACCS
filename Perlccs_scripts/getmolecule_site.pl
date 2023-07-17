#!/usr/bin/perl


open FL,$ARGV[0];
while(<FL>){
	chomp;
	@ar=split(/\t/,$_);
	$hs_mol{$ar[0]}=1;
	$hs_count{"$ar[0]\t$ar[-1]"}+=1;
	$hs_pos{"$ar[0]\t$ar[-1]"}.="$ar[1], ";
}


foreach(keys %hs_mol){
	$full="$_\tFull";
	$hemi="$_\tHemi";
	if($hs_count{$full}){
		$hs_pos{$full}=~s/, $//;
		if($hs_count{$hemi}){
			$hs_pos{$hemi}=~s/, $//;
			print "$_\t$hs_count{$full}\t$hs_count{$hemi}\t$hs_pos{$full}\t$hs_pos{$hemi}\n";
		}else{
			print "$_\t$hs_count{$full}\t0\t$hs_pos{$full}\t0\n";
		}
	}else{
		if($hs_count{$hemi}){
			$hs_pos{$hemi}=~s/, $//;
			print "$_\t0\t$hs_count{$hemi}\t0\t$hs_pos{$hemi}\n";
		}else{
			print "$_\t0\t0\t0\t0\n";
		}
	}
}
