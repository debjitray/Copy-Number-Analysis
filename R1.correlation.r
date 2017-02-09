rm(list=ls(all=TRUE))
library(lattice)
library('psych')
library('parallel')

P_C=read.csv("7B.Protein_mRNA_Selected_Sort_Trans_Cased.txt",sep="\t",header=T)
C_P=read.csv("9B.CNV_Cased_Sorted_Trans.csv",sep=",",header=T)


P_C$PName=NULL;
C_P$Hybridization=NULL;

# Here we are splitting up the computation purely for speed reasons.  you don't 
# have to do that.  You could run them all at once if your computer was big enough
# or if you like to wait.

# 1
Corr_PC_1_5000=corr.test(P_C,C_P[,1:5000],method="spearman",adjust="none")
save(Corr_PC_1_5000,file="Corr_PC_1_5000_CorrelationDataAll.Rdata")

# 2
Corr_PC_5001_10000=corr.test(P_C,C_P[,5001:10000],method="spearman",adjust="none")
save(Corr_PC_5001_10000,file="Corr_PC_5001_10000_CorrelationDataAll.Rdata")

# 3
Corr_PC_10001_15000=corr.test(P_C,C_P[,10001:15000],method="spearman",adjust="none")
save(Corr_PC_10001_15000,file="Corr_PC_10001_15000_CorrelationDataAll.Rdata")

# 4
Corr_PC_15001_20000=corr.test(P_C,C_P[,15001:20000],method="spearman",adjust="none")
save(Corr_PC_15001_20000,file="Corr_PC_15001_20000_CorrelationDataAll.Rdata")

# 5
Corr_PC_20001_25000=corr.test(P_C,C_P[,20001:25000],method="spearman",adjust="none")
save(Corr_PC_20001_25000,file="Corr_PC_20001_25000_CorrelationDataAll.Rdata")

# 6
Corr_PC_25001_29393=corr.test(P_C,C_P[,25001:29393],method="spearman",adjust="none")
save(Corr_PC_25001_29393,file="Corr_PC_25001_29393_CorrelationDataAll.Rdata")

#DONE

## Here we are stitching the results of the separate computation back together
Corr_PC_pVals=cbind(Corr_PC_1_5000$p,Corr_PC_5001_10000$p,Corr_PC_10001_15000$p,Corr_PC_15001_20000$p,Corr_PC_20001_25000$p,Corr_PC_25001_29393$p)

Corr_PC_Corr=cbind(Corr_PC_1_5000$r,Corr_PC_5001_10000$r,Corr_PC_10001_15000$r,Corr_PC_15001_20000$r,Corr_PC_20001_25000$r,Corr_PC_25001_29393$r)

save(Corr_PC_Corr,file="P_C_Corr.Rdata")

save(Corr_PC_pVals,file="P_C_pVals.Rdata")


## here we are assessing the adjusted p-value of a single CNV in light of
# all the protein correlations
M_pAdj=Corr_PC_pVals

for (i in 1:dim(M_pAdj)[2]) {
	M_pAdj[,i]= p.adjust(M_pAdj[,i],method="BH")
}

M1=M_pAdj
V1=Corr_PC_Corr
M1[M1>0.01]=0
M1[M1!=0]=1
PROTEIN_CNA=M1*(V1/abs(V1))
PROTEIN_CNA[is.na(PROTEIN_CNA)]=0

#This first file keeps track of the correlation values
#in their exact values.
PROTEIN_CNA_NonBin=M1*V1
PROTEIN_CNA_NonBin[is.na(PROTEIN_CNA_NonBin)]=0
save(PROTEIN_CNA_NonBin,file="PROTEIN_CNA_FINALE_NonBin_pVal0.01.Rdata")

#this second file is a binarized correlation value, -1 or +1 or 0
outfilepath3 <- "Y.PROTEIN_CNA_FINALE_pVal0.01.csv"
write.csv(PROTEIN_CNA, file = outfilepath3)
save(PROTEIN_CNA,file="PROTEIN_CNA_FINALE_pVal0.01.Rdata")
#DONE



























