library(shiny)
library(ggplot2)
source("HDXdata.combo.R")
source("HDXpepmap.combo.R")
source("subdata.R")
source("WHICH.R")
source("Format.R")

shinyServer(function(input, output) {
  origin<-reactive({
    validate(
      need(input$fileinput$datapath != "", "")
  )
    read.csv(input$fileinput[['datapath']], skip=1) })
  output$bdppt<-renderUI({
    all.ppt<-unique(paste(origin()$Start,"-",origin()$End,",   +",origin()$Charge,sep=""))
    selectInput("bdppt",label=div(h4("Select peptide(s) you'd like to discard"),style="font-family:'marker felt';color:purple"), choices = all.ppt, multiple = TRUE)
  })
  dataIn<-eventReactive(input$act,{HDXdata.combo(origin(),bad.peptides=input$bdppt,time.points = input$timepoints, rep=input$replicates)})
  dataF<-reactive({HDXpepmap.combo(dataIn(), time.points = input$timepoints)})
 height<-reactive({180*input$nrow})
 TM<-reactive({(gsub(" ","",input$timepoints) %>% strsplit(",", fixed=TRUE))[[1]] })
 output$fulldt<-downloadHandler(filename=function(){paste("formatted_",input$fileinput$name,sep="")},
                                content=function(file){write.csv(Format(dataIn(),length(TM())), file)})
 
 sub<-reactive({
   validate(
     need(input$selplot !="", "Reminder: Please specify WHICH PEPTIDE(S) TO PLOT and make sure you have ENOUGH panels, turn up Slider Bars of Row/Column number if necessary.")
   )
   subdata(origin(), input$bdppt, input$replicates, WH(),input$timepoints)})
sub1<-sub
viewDT<-eventReactive(input$vw,{sub1()})
WH<-reactive({WHICH(input$selplot)})
output$tbvw<-DT::renderDataTable({
  return(viewDT())}, options=list(lengthMenu=list(c(10,25,50,-1),c("10","25","50","ALL")), pageLength=10))
  ## end of prep.
  output$pepmap<-DT::renderDataTable({
    return(dataF())}, options=list(lengthMenu=list(c(10,25,50,-1), c("10","25","50","ALL")), pageLength=25))
  output$hdxcurves<-renderPlot({
    limits<-aes(ymax=D.percent +sd, ymin=D.percent -sd,width=0.1)
    ggplot(data=sub(), aes(x=Time, y=D.percent, group=State,color=State)) + geom_point(size=input$ptsize) + geom_line(alpha=input$transparent,size=2)+lims(y=c(-2,100)) + geom_errorbar(limits) + scale_x_continuous(trans="log10") + annotation_logticks(base=10, sides="b",size=0.7, linetype = 1,mid = unit(0.1,"cm"),long = unit(0.2,"cm")) +facet_wrap(~peptide, nrow=input$nrow, ncol=input$ncol) + scale_color_manual(name="Sample",breaks=as.character(unique(sub()$State)), labels=c("apo","holo"), values=c(input$apo.col,input$holo.col)) +theme(strip.background=element_rect(fill="white")) + theme(panel.background=element_rect(fill="white",color="black"), panel.grid.major=element_line(color="gray95"),panel.grid.minor=element_blank(),strip.text=element_text(face="bold",size=12)) + labs(x="Time (sec)",y="Deuterium uptake %") + theme(legend.position="top")+theme(panel.border=element_rect(fill=NA, color="black", size=1))+ theme(legend.title=element_text(color="black", size=14, face="bold"), legend.text=element_text(size=14, color="black",face="bold")) + theme(axis.text.x=element_text(size=13),axis.text.y=element_text(size=13), axis.title.x=element_text(size=13),axis.title.y=element_text(size=13))
    
  }, height=height)
})
  
