#!/usr/local/bin/perl -w

# Debjit Ray

my $inputfile1 =$ARGV[0];
open(FDR1,"<$inputfile1") or die "Can't open $inputfile1: $!\n";

my $inputfile2 = $ARGV[1];
open(FDR2,"<$inputfile2") or die "Can't open $inputfile2: $!\n";

my $inputfile3 = $ARGV[2];
open(FDR3,"<$inputfile3") or die "Can't open $inputfile3: $!\n";

my $outfile2 = "PLOT/Z2.StartEndLoci.csv";
open(FDW2,">$outfile2") or die "Can't open $outfile2: $!\n";
print FDW2 "Chrom\,CNV_Start\,Protein_Start\,mRNA_Start\n";

my $count2=0;
my %hashCNV;
foreach(<FDR1>){
  $hashCNV{0}=1;
  (my $line = ($_)) =~ s/\r*\n//;
  next if ($line =~ /chrom/gi);
  my($A,$B,$C,$D)=split(/\t/,$line);
  $count2++;
  $hashCNV{$B}=$count2;
}
print "Total CNV\t".$count2."\n";


my $countP=0;
my %hashProtein;
foreach(<FDR2>){
  $hashProtein{0}=1;
  (my $line = ($_)) =~ s/\r*\n//;
  next if ($line =~ /chrom/gi);
  my($A,$B,$C,$D)=split(/\t/,$line);
  $countP++;
  $hashProtein{$B}=$countP;
}
print "Total Protein\t".$countP."\n";

my $countMRNA=0;
my %hashMRNA;
foreach(<FDR3>){
  $hashMRNA{0}=1;
  (my $line = ($_)) =~ s/\r*\n//;
  next if ($line =~ /chrom/gi);
  my($A,$B,$C,$D)=split(/\t/,$line);
  $countMRNA++;
  $hashMRNA{$B}=$countMRNA;
}
print "Total mRNA\t".$countMRNA."\n\n";

foreach (sort {$a<=>$b} keys %hashCNV) {
  print FDW2 $_."\,".$hashCNV{$_}."\,".$hashProtein{$_}."\,".$hashMRNA{$_}."\n";
}
