library(shiny)
library(ggplot2)
source("HDXdata.combo.R")
source("HDXpepmap.combo.R")
source("subdata.R")
source("WHICH.R")
source("Format.R")
source("hdx.curve.R")
source("Byonic.HDX.format.R")

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
 WH<-reactive({WHICH(input$selplot)})
 
 sub<-reactive({
   validate(
     need(input$selplot !="", "Reminder: Please specify WHICH PEPTIDE(S) TO PLOT and make sure you have ENOUGH panels, turn up Slider Bars of Row/Column number if necessary.")
   )
   subdata(origin(), input$bdppt, input$replicates, WH(),input$timepoints)})
sub1<-sub
viewDT<-eventReactive(input$vw,{sub1()})

output$tbvw<-DT::renderDataTable({
  return(viewDT())}, options=list(lengthMenu=list(c(10,25,50,-1),c("10","25","50","ALL")), pageLength=10))
  ## end of prep.
  output$pepmap<-DT::renderDataTable({
    return(dataF())}, options=list(lengthMenu=list(c(10,25,50,-1), c("10","25","50","ALL")), pageLength=25))


 ## the theme(aspect.ratio=1) set the y/x of each panel to be 1, so comes out a square-looking plot for each kinetic curve panel.
  
observeEvent(input$refresh,{  
output$hdxcurves<-renderPlot({
 isolate({ hdx.curve(sub(), input$ptsize, input$transparent, input$S1, input$S2, input$apo.col, input$holo.col, input$nrow, input$ncol)
 })
  }, height = height)
})
  
output$spec.output<-downloadHandler(filename = function(){paste("HDX-",Sys.Date(),".png", sep="")}, content = function(file){
    device<-function(...,width=width, height=height) grDevices::png(..., width = width, height = height, res=300, units = "in")
    
    ggsave(file, plot = isolate(hdx.curve(sub(), input$ptsize, input$transparent, input$S1, input$S2, input$apo.col, input$holo.col, input$nrow, input$ncol)
    ), device = "png", height = 2*input$nrow, width = 2.2*input$ncol,dpi = 400) }, contentType = "image/png")  
  
cvtd<-reactive({Byonic.HDX.format(input$from.byonic[['datapath']])})
output$output.byonic<-downloadHandler(filename= function(){paste("HDX-Byonic-", Sys.Date(),".csv", sep="")}, content = function(file){
  write.csv(cvtd(), file, row.names = FALSE)}
  )
  
})
  
