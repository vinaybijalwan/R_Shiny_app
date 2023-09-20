#Date: 19-09-2023

## Basic of Shiny App

##First install 
#install.packages("shiny")

#--------------------#
#then Load Shiny 
# It calls library(shiny) to load the shiny package
library(shiny)
##-------------------------##


##--- first content ---------##
ui <- fluidPage(
  "Hello, world!"
)

## It defines the user interface, the HTML webpage 
#that humans interact with. In this case, it's a page
#containing the words "Hello, world!".

##-------------------------------##



## -------define server ----------------##
server <- function(input, output, session) {
}

##---------------------------------------------##


##------------run app -------------##
shinyApp(ui, server)
##---------------------------------##

