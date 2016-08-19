## This function generates the "pep.map", which incorporates all the peptides of interests (to be plotted).
## All you need to do is to specify the filename, e.g., filename="11", and then specify the bad.peptides list,
## so that this function will internally call the HDXdata.combo.R fucntion first and calculate the corresponding formatted data,
## and then convert to pep.map.

## The pep.map will give users a good idea of the attributes of peptides (Sequence, charge state, starting/ending number)
## so that they can decide which peptides are to be plotted in the next step.

## Note: this fucntion only suits the datafile with two sets of protein states (apo/holo) present simultaneously.

HDXpepmap.combo<-function(data,time.points){
 state1<-subset(data, State==names(table(data$State)[1]))
 time.points<-(gsub(" ","",time.points) %>% strsplit(",", fixed=TRUE))[[1]]
uopo<-length(time.points)
diff<-nrow(state1)/uopo
SQ<-NULL
CS<-NULL
begin<-NULL
last<-NULL
uopo<-length(time.points)
for(j in 1:diff){
  SQ0<-as.character(state1$Sequence[(j-1)*uopo+1])
  CS0<-state1$Charge[(j-1)*uopo+1]
  begin0<-state1$Start[(j-1)*uopo+1]
  last0<-state1$End[(j-1)*uopo+1]
  SQ<-c(SQ,SQ0)
  CS<-c(CS,CS0)
  begin<-c(begin, begin0)
  last<-c(last,last0)}
pep.map<-data.frame("Sequence"=SQ, "Charge"=CS,"Start"=as.integer(begin),"End"=as.integer(last))
pep.map
}
