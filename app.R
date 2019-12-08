####
# Adam Klibisz Geol 490 Final Proj
####

library(shiny)
library(ggplot2)


ui <- fluidPage(
  
  #title for whole page
  titlePanel("Microbial Decay Analysis"),
  
  #area of app for user inputs
  sidebarLayout(
    
    sidebarPanel(
      
      # Allows user to browse for a CSV file from their local machine
      fileInput("file1", "Choose CSV File",
                multiple = FALSE,
                accept = c( "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")),
      
      # user inputs whether the file includes headers such as column names
      checkboxInput("header", "Column headers?", TRUE),
   
      # user inputs what character distinguishes data beginning and end
      radioButtons("sep", "Row separator/delimiter?",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ","),
      
      tags$hr(),
      
      p("Numeric Guesses for Nonlinear Function Solution"),
      
      # Split layout allows all the numeric inputs on one row    
      splitLayout(
              #### Numeric inputs will be fed to python code to help solve nonlinear functions
              numericInput("num1", " ", 0),
              numericInput("num2", " ", 0),
              numericInput("num3", " ", 0)
      ),
      
      tags$hr(),
      
      
      actionButton("go", " ",
                   icon = icon("power-off"))
    ),
    mainPanel(
      tableOutput(" ")
    )
  )
)

server <- function(input, output) {
  


}

shinyApp(ui = ui, server = server)
