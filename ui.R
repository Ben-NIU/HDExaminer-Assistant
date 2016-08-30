library(shiny)
library(DT)

shinyUI(fluidPage(
  titlePanel(
  fluidRow(column(8, p(strong("HDExaminer Assistant:",strong(em("H/DX Easy Plotting",style="font-family: 'kokonor'; color:purple; font-size:15pt"))),style="font-family: 'times'"),
                  h4(em(strong("from", span("Gross Lab - Ben NIU", style="font-family:'gabriola';color:blue; font-size:15pt"))))),
           column(4, img(src="wustl_name.png", width=210, height=70, align="right") )
  )),

  sidebarLayout(
    sidebarPanel(
      fileInput("fileinput", label=div(h4(em("Input file here")),style="font-family:'chalkduster';color:purple"), multiple = FALSE),
      textInput("timepoints", label=div(h4("Incubation time-point"), style="font-family:'marker felt';color:purple"), placeholder ='You can select from here...'),
      radioButtons("replicates", label=div(h4("How many replicates ?"),style="font-family:'marker felt';color:purple"), choices=list(2,3), selected=3),
      div(em(h5("Click to generate peptide table:")),style="font-family:'bradley hand';color:grey"),
      actionButton("act",label=div("Show Peptides Table", style="font-family:'marker felt';color:#3399FF")),
      br(),
      uiOutput("bdppt"),
      hr(),
      textInput("selplot", label=div(h4("Which peptide(s) to plot ?"),style="font-family:'marker felt';color:purple"), placeholder="E.g., enter 3-9...or 4,5,12..."),
      sliderInput("nrow", label=em(h5("Layout row #:")), min=1, max=20, value=3,step=1),
      sliderInput("ncol", label=em(h5("Layout column #:")), min=1, max=20, value=3, step=1)
    ),
    mainPanel(
      tabsetPanel(type="tabs",
        tabPanel(div("Table of Peptides",style="font-family:'comic sans ms';color:#006600"), DT::dataTableOutput("pepmap")),
        tabPanel(div("Kinetic Curves",style="font-family:'comic sans ms';color:#006600"),
                 br(),
   
         fluidRow(
           column(2,numericInput("transparent",label="Transparency",value=0.8, step = 0.1, max=1, min=0,width = "95%")),
           column(3,numericInput("ptsize", label="Point Size", value=3, step=1, max=8, min=0,width="95%")),
           column(3,selectInput("apo.col", label="Apo color",choices=list("orange"="#E69F00","light blue"="#56B4E9","green"="#009E73","dark blue"="#0072B2","dark pink"="#CC79A7"), selected="#CC79A7")),
           column(3,selectInput("holo.col", label="Holo color",choices=list("orange"="#E69F00","light blue"="#56B4E9","green"="#009E73","dark blue"="#0072B2","dark pink"="#CC79A7"), selected="#0072B2"))),
           hr(),
         plotOutput("hdxcurves")
                 ),
        tabPanel(div("View Data",style="font-family:'comic sans ms';color:#006600"),
                 br(),
                 p('Click the', span('"View"', style="color:orange"), 'button to view the data table selected for kinetic curves. You can make use of the "Search Box" to filter the data table.'),
                 actionButton("vw", label=div("View it!", style="color:orange"), width = "20%"),
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
                 )
            )
    )
  )
))
      