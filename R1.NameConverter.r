cat("\nThis code converts the Peptide names into their respective Gene Names, Chromosome Name, Start and End location\n\n")
# Author: Debjit Ray
# Date: 20 September, 2014

# Usage: From terminal
# Rscript Q1.ProteinToGeneNameConverter.r INPUTFILE OUTPUTFILE MARTNAME DATASET QUERY CONVERTED
# Rscript Q1.ProteinToGeneNameConverter.r 1.crossTab_W_joint_var1.txt 4.PeptideName_GeneName_Mapped.csv ensembl hsapiens_gene_ensembl refseq_peptide hgnc_symbol

# Installing biomaRt
source("http://bioconductor.org/biocLite.R")
biocLite("biomaRt")

rm(list=ls(all=TRUE))
args<-commandArgs(TRUE)
library("biomaRt")

#####################################################################################
# Funtion for the conversion
#####################################################################################
peptide_to_gene <- function(PEPTIDE_LIST,MART_NAME,DATASET,QUERY,CONVERTED){
  MY_MART = useMart(MART_NAME,host="www.ensembl.org")
  hsa = useDataset(DATASET, mart=MY_MART)
  out = getBM(attributes= c(QUERY, CONVERTED,"chromosome_name","start_position","end_position"),
              filters=c(QUERY),
              values=PEPTIDE_LIST,
              mart=hsa)
  return(out)
}
#####################################################################################
#####################################################################################
# Input parameters

INPUTFILE = args[1]
OUTPUTFILE = args[2]
MART_NAME = args[3]
DATASET = args[4]
QUERY = args[5]
CONVERTED = args[6]

#####################################################################################
K=unlist(strsplit(INPUTFILE, "\\."))
if (K[3] == 'csv') {
    PROTEIN=read.csv(INPUTFILE,sep=",",header=T)
} else {
    PROTEIN=read.csv(INPUTFILE,sep="\t",header=T)
}

LIST <- PROTEIN[,1]
PEPTIDE_LIST <- sub("(.*)\\.\\d+", "\\1", LIST) # REMOVING THE DOTS
PEPTIDE_LIST <- sub("\'", "", PEPTIDE_LIST)
PEPTIDE_LIST <- sub("\"", "", PEPTIDE_LIST)

UPDATED_LIST=peptide_to_gene(PEPTIDE_LIST,MART_NAME,DATASET,QUERY,CONVERTED)
DATASET=data.frame(UPDATED_LIST[,2],UPDATED_LIST[,1],UPDATED_LIST[,3],UPDATED_LIST[,4],UPDATED_LIST[,5])
colnames(DATASET)=cbind(colnames(UPDATED_LIST)[2],colnames(UPDATED_LIST)[1],colnames(UPDATED_LIST)[3],colnames(UPDATED_LIST)[4],colnames(UPDATED_LIST)[5])

write.table(DATASET, sep=",",file=OUTPUTFILE,row.names=FALSE)

ACTUAL = length(PROTEIN[,1])
MAPPED = length(UPDATED_LIST[,1])
cat("\nActual entries: ", ACTUAL,"\n")
cat("Final mapped entries: ", MAPPED,"\n\n")
################################################################################
# http://davetang.org/muse/2012/04/27/learning-to-use-biomart/
# listMarts(Biomart)
# MY_MART = useMart('ensembl')
# listDatasets(MY_MART)
# hsa = useDataset('uniprot', mart=MY_MART)
# filters = listFilters(hsa)

#Test <- UPDATED_LIST[order(as.numeric(UPDATED_LIST$end_position)),]
#Test <- Test[order(as.numeric(Test$start_position)),]
#Test <- Test[order(as.numeric(Test$chromosome_name)),]