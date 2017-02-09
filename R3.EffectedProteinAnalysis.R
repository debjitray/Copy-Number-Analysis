#USAGE: Rscript R3.EffectedProteinAnalysis.R 7.P_C_FINALE.Rdata O2.AffectedProteins.txt O3.AffectedProteins.pdf proteins

rm(list=ls(all=TRUE))
args<-commandArgs(TRUE)

PROTEIN_NAMER=read.csv('/Users/rayd032/Desktop/Perl_tester/5A.Protein_Mapped_Sorted.txt',sep="\t",header=T)
CNA_NAMER=read.csv('/Users/rayd032/Desktop/Perl_tester/3A.CNV.txt',sep="\t",header=T)

load(args[1])
LINES=read.csv(args[2],sep=",",header=T)
LINES_CNA=LINES$CNV_Start
LINES_Protein=LINES$Protein_Start


CUTOFF=0 # Number of data points you want to select across a particular column
Corr_Cut=0.00001 # Correlation values you want to use as Cutoff for significant pairs


Actual=PROTEIN_CNA
rownames(Actual)=PROTEIN_NAMER$Gene

COUNT=NULL
LOCATION=NULL
CHROM_NAMES=NULL
counter=1


# SELECTS THE SIGNIFICANT REGIONS (COLUMNS HAVING DATA POINTS MORE THAN THE CUTOFF SET)
# GENERATES THE NUMBER OF MATCHES, CHROMOSOME LOCATION, CHROMOSOME GENE
for (i in 1:dim(PROTEIN_CNA)[2]) {
	L=length(PROTEIN_CNA[,i][abs(PROTEIN_CNA[,i])!=0])
	
	if (L>=CUTOFF) {
		COUNT[counter]=L
		LOCATION[counter]=i
		CHROM_NAMES[counter]=colnames(PROTEIN_CNA)[i]
		counter=counter+1
	}
}



# CONVERTS THE CHROMOSOME LOCATION TO CHROMOSOME NAME BASED ON ITS EXPANSE
FOUNT=1
CHROM=NULL
for (M in 1:length(LOCATION)) {

	for (x in 1:24) {
		k=LOCATION[M];
		if (k >= LINES_CNA[x]+1 && k <=LINES_CNA[x+1]) {
			CHROM[FOUNT]=x
			FOUNT=FOUNT+1
		}

	}
}

ALL <- vector("list",length(COUNT))
outfilepath6 <- args[3]
write.table(cbind("CNA","Chrom","start","end","Count",paste("Affected ",args[5],sep="")),outfilepath6,sep="\t",quote =FALSE,col.names=FALSE,row.names=FALSE)


# FOR EACH SELECTED REGION (COLUMNS) WE FIND OUT THE PROTEINS AMONG THAT REGION ABOVE CERTAIN CORR_CUT

MY_ALL=NULL;
Chrom_Unique=unique(CHROM);

for (l in 1:length(Chrom_Unique)) {
    K<-(paste("T_",Chrom_Unique[l],"=NULL",sep=""))
    eval(parse(text=K))
}

for (j in 1:length(COUNT)) {
	K=LOCATION[j]
    Pro_All=rownames(Actual)[which(abs(Actual[,K])> Corr_Cut)]
    ALL[[j]] <-Pro_All

    MY_ALL=c(MY_ALL,Pro_All)
    
    
    if (CHROM[j] %in% Chrom_Unique) {
        J<-(paste("T_",CHROM[j],"=c(","T_",CHROM[j],",Pro_All)",sep=""))
        eval(parse(text=J))
    }
    FINAL_OUTPUT=cbind(CHROM_NAMES[j],CNA_NAMER$chrom[LOCATION[j]],CNA_NAMER$start[LOCATION[j]],CNA_NAMER$end[LOCATION[j]],COUNT[j],t(ALL[[j]]))
    
    write.table(FINAL_OUTPUT,outfilepath6,sep="\t",col.names=FALSE,row.names=FALSE, quote =FALSE, append=TRUE )
    	
}






LINES_CNA=LINES_CNA*1.2

A={}

for (i in 1:24) {
    
    A[i]=(LINES_CNA[i]+LINES_CNA[i+1])/2
    
    
}

chrome <- c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","X","Y")
chrome2 <- c("","","","","","","","","","","","","","","","","","","","","","","","","")


################################################################################################
pdf(file=args[4],width=40,height=20,pointsize=50);
par(mfrow=c(1,1))
par(mar=c(5,5,5,5))
barplot(COUNT,ylim=c(0,500),xlab="Chromosome",ylab=paste("Affected ",args[5],sep=""),col='darkgreen',border=NA,axes=F)
abline(h=c(200,400),col=c("grey","grey"),lty=3)
abline(v=LINES_CNA,lwd=2,lty=3)
axis(2,cex.axis=0.8)
axis(side=1,at=LINES_CNA,labels=chrome2)
axis(side=1,at=A,labels=chrome,col="transparent",col.ticks = 'transparent',las=2)
dev.off()







