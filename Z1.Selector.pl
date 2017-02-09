#!/usr/local/bin/perl -w

# Debjit Ray
# Date: 02/25/2014
# Place: PNNL
# use strict;

# This code matches the Protein and mRNA names with the Mapped ones and selects those which are commom in both datasets
# perl Z1.Selector.pl 4.PeptideName_GeneName_Mapped.csv 1.crossTab_W_joint_var1.txt 5.Protein_Mapped.txt

# Mapping input file
my $inputfile1 = $ARGV[0];
open(FDR1,"<$inputfile1") or die "Can't open $inputfile1: $!\n";

# Protein/mRNA/CNV input file
my $inputfile2 = $ARGV[1];
open(FDR2,"<$inputfile2") or die "Can't open $inputfile2: $!\n";

my $ouputfile1 = $ARGV[2];
open(FDW1,">$ouputfile1") or die "Can't open $ouputfile1: $!\n";



my %hash;
my %hashNEXT;

my $FILE1=0;
foreach(<FDR1>){
  (my $line = ($_)) =~ s/\r*\n//;
  $line =~ s/\"//g;
  next if ($line =~ /chromosome/g);
  $FILE1++;
  my (@array) = split("\,",$line);
  # HASH FOR THE PROTEIN ID AS KEY
  my $INFO = join("\t",$array[0],$array[2],$array[3],$array[4]);
  $hash{$array[1]}=$INFO;
}

my $FILE2=0;
my $COUNT1=0;
foreach(<FDR2>){
  $FILE2++;
  (my $line = ($_)) =~ s/\r*\n//;
  $line =~ s/\"//g;
  if ($line =~ /TCGA/g) {
    my ($No,@HEAD)=split("\t",$line);
    my $HEADER=join("\t","GID","Chrom","Start","End",@HEAD);
    print FDW1 $HEADER."\n";
    next;
  }
  my ($PROT,@NEW)=split("\t",$line);
  $PROT =~ s/\.\d+//g;
  if (exists $hash{$PROT}) {
    print FDW1 $hash{$PROT}."\t".join("\t",@NEW)."\n";
    $COUNT1++;
  }
}

print "\nTotal data in the protein expression file ".$FILE2."\n";
print "\nTotal data in the mapping file ".$FILE1."\n";
print "\nTotal data in the matched ".$COUNT1."\n\n";
