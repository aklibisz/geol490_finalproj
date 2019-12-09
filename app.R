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
      checkboxInput("header", "Headers?", TRUE),
   
      # user inputs what character distinguishes data beginning and end
      radioButtons("sep", "Separator",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ","),
      
      radioButtons("quote", "Quote",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = '"'),
      
      # Input: Select number of rows to display ----
      radioButtons("disp", "Display",
                   choices = c(Head = "head",
                               All = "all"),
                   selected = "head"),
      
      tags$hr(),
      
      
      p("Numeric Guesses for Nonlinear Function Solution"),
      
      # Split layout allows all the numeric inputs on one row    
      splitLayout(
              #### Numeric inputs will be fed to python code to help solve nonlinear functions
              numericInput("num1", " ", 0),
              numericInput("num2", " ", 0),
              numericInput("num3", " ", 0)
      ),
      
      actionButton("go", "Plot",)
    ),
    
    mainPanel(
      tableOutput("contents")
    )
  )
)

server <- function(input, output) {
  
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file1)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        df <- read.csv(input$file1$datapath,
                       header = input$header,
                       sep = input$sep,
                       quote = input$quote)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
    if(input$disp == "head") {
      return(head(df))
    }
    else {
      return(df)
    }
    
  })
  
}

shinyApp(ui = ui, server = server)
