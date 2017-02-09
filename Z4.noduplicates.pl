#!/usr/local/bin/perl -w

#use strict;

# Debjit Ray
# 06/07/2010
# This program is for....

my $inputfile      = $ARGV[0];

my $outputfile     = $ARGV[1];

my %hash        = ();
my %hash_avg        = ();

my $d=0;
my $x=0;




# Input file containing the main data
open(FDR,"<$inputfile") or die "Can't open $inputfile: $!\n";

open(FDW,">$outputfile") or die "Can't open $outputfile: $!\n";

foreach(<FDR>){
  (my $line = $_) =~ s/\r*\n//;
  if ($line =~ /^GID/) {
    my (@NEW) =  split(/\,/,$line);
    print FDW join("\t",@NEW)."\n";
    next;
  }
  my ($gene,@tokens) = split(/\,/,$line); 
  $gene =~ s/PNNL-//g;
  $gene =~ s/JHU-//g;
  $gene =~ /(TCGA\-\d+\-\d+)\.?/g;
  $gene = $1;
  print $gene."\n";
  if (!exists $hash{uc($gene)}){
    $hash{uc($gene)}{DATA}=[@tokens];
    $hash{uc($gene)}{COUNT}++;
    $d++;
  }
  elsif (exists $hash{uc($gene)}){
    foreach my $i(0...$#tokens){
      ${$hash{uc($gene)}{DATA}}[$i]+=$tokens[$i];
      
    }
    $hash{uc($gene)}{COUNT}++;
    
  }
  $x++;

}
close(FDR);

foreach my $i(sort keys %hash){

  my @arr=map {$_/$hash{$i}{COUNT}} @{$hash{$i}{DATA}};

  my $str=join("\t",@arr);

  print FDW $i."\t".$str."\n";
}
close (FDW);

print "\nTotal samples before\t".$x."\n";
print "Samples after removal of the duplicates\t".$d."\n\n";





