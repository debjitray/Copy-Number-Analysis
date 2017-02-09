#!/usr/bin/perl
# AUTHOR: DEBJIT RAY
# DATE: 08/24/2014
# DESCRIPTION: This code sort the input files based on their chromosomal location
# STRUCTURE:Gene  Chrom	Start	End	PNNL-TCGA-09-1664....
# Usage: perl Z2.Sorter.pl 5.Protein_Mapped.txt 
#        perl Z2.Sorter.pl 6.mRNA_Mapped.txt 

use strict;
use warnings;


my $inputfile =$ARGV[0];
open(FDR,"<$inputfile") or die "Can't open $inputfile: $!\n";

my (@FILENAME) = split(/\./,$inputfile);
my $ouputfile = join("",$FILENAME[0]."A.".$FILENAME[1],"_Sorted.txt");
open(FDW1,">$ouputfile") or die "Can't open $ouputfile: $!\n";

my $ouputfile2 = join("",$FILENAME[0]."B.".$FILENAME[1],"_Sorted.csv");
open(FDW2,">$ouputfile2") or die "Can't open $ouputfile2: $!\n";

my $count=0;
my @array;
foreach(<FDR>){
  (my $line = ($_)) =~ s/\r*\n//;
  if ($line =~ /TCGA/g) {
    my ($n,$o,$p,$q,@OK)=split('\t',$line);
    $a=join("\,",$n,@OK);
    print FDW1 join("\t",$n,$o,$p,$q)."\n";
    print FDW2 $a."\n";
    print "\nNumber of samples in the data\t".scalar(@OK)."\n";
    next;
  }
  my ($A,$B,@Other)=split('\t',$line);
  $B =~ s/X/23/;
  $B =~ s/Y/24/;
  $B =~ s/.+PATCH/22/;
  next if ($B =~ /MT/gi or $B =~ /CHR/gi or  $B =~ /LRG/gi);
  
  $array[$count]=join("\,",$A,$B,@Other);
  $count++;
}


my @End = sort { (split '\,', $a)[3] <=> (split '\,', $b)[3] }  @array;

my @Start = sort { (split '\,', $a)[2] <=> (split '\,', $b)[2] }  @End;

my @Chrom = sort { (split '\,', $a)[1] <=> (split '\,', $b)[1] } @Start;


foreach (@Chrom) {
  my ($w,$x,$y,$z,@OK)=split('\,',$_);
  my $final=join("\,",$w,@OK);
  print FDW1 join("\t",$w,$x,$y,$z)."\n";
  print FDW2 $final."\n";
}


print "Total lines in the file\t".$count."\n\n";
