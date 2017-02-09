#!/usr/local/bin/perl -w

#use strict;

# Debjit Ray
# 06/07/2010
# This program is for....
# perl Z3.BothProteinmRNA.pl 5B.Protein_Mapped_Sorted.csv 6B.mRNA_Mapped_Sorted.csv 5B.Protein_Mapped_Sorted_BothProteinmRNA.csv 6B.mRNA_Mapped_Sorted_BothProteinmRNA.csv

my $inputfile1      = $ARGV[0];
my $inputfile2     = $ARGV[1];
my $outputfile1     = $ARGV[2];
my $outputfile2     = $ARGV[3];

open(FDR1,"<$inputfile1") or die "Can't open $inputfile1: $!\n";
open(FDR2,"<$inputfile2") or die "Can't open $inputfile2: $!\n";

open(FDW1,">$outputfile1") or die "Can't open $outputfile1: $!\n";
open(FDW2,">$outputfile2") or die "Can't open $outputfile2: $!\n";

my $SIZE_1=0;
my $SIZE_2=0;

my %hash;
my $COUNT1=0;
foreach(<FDR1>){
  (my $line = $_) =~ s/\r*\n//;
  if ($line =~ /^GID/) {
    my (@NEW) =  split(/\,/,$line);
    print FDW1 $line."\n";
    next;
  }
  my ($gene,@tokens) = split(/\,/,$line);
  $SIZE_1=scalar(@tokens);
  $hash{$gene}=join("\,",@tokens);
  $COUNT1++;
}

my $COUNT2=0;
my $COUNT3=0;
foreach(<FDR2>){
  (my $line = $_) =~ s/\r*\n//;
  if ($line =~ /^GID/) {
    my (@NEW) =  split(/\,/,$line);
    print FDW2 $line."\n";
    next;
  }
  my ($gene,@tokens) = split(/\,/,$line);
  $SIZE_2=scalar(@tokens);
  if (exists $hash{$gene}) {
    print FDW1 $gene."\,".$hash{$gene}."\n";
    print FDW2 $line."\n";
    $COUNT3++;
  }
  $COUNT2++;
}

print "\nNumber of Cases in mRNA/Protein file ".$COUNT1."\n";
print "Number of Cases in CNA file ".$COUNT2."\n";
print "Matched cases across 2 files ".$COUNT3."\n\n";

print "Number of Proteins/mRNA ".$SIZE_1."\n";
print "Number of CNV ".$SIZE_2."\n\n";
