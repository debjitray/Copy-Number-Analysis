#!/usr/local/bin/perl -w

#use strict;

# Debjit Ray
# 06/07/2010
# This program is for....

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
    my (@NEW) =  split(/\t/,$line);
    print FDW1 $line."\n";
    next;
  }
  my ($gene,@tokens) = split(/\t/,$line);
  $SIZE_1=scalar(@tokens);
  $gene =~ /(TCGA\-\d+\-\d+)\.?/g;
  $gene = $1;
  $hash{$gene}=join("\t",@tokens);
  $COUNT1++;
}

my $COUNT2=0;
my $COUNT3=0;
foreach(<FDR2>){
  (my $line = $_) =~ s/\r*\n//;
  if ($line =~ /^Gene/) {
    my (@NEW) =  split(/\,/,$line);
    print FDW2 join("\t",@NEW)."\n";
    next;
  }
  my ($gene,@tokens) = split(/\,/,$line);
  $SIZE_2=scalar(@tokens);
  $gene =~ /(TCGA\-\d+\-\d+)\.?/g;
  $gene = $1;
  $COUNT2++;
  if (exists $hash{$gene}) {
    print FDW1 $gene."\t".$hash{$gene}."\n";
    my (@ENTRY)=split("\,",$line);
    print FDW2 join("\t",@ENTRY)."\n";
    $COUNT3++;
  }
    
}

print "\nNumber of Cases in mRNA/Protein file ".$COUNT1."\n";
print "Number of Cases in CNA file ".$COUNT2."\n";
print "Matched cases across 2 files ".$COUNT3."\n\n";

print "Number of Proteins/mRNA ".$SIZE_1."\n";
print "Number of CNV ".$SIZE_2."\n\n";
