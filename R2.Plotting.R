# RUN ON A WINDOWS R, MAC HAS SOME ISSUE WITH GENERATING THE PROPER GRAPHICS
rm(list=ls(all=TRUE))
library('parallel')
args<-commandArgs(TRUE)

load(args[1])
d=PROTEIN_CNA

LINES=read.csv(args[2],sep=",",header=T)
LINES_CNA=LINES$CNV_Start
LINES_Protein=LINES$Protein_Start


A={}
B={}

for (i in 1:24) {
    
    A[i]=(LINES_CNA[i]+LINES_CNA[i+1])/2
    B[i]=(LINES_Protein[i]+LINES_Protein[i+1])/2
    
    
}

chrome <- c("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","X","Y")
chrome2 <- c("","","","","","","","","","","","","","","","","","","","","","","","","")

colnames(PROTEIN_CNA)=c(rep(".",dim(d)[2]))
rownames(PROTEIN_CNA)=c(rep(".",dim(d)[1]))


# SMOOTHING

if (args[5] == "SMOOTH") {
    X=d;
    for (i in 2:(dim(X)[1]-1)) {
        for (j in 2:(dim(X)[2]-1)) {
        
            if (X[i,j]==1 || X[i,j]== -1) {
            
                if (X[i-1,j-1]==0 && X[i-1,j]==0 && X[i-1,j+1]==0 && X[i,j-1]==0 &&     X[i,j+1]==0 && X[i+1,j-1]==0 && X[i+1,j]==0 && X[i+1,j+1]==0  ) {
                
                    X[i-1,j-1]=X[i,j];
                    X[i-1,j]=X[i,j];
                    X[i-1,j+1]=X[i,j];
                    X[i,j-1]=X[i,j];
                    X[i,j+1]=X[i,j];
                    X[i+1,j-1]=X[i,j];
                    X[i+1,j]=X[i,j];
                    X[i+1,j+1]=X[i,j];
                }
            }
        
        }
        print(i);
    }
    
    d=X;
} else {
    d=d;
}


png(args[3],height=480*8,width=480*7,res=300)
plot(1,1,xlim=c(1,dim(d)[2]),ylim=c(1,dim(d)[1]),cex=0.00001,xaxt="n",yaxt="n",frame.plot=F,xlab=paste("CNA (", dim(d)[2], ")",sep = ""),ylab=paste(args[4]," (", dim(d)[1], ")",sep = ""),abline(h=LINES_Protein,v=LINES_CNA,lwd=0.5,lty=3))


axis(side=1,at=LINES_CNA,labels=chrome2)
axis(side=2,at=LINES_Protein,labels=chrome2)

axis(side=1,at=A,labels=chrome,col="transparent",col.ticks = 'transparent',las=2)
axis(side=2,at=B,labels=chrome,col="transparent",col.ticks = 'transparent',las=2)

for (i in 1:dim(d)[2]) {
    K=i
    y=d[,K]
    x=rep(K,length(y))
    z=c(seq(1,length(y)))
    y[y==0]=NA
    color <- ifelse(y>0,"red","blue")
    points(x,z,type="p",pch=16,cex=0.03,col=color)
}
dev.off()