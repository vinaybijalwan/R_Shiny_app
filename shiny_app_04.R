# Load necessary libraries
library(shiny)
library(data.table)

# Sample data
data <- data.table(
  Name = c("Alice", "Bob", "Charlie", "David"),
  Age = c(25, 30, 22, 35),
  Score = c(90, 85, 78, 92)
)

# Define the user interface (UI)
ui <- fluidPage(
  titlePanel("Shiny App with data.table"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("filter_name", "Filter by Name", ""),
      sliderInput("filter_age", "Filter by Age", min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(
      dataTableOutput("table")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  
  # Create a reactive data table
  filtered_data <- reactive({
    dt <- data
    if (input$filter_name != "") {
      dt <- dt[grepl(input$filter_name, dt$Name, ignore.case = TRUE)]
    }
    dt <- dt[dt$Age >= input$filter_age[1] & dt$Age <= input$filter_age[2]]
    return(dt)
  })
  
  # Render the data table
  output$table <- renderDataTable({
    filtered_data()
  })
}

# Run the Shiny app
shinyApp(ui, server)
