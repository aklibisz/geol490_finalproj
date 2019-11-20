####
# Adam Klibisz Geol 490 Final Proj
####

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose CSV File",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")
      ),
      
      numericInput("g1", "Guess 1", 0, min = 0, max = 10000),
      numericInput("g2", "Guess 2", 0, min = 0, max = 10000),
      numericInput("g3", "Guess 3", 0, min = 0, max = 10000),
      
      actionButton("go", " ",
                   icon = icon("power-off"))
    ),
    mainPanel(
      tableOutput("contents")
    )
  )
)

server <- function(input, output) {
}

shinyApp(ui, server)
