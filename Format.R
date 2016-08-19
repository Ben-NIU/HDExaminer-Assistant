Format<-function(unformat, howMany){
  unformat$iddd<-paste(unformat$Start, "-",unformat$End, " +",unformat$Charge, sep="")
  unformat$iddd<-factor(unformat$iddd, levels=unique(unformat$iddd))
  format1<-subset(unformat[order(unformat$iddd),], select=-c(iddd))
  t<-NULL
  for(i in 0:((nrow(format1)/(2*howMany))-1)) {
    t1<-rbind(as.data.frame(apply(format1[(i*2*howMany+1):((i+1)*2*howMany),], 2, function(x){rbind(x)})), data.frame(State="", Start="",End="",Sequence="",Charge="",Time="","D.percent"="",sd="",check.names = FALSE))
    t<-rbind(t,t1)
  }
  return(t)
}
