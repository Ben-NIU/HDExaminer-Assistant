library(shiny)
library(colourpicker)
library(DT)

shinyUI(fluidPage(
  titlePanel(
  fluidRow(column(8, p(strong("HDExaminer Assistant:",strong(em("H/DX Easy Plotting",style="font-family: 'britannic bold'; color:purple; font-size:15pt"))),style="font-family: 'britannic bold'"),
                  h4(em(strong("from", span("Gross Lab - Ben NIU", style="font-family:'gabriola';color:blue; font-size:15pt"))))),
           column(4, img(src="wustl_name.png", width=210, height=70, align="right") )
  )),

  sidebarLayout(
    sidebarPanel(
      fileInput("fileinput", label=div(h4(em("Input file here")),style="font-family:'marker felt';color:purple"), multiple = FALSE),
      textInput("timepoints", label=div(h4("Incubation time-point"), style="font-family:'marker felt';color:purple"), placeholder ='You can select from here...'),
      radioButtons("replicates", label=div(h4("How many replicates ?"),style="font-family:'marker felt';color:purple"), choices=list(2,3), selected=3),
      div(em(h5("Click to generate peptide table:")),style="font-family:'bradley hand';color:grey"),
      actionButton("act",label=div("Show Peptides Table", style="font-family:'marker felt';color:#3399FF")),
      br(),
      uiOutput("bdppt"),
      hr(),
      textInput("selplot", label=div(h4("Which peptide(s) to plot ?"),style="font-family:'marker felt';color:purple"), placeholder="E.g., enter 3-9...or 4,5,12..."),
      sliderInput("nrow", label=div(em(h5("Layout row #:")),style="font-family:'britannic bold'"), min=1, max=20, value=3,step=1),
      sliderInput("ncol", label=div(em(h5("Layout column #:")), style="font-family:'britannic bold'"), min=1, max=20, value=3, step=1)
    ),
    mainPanel(
      tabsetPanel(type="tabs",
        tabPanel(div("Table of Peptides",style="font-family:'comic sans ms';color:#006600"), DT::dataTableOutput("pepmap")),
        tabPanel(div("Kinetic Curves",style="font-family:'comic sans ms';color:#006600"),
                 br(),
   
         fluidRow(
           column(2,numericInput("transparent",label="Transparency",value=0.8, step = 0.1, max=1, min=0,width = "95%")),
           column(2,numericInput("ptsize", label="Point Size", value=3, step=1, max=8, min=0,width="95%")),
           column(2,colourInput("apo.col", label="Apo color",value="red",showColour = "both", palette = "square")),
           column(2,colourInput("holo.col", label="Holo color",value="blue",showColour = "both", palette = "square"))),
     hr(),
        fluidRow(
          column(3, textInput("S1", label="State1 Label", value="Apo")),
          column(3, textInput("S2", label="State2 Label", value="Holo"))
        ),
     hr(),
          fluidRow(
          column(4, actionButton("refresh", label="Refresh", icon = icon("refresh"))),
           column(4, downloadButton("spec.output", label="Output Kinetic Curves"))
         
           ),
           hr(),
         plotOutput("hdxcurves")
                 ),
        tabPanel(div("View Data",style="font-family:'comic sans ms';color:#006600"),
                 br(),
                 p('Click the', span('"View"', style="color:orange"), 'button to view the data table selected for kinetic curves. You can make use of the "Search Box" to filter the data table.'),
                 actionButton("vw", label=span("View it!", style="color:orange"), icon = icon("list-ol",lib = "font-awesome")),
                 br(),
                 br(),
                 DT::dataTableOutput("tbvw")
                 ),
        tabPanel(div("Download Data",style="font-family:'comic sans ms';color:#006600"),
                 br(),
                 p(strong("Instruction:"), em("Download the well-formatted data (in .csv) if you prefer to plot HD/X kinetic curves on your own.")),
                 p('Click the "Download" button below to download the whole dataset.'),
                 hr(),
                 downloadButton("fulldt", label="Download")
                 ),
        tabPanel(div("Byonic Convert", style="font-family:'comic sans ms';color:#006600"),
                  br(),
                  fileInput("from.byonic", label =div(h4(em("from Byonic search")),style="font-family:'marker felt';color:purple"), multiple = FALSE),
                  hr(),
                  downloadButton("output.byonic", label=span(em("ouput converted"), style="color:red"))
        
                  )
            )
    )
  )
))
      