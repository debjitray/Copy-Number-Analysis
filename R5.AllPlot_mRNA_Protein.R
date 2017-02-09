rm(list=ls(all=TRUE))
args<-commandArgs(TRUE)

D=read.csv(args[1],sep="\t",header=T)
X=D$Protein
Y=D$mRNA
LINES=read.csv(args[2],sep=",",header=T)
LINES_CNA=LINES$CNV_Start

A={}

for (i in 1:24) {
    
    A[i]=(LINES_CNA[i]+LINES_CNA[i+1])/2
    
    
}

chrome <- c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","X","Y")
chrome2 <- c("","","","","","","","","","","","","","","","","","","","","","","","","")

M=X


#
COL=c("blue4","orange3")
png(args[3],height=480*12,width=480*24,res=600)
par(mfrow=c(4,6),mar=c(8, 3, 1, 1))

#pdf("R1.Gene_Protein1.pdf",width=60,height=30,pointsize=50);
#par(mfrow=c(4,6),mar=c(2, 2, 1, 1))

for (i in 1:24) {
    
    M1=X[(LINES_CNA[i]+1):(LINES_CNA[i+1])] #Chromi
    M2=Y[(LINES_CNA[i]+1):(LINES_CNA[i+1])] #Chromi
    
    
    NAME <- as.character(paste("Chromosome ", i,sep=""))
    
    plot(M1,pch=16,cex=0.2,col="blue",xlim=c(0,length(M1)+100),ylim=c(0,500),xlab='',ylab="Affected protein count",axes=F)
    points(M2,pch=16,,cex=0.2,col="brown")
    axis(2,cex.axis=1,las=1)
    abline(h=c(200,400),col=c("grey","grey"),lty=3)
    axis(1,cex.axis=1)
    if (i==1) {
        legend('topleft',c("mRNA","Protein"),pch=c(16,16),col=c("brown","blue"),bty = "n")
    }
}

dev.off()

