##Date 20-09-2023


# set the path for my folder in system, you can set you path

setwd("C:\\Users\\vinay_bijalwan.PATANJALI\\Desktop\\data_analysis_with_R\\01_Shiny_app")



#> Load require library 

library(shiny)
library(DT)
library(data.table)

# Define UI

ui <- shinyUI(fluidPage(
  
  fileInput('target_upload', 'Choose file to upload',
            accept = c(
              'text/csv',
              'text/comma-separated-values',
              '.csv'
            )),
  radioButtons("separator","Separator: ",choices = c(";",",",":"), selected=";",inline=TRUE),
  DT::dataTableOutput("sample_table")
)
)

# Define server logic
server <- shinyServer(function(input, output) {
  
  df_products_upload <- reactive({
    inFile <- input$target_upload
    if (is.null(inFile))
      return(NULL)
    df <- fread(inFile$datapath, header = TRUE,sep = input$separator)
    return(df)
  })
  
  output$sample_table<- DT::renderDataTable({
    df <- df_products_upload()
    DT::datatable(df)
  })
  
}
)

# Run the application 
shinyApp(ui = ui, server = server)