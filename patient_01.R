##Date 20-09-2023


# set the path for my folder in system, you can set you path

setwd("C:\\Users\\vinay_bijalwan.PATANJALI\\Desktop\\data_analysis_with_R\\01_Shiny_app")




# load packages
library(data.table)
# global  ----------------------------------------
library(shiny)


library(ggplot2)


#> Load data Set 
#patient <- fread("z_data_set.csv")

patient <- fread("JanJuly2023_04.csv")
### or second option -----##

# Create sample patient data
patient_data <- data.table(
  Name = c("Patient1", "Patient2", "Patient3"),
  DoctorName = c("DoctorA", "DoctorB", "DoctorC"),
  DiseaseName = c("Disease1", "Disease2", "Disease3"),
  Age = c(30, 45, 22),
  AgeGroup = c("18-30", "31-45", "18-30")
)

##in this example we use csv file 

ui <- fluidPage(
  titlePanel("Patient Dashboard"),
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("date_range", "Date Range", start = NULL, end = NULL),
      # Add other input elements here if needed
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Data Table", dataTableOutput("table")),
        tabPanel("Bar Chart", plotOutput("bar_chart")),
        tabPanel("Pie Chart", plotOutput("pie_chart"))
        # Add more tabs for additional plots if needed
      )
    )
  )
)


server <- function(input, output) {
  
  # Filter data based on date range
  filtered_data <- reactive({
    start_date <- input$date_range[1]
    end_date <- input$date_range[2]
    
    # Filter the patient_data based on date range
    patient[visit_date >= start_date & visit_date <= end_date]
  })
  
  
  # Render the data table
  output$table <- renderDataTable({
    datatable(filtered_data())
  })
  
  # Render a bar chart
  output$bar_chart <- renderPlot({
    ggplot(patient, aes(x = age_group)) +
      geom_bar() +
      labs(title = "Age Group Distribution")
  })
  
  # Render a pie chart
  output$pie_chart <- renderPlot({
    age_group_counts <- patient[, .N, by = age_group]
    ggplot(age_group_counts, aes(x = "", y = N, fill = age_group)) +
      geom_bar(stat = "identity") +
      coord_polar("y", start = 0) +
      labs(title = "Age Group Distribution")
  })
  
  
}

# run app  --------------------------------------
shinyApp(ui = ui, server = server)

