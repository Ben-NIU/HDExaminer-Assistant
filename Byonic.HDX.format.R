Byonic.HDX.format<-function(File){
 
 D<-read.csv(File)
library(dplyr)
LLL<-NULL
for(n in 1:nrow(D)){
  L<-length(strsplit(as.character(D$Sequence[n]),"")[[1]])
  LL<-strsplit(as.character(D$Sequence[n]),"")[[1]][3:(L-2)]
  LLL0<-paste(LL,collapse = "")
  LLL<-c(LLL,LLL0)}
DD<-select(D, Scan.Time, z, Score,Sequence)
DD$Sequence<-LLL
DD$id<-paste(DD$Sequence, DD$z, sep="")
uni<-unique(DD$id)
R<-NULL
for(k in uni){
  iddd<-which(DD$id==k)[1]
  R0<-DD[iddd,]
 R<-rbind(R,R0)}
R<-select(R, -5)
return(R)
}