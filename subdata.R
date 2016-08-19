subdata<-function(origin, bad.peptides,rep,which, time.points="10,20,30"){
source("HDXpepmap.combo.R")
source("HDXdata.combo.R")
plot.data<-HDXdata.combo(origin, bad.peptides, time.points,rep)
pep.map<-HDXpepmap.combo(plot.data, time.points)

sub<-NULL
for(t in which){
  sub0<-subset(plot.data, Sequence==as.character(pep.map$Sequence[t]) & Charge==pep.map$Charge[t])
  sub0$peptide<-paste(pep.map$Start[t],"-",pep.map$End[t],"   ","(+",pep.map$Charge[t],")",sep="")
  sub<-rbind(sub,sub0)}
gp<-reorder(unique(sub$peptide), 1:length(unique(sub$peptide)))
sub$peptide<-rep(gp, each=2*length(strsplit(time.points, ",", fixed = TRUE)[[1]]))
sub}