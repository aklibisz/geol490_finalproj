####
# Adam Klibisz Geol 490 Final Proj
####

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Choose CSV File",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")
      ),
      
      tags$hr(),
   
      p("Numeric Guesses for Nonlinear Function Solution"),
          
            splitLayout(
              numericInput("g1", " ", 0, min = 0, max = 10000),
              numericInput("g2", " ", 0, min = 0, max = 10000),
              numericInput("g3", " ", 0, min = 0, max = 10000)
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
