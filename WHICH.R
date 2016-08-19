WHICH<-function(which){
sot<-strsplit(gsub(" ","",which), "-", fixed = TRUE)[[1]]
which<-if (length(sot) >1) {(as.numeric(sot[1]):as.numeric(sot[2]))
} else {          
  as.numeric(strsplit(sot, ",", fixed = TRUE)[[1]])
}
return(which)
}