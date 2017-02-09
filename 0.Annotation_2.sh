#!/bin/bash

echo "\nStep 11: Final correlation calculation"
echo `Rscript R1.Correlator.R 0.01 1.C_P.Rdata 2.P_C.Rdata`
echo `Rscript R1.Correlator.R 0.01 1.C_P.Rdata 3.M_C.Rdata`

echo "\nStep 12: Plotting the heatmap for CNV and mRNA/Protein"
echo `Rscript R2.Plotting.R 6.P_C_FINALE.Rdata Z2.StartEndLoci.csv O1.PLOT_Protein_CNV.png Protein SMOOTH`
echo `Rscript R2.Plotting.R 6.M_C_FINALE.Rdata Z2.StartEndLoci.csv O1.PLOT_mRNA_CNV.png mRNA SMOOTH`

echo "\nStep 13: Count and analysis of effected mRNA/proteins"
echo `Rscript R3.EffectedProteinAnalysis.R 6.P_C_FINALE.Rdata Z2.StartEndLoci.csv O2.AffectedProtein.txt O3.AffectedProtein.pdf protein`
echo `Rscript R3.EffectedProteinAnalysis.R 6.M_C_FINALE.Rdata Z2.StartEndLoci.csv O2.AffectedmRNA.txt O3.AffectedmRNA.pdf mRNA`

echo "Combining the data for two datasets"
echo `R4.AffectedCount_mRNA_Protein.pl`

echo `Rscript R5.AllPlot_mRNA_Protein.R O4.AffectedCount_mRNA_Protein.txt Z2.StartEndLoci.csv O5.AllPlot_mRNA_Protein.png`


##################################################################################################################
# Funtional enrichment
echo "Step 14: Preparing the data for the analysis"
echo `perl P1.Sampler.pl O2.AffectedProtein.txt O3.AffectedProtein_1.csv Protein`
echo `perl P1.Sampler.pl O2.AffectedmRNA.txt O3.AffectedmRNA_1.csv mRNA`

echo "Step 15: Transposing the data for the analysis"
echo `python R1.my_csv_transposer.py O3.AffectedProtein_1.csv O4.AffectedProtein_1_Transposed.csv`
echo `python R1.my_csv_transposer.py O3.AffectedmRNA_1.csv O4.AffectedmRNA_1_Transposed.csv`

echo "Step 16: Run the enrichment code"
echo `Rscript R0.FE_Calculator.R Protein`
echo `Rscript R0.FE_Calculator.R mRNA`

echo "Step 17: Extracting the Bonferroni and enrichment scores for the enrichment"
echo `perl P2.Finale.pl O2.AffectedProtein.txt Protein`
echo `perl P2.Finale.pl O2.AffectedmRNA.txt mRNA`

echo "Step 18: Generate start and end loci of the affected CNA"
echo `perl P3.CoOrdinates.pl`

echo "Step 19: Generate the desired plots for the pathway enrichment"
echo `python R1.my_csv_transposer.py O6.Protein_Bonferroni.csv O9.Protein_Bonferroni_Transposed.csv`
echo `Rscript R1.FE_All.R KEGG Protein`


##################################################################################################################
# CIS TRANS Analysis