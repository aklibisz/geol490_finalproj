####
# Adam Klibisz Geol 490 Final Proj
####

library(shiny)


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      
      # Allows user to browse for a CSV file from their local machine
      fileInput("file1", "Choose CSV File",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")
      ),
      
      # Horizontal line for aesthetics and flow
      tags$hr(),
   
      p("Numeric Guesses for Nonlinear Function Solution"),
      
      # Split layout allows all the numeric inputs on one row    
      splitLayout(
              #### Numeric inputs will be fed to python code to 
              # serve as guesses for a nonlinear function to 
              #### create a trendline
              numericInput("g1", " ", 0),
              numericInput("g2", " ", 0),
              numericInput("g3", " ", 0)
      ),
      
      tags$hr(),
      
      
      actionButton("go", " ",
                   icon = icon("power-off"))
    ),
    mainPanel(
      plotOutput(" ")
    )
  )
)

server <- function(input, output) {
}

shinyApp(ui = ui, server = server)
