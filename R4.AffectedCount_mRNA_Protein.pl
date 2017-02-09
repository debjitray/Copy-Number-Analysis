#!/usr/local/bin/perl -w

# Debjit Ray

my $inputfile1 = "O2.AffectedmRNA.txt";
open(FDR1,"<$inputfile1") or die "Can't open $inputfile1: $!\n";

my $inputfile2 = "O2.AffectedProtein.txt";
open(FDR2,"<$inputfile2") or die "Can't open $inputfile2: $!\n";

my $outputfile = "O4.AffectedCount_mRNA_Protein.txt";
open(FDW,">$outputfile") or die "Can't open $outputfile: $!\n";

my @ARRAYNAME=();
my @ARRAY1=();
my $count1=0;
foreach(<FDR1>){
  (my $line = ($_)) =~ s/\r*\n//;
  next if ($line =~ /Chrom/g);
  my (@array)=split(/\t/,$line);
  $ARRAYNAME[$count1]=$array[0];
  $ARRAY1[$count1]=$array[4];
  $count1++;
}
 
my @ARRAY2=();
my $count2=0;
foreach(<FDR2>){
  (my $line = ($_)) =~ s/\r*\n//;
  next if ($line =~ /Chrom/g);
  my (@array)=split(/\t/,$line);
  $ARRAY2[$count2]=$array[4];
  $count2++;
} 

print FDW "Name\tmRNA\tProtein\n";
for (my $i=0;$i<scalar(@ARRAY2);$i++) {
  print FDW $ARRAYNAME[$i]."\t".$ARRAY1[$i]."\t".$ARRAY2[$i]."\n";
}

print "\nTotal count in the mRNA file ".scalar(@ARRAY1)."\n";
print "Total count in the Protein file ".scalar(@ARRAY2)."\n\n";
