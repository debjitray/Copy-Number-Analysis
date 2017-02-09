rm(list=ls(all=TRUE))
args<-commandArgs(TRUE)

P_C=read.csv(args[1],sep="\t",header=T)
M_C=read.csv(args[2],sep="\t",header=T)

C_P=read.csv(args[3],sep="\t",header=T)
C_M=read.csv(args[4],sep="\t",header=T)


P_C$GID=NULL;
M_C$GID=NULL;
C_P$Gene=NULL;
C_M$Gene=NULL;


save(P_C,file=paste(args[5],"/PLOT/2.P_C.Rdata",sep="",collapse=NULL))
save(M_C,file=paste(args[5],"/PLOT/3.M_C.Rdata",sep="",collapse=NULL))

save(C_P,file=paste(args[5],"/PLOT/1.C_P.Rdata",sep="",collapse=NULL))
save(C_M,file=paste(args[5],"/PLOT/1.C_M.Rdata",sep="",collapse=NULL))

#####################################################################################






























