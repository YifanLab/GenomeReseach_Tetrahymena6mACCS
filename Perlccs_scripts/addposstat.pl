#!/usr/bin/perl 

open POS,$ARGV[0];
while(<POS>){
	chomp;
	@full='';
	@hemi='';
	@ar=split(/\t/,$_);
	$ar[3]=~s/\[//;
	$ar[3]=~s/\]//;
	$ar[3]=~s/\s+//g;
	$ar[4]=~s/\s+//g;
	@full=split(',', $ar[3]);
	@hemi=split(',', $ar[4]);
	$ar[0]=~s/\s+//g;
	for($i=0;$i<=$#full;$i++){
		$ftag="$ar[0]\t$full[$i]";
		$hs_pos{$ftag}='Full';
		}
	for($j=0;$j<=$#hemi;$j++){
		$htag="$ar[0]\t$hemi[$j]";
		$hs_pos{$htag}='Hemi';
		}
	}

#foreach(keys %hs_pos){
#	print "$_\t$hs_pos{$_}\n";
#	}


open FL,$ARGV[1];
while(<FL>){
	chomp;
	@fulp='';
	@hemip='';
	@ele=split(/\t/,$_);
	$ele[2]=~s/\s+//g;
	@alpos=split(/:/,$ele[2]);
	#print "@alpos\n";
	$ele[0]=~s/\s+//;
	for($k=0;$k<=$#alpos;$k++){
		$epos="$ele[0]\t$alpos[$k]";
		#print "$epos\t$hs_pos{$epos}\n";
		if($hs_pos{$epos} eq 'Full'){
			#print "$hs_pos{$epos}\n";
			push @fulp, "$alpos[$k], ";
			}
		if($hs_pos{$epos} eq 'Hemi'){
			push @hemip, "$alpos[$k], ";
			}
		}
	$j_fulp=join('', @fulp);
	$j_hemip=join('',@hemip);
	if($j_fulp){}else{$j_fulp=0};
	if($j_hemip){}else{$j_hemip=0};
	print "$_\t$j_fulp\t$j_hemip\n";
}

