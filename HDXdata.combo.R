## Need to define the bad.peptide dataframe before using this fucntion, example: bad.peptides<-data.frame("sq"=c("1-12","43-50","65-70"),"cs"=c(2,1,1)) ##
## The HDXdata.combo() is designed for those datafiles containing two sets of protein states simultaneously, i.e., both apo and holo are present in the single .csv file.
## The outcome of this function is the well-formatted data frame with mean %D and sd %D calculated for each interested peptides under different time-points.
HDXdata.combo<-function(origin, bad.peptides,time.points,rep=3 ){
  library(dplyr)
 ben1<-strsplit(names(origin),"")
 ben2<-do.call("c",lapply(ben1, function(x) sum(x %in% "X")))
 ben3<-origin[,which(ben2==1)]
 origin2<-cbind(origin[,c(1:4,6)], ben3)
  ## Rename the columns in origin2.
  time.points<-(gsub(" ","",time.points) %>% strsplit(",", fixed=TRUE))[[1]]
  replicates<-1:rep
  num<-length(time.points)*length(replicates)
  type<-c("D.num","D.percent")
  E<-NULL
  for(m in time.points){
    for(n in replicates){
      for(u in type){
        E0<-paste(m,"-",n,"-",u, sep="")
        E<-c(E,E0)}}}
  names(origin2)<-c("State","Start","End","Sequence","Charge",E)
  ## 
  trunc.1<-select(origin2, 1:5)
  cond<-names(origin2)[-(1:5)]
  trunc.1<-do.call("rbind",replicate(num, trunc.1, simplify=F)) ## trunc.1 repeated "num" times.
  ab<-NULL
  for(f in 1:(length(cond)/2)){
    ab0<-origin2[,cond[c(2*f-1, 2*f)]]
    ab0$Time<-strsplit(cond[2*f-1],"-")[[1]][1]
    ab0$Trial<-strsplit(cond[2*f-1],"-")[[1]][2]
    names(ab0)<-c("D.num","D.percent","Time","Trial")
    ab<-rbind(ab,ab0)}
  clean.data<-cbind(trunc.1, ab)  ## data now contains the formulated data of HDX.
  ## Here define the trimmer function, the arguments are (i) the data frame to be trimmed (data);(ii) the data frame containing the unwanted peptides (bad.peptides).
   trimmer<-function(data, bad.peptides){
     if(length(bad.peptides)>0){
     bp<-strsplit(bad.peptides,",", fixed = TRUE)
     bp<-do.call(rbind.data.frame,bp)
     names(bp)<-c("sq","cs")
    for(w in 1:nrow(bp)){
      sq<-as.character(bp$sq[w])
      cs<-as.numeric((as.character(bp$cs[w]) %>% strsplit("+", fixed=TRUE))[[1]][2])
      st<-strsplit(sq,"-")[[1]][1]
      ed<-strsplit(sq,"-")[[1]][2]
      data<-subset(data, !(Start==st & End==ed & Charge==cs))
    }}
     if(length(bad.peptides)==0){
       data<-data}
    return(data)
  }
  ## The final cleaned data set is here:
   clean.data<-trimmer(clean.data, bad.peptides)
  
   ## The final cleaned data set is here:
 grouped<-group_by(clean.data, State, Start, End, Sequence, Charge, as.numeric(Time))
  mn<-summarize(grouped, round(mean(D.percent,na.rm=T),2))
  sd<-summarize(grouped, sd(D.percent, na.rm=T))
  names(mn)<-c("State","Start","End","Sequence","Charge","Time","D.percent")
  mn$sd<-round(sd$`sd(D.percent, na.rm = T)`,2)
  final<-as.data.frame(mn)
  final$Start<-final$Start+0
  final$End<-final$End+0
  final
}
## The "final" is the final clean data.
