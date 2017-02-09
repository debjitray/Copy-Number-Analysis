rm(list=ls(all=TRUE))
library('parallel')
args<-commandArgs(TRUE)

All=read.csv(paste('O9.',args[2],'_Bonferroni_Transposed.csv',sep=""),sep=",",header=T)

# CHOICE OF THE PARTICULAR DATABASE

Database=args[1]
dir.create (paste('Z.',args[2],'_Enrichment_',args[1],sep=""))

if (Database == "NCI") {
    NCI=All[1:209,] # NCI
}
if (Database == "KEGG") {
    NCI=All[5773:5958,] #KEGG
}
if (Database == "REACTOME") {
    NCI=All[6176:6605,] #REACTOME
}
if (Database == "GO") {
    NCI=All[2307:3760,] #GO
}

PATHWAY=NCI$CNV
NCI$CNV=NULL
rownames(NCI)=PATHWAY

CNA_SE=read.csv('O8.StartEndLoci.csv',sep=",",header=T)
LINES_CNA=CNA_SE$CNV_Start


ALL=NCI

for (DAP in c(1:22)) {
X=LINES_CNA[DAP]+1
Y=LINES_CNA[DAP+1]
Z2=ALL[,X:Y]

#REDGREEN
Z2[Z2>=0.05]=1
PLOTNAME2=paste('Z.',args[2],'_Enrichment_',args[1],'/FE_Chrom_',sep="")
COLOR='green'

PATHWAY=rownames(Z2)
HOP={}
SELECTED={}
j=1
for (i in 1:dim(Z2)[1]) {
    HOP[i]=length(Z2[i,][Z2[i,]<1])
    if (HOP[i] >= 1) {
        SELECTED[j]=i
        j=j+1
    }
}

if (length(SELECTED)==0) {
    next;
}

NCI=Z2[c(SELECTED),]
PATHWAY=PATHWAY[c(SELECTED)]





D=read.csv('O3A.AffectedCount_Protein.csv',sep=",",header=T)
SEL=D$Count[X:Y]

outfilepath1=as.character(paste(PLOTNAME2, DAP, ".pdf", sep=""))
pdf(file=outfilepath1,height=10,width=30,pointsize=20)

nf <- layout(matrix(c(1,2),2,2,byrow=FALSE), widths=c(1,6), heights=c(6,3), TRUE)
par(mar=c(1, 1, 2, 0.5))
plot(1,1,xlim=c(1,dim(NCI)[2]+100),ylim=c(1,dim(NCI)[1]),cex=0.00001,xaxt="n",yaxt="n",frame.plot=F,xlab="CNA",ylab="")
#


axis(side=2,at=seq(1:length(PATHWAY)),labels=PATHWAY,cex.axis=1.5,las=2)
axis(1,cex.axis=0.001)
abline(v=c(seq(1:20)*100),col=c("orange","grey"),lty=3)
abline(h=c(seq(1:dim(NCI)[1])*1),col=c("grey"),lty=3)

color={}
for (i in 1:dim(NCI)[2]) {
    K=i
    y=NCI[,K]
    x=rep(K,length(y))
    z=c(seq(1,length(y)))
    
    for (u in 1:length(y)){
        if (y[u]<0.001) {
            color[u]='red'
        }
        if (y[u]>=0.001 && y[u]<0.01) {
            color[u]='green'
        }
        if (y[u]>=0.01 && y[u]<0.05) {
            color[u]='blue'
        }
        if (y[u] >=0.05) {
            color[u]='transparent'
        }
    }
    
    
    #color <- ifelse(y>0.1,"transparent","blue")
    points(x,z,type="p",pch=3,cex=3,col=color)
    
}
XAXIS=as.character(paste("Chromosome ", DAP, sep=""))
par(mar=c(5,1,2,0.5))
plot(SEL,pch=16,cex=0.5,col="violet",,xlim=c(0,length(SEL)+100),ylim=c(0,500),xlab=XAXIS,ylab="Affected protein count",axes=F)
axis(2,cex.axis=1.2,las=2)
axis(1,cex.axis=1.6)
#legend("topleft",c("Cis effected","Trans effected"),pch = c(16,16), col = c( 'brown','violet'))

abline(v=c(seq(1:20)*100),col=c("orange","grey"),lty=3)
dev.off()
}






