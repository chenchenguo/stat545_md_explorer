#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tidyverse)
library(dplyr)

bcl <- read.csv(file="D:/STAT545_Rfile/STAT545_participation/STAT547/cm07/bcl/bcl-data.csv", stringsAsFactors = FALSE)
# Define UI for application that draws a histogram

ui <- fluidPage(
  titlePanel("BC Liquor price app", 
             windowTitle = "BCL app"),
  sidebarLayout(
    sidebarPanel(
      #this only add a slider input still need to link to the table
      #priceInput need to be accessed: input$priceInput
      sliderInput("priceInput", "Select your desired price range.",
                  min = 0, max = 100, value = c(15, 30), pre="$"),
      
      #exercise radio button
      #also need to link to server
      radioButtons("typeInput", "Select your type of the beverage",
                   choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),
                   selected = "WINE")
      
    ),
    mainPanel(
      plotOutput("price_hist"),
      tableOutput("bcl_data")
      
    )
  )
  
)

# Run code in server and display the output in UI
# *output()

# Define server logic required to draw a histogram
server <- function(input, output) {
  #print out in the console about the input range
  observe(print(input$priceInput))
  bcl_filtered <- reactive({
    bcl %>% 
      filter(Price < input$priceInput[2], 
             Price > input$priceInput[1],
             Type == input$typeInput)
  }) 
  
  output$price_hist <- renderPlot({
    bcl_filtered() %>%
      ggplot(aes(Price))+
      geom_histogram()
    
    
  })
  output$bcl_data <- renderTable({
    bcl_filtered()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

