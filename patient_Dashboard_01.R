##Date 20-09-2023


# Install
#install.packages("shiny")
#install.packages("data.table")

# load necessary packages
library(shiny)
library(data.table)
library(DT)
library(ggplot2)


# Define the UI
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

# Define the server
server <- function(input, output) {
  # Load data from the CSV file
  patient_data <- reactive({
    data <- fread("JanJuly2023_04.csv")  # Replace with your file path if not in the working directory
    data$visit_date <- as.Date(data$visit_date)
    return(data)
  })
  
  # Filter data based on date range
  filtered_data <- reactive({
    start_date <- input$date_range[1]
    end_date <- input$date_range[2]
    print(start_date)
    print(end_date)
    
    # Filter the patient_data based on visit_date within the selected date range
    filtered <- patient_data()[visit_date >= start_date & visit_date <= end_date]
    print(head(filtered))
    return(filtered)
  })
  
  # Render the data table
  output$table <- renderDataTable({
    datatable(filtered_data())
  })
  
  ### ----------------------------------###
  
  # Render a bar chart with data values
  output$bar_chart <- renderPlot({
    data <- filtered_data()
    
    ggplot(data, aes(x = age_group)) +
      geom_bar() +
      geom_text(
        aes(label = ..count..),
        stat = "count",
        vjust = -0.5,
        position = position_stack()
      ) +
      labs(title = "Age Group Distribution")
  })
  
  
  ### ------------------------------------###
  
  # Render a pie chart
  output$pie_chart <- renderPlot({
    age_group_counts <- data[, .N, by = age_group]
    ggplot(age_group_counts, aes(x = "", y = N, fill = age_group)) +
      geom_bar(stat = "identity") +
      geom_text(aes(label = N), position = position_stack(vjust = 0.5)) +
      coord_polar("y", start = 0) +
      labs(title = "Age Group Distribution")
  })
  
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
