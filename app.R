library(shiny)
library(ggplot2)

ui <- fluidPage(
  
  titlePanel("Microbial Decay Analysis"),
  
  tabsetPanel(
    tabPanel("Data",
      
             sidebarLayout(
               sidebarPanel(
                 fileInput('file1', 'Choose CSV File',
                           multiple = FALSE,
                           accept=c('text/csv', 
                                    'text/comma-separated-values,text/plain', 
                                    '.csv')),

                 checkboxInput('header', 'Header', TRUE),
                 radioButtons('sep', 'Separator',
                              c(Comma=',',
                                Semicolon=';',
                                Tab='\t'),
                              ','),
                 radioButtons('quote', 'Quote',
                              c(None='',
                                'Double Quote'='"',
                                'Single Quote'="'"),
                              '"'),
                 
                 radioButtons("disp", "Display",
                              choices = c(Head = "head",
                                          All = "all"),
                              selected = "head")
                 
               ),
               mainPanel(
                 tableOutput('contents')
               )
             )
    ),
    tabPanel("Plot",
             pageWithSidebar(
               headerPanel(' '),
               sidebarPanel(
                 
                 p("Numeric Guesses for Nonlinear Function Solution"),
                 
                 splitLayout(
                   #### Numeric inputs will be fed to python code to help solve nonlinear functions
                   numericInput("num1", " ", 0),
                   numericInput("num2", " ", 0),
                   numericInput("num3", " ", 0)
                 ),
                 
                 tags$hr(),
                 
                 # "Empty inputs" - they will be updated after the data is uploaded
                 selectInput('xcol', 'X Variable', ""),
                 selectInput('ycol', 'Y Variable', "", selected = ""),
                 
                 actionButton("go", " ",
                              icon = icon("power-off"),
                              selected = " ")
                 
               ),
               mainPanel(
                 plotOutput("df_plot")
               )
             )
    )
    
  )
)

server <- shinyServer(function(input, output, session) {
  # added "session" because updateSelectInput requires it
  
  
  data <- reactive({ 
    req(input$file1) ## ?req #  require that the input is available
    
    inFile <- input$file1 
    
    # tested with a following dataset: write.csv(mtcars, "mtcars.csv")
    # and                              write.csv(iris, "iris.csv")
    df <- read.csv(inFile$datapath, header = input$header, sep = input$sep,
                   quote = input$quote)
    
    
    # Update inputs (you could create an observer with both updateSel...)
    # You can also constraint your choices. If you wanted select only numeric
    # variables you could set "choices = sapply(df, is.numeric)"
    # It depends on what do you want to do later on.
    
    updateSelectInput(session, inputId = 'xcol', label = 'X Variable',
                      choices = names(df), selected = names(df))
    updateSelectInput(session, inputId = 'ycol', label = 'Y Variable',
                      choices = names(df), selected = names(df)[2])
    
    if(input$disp == "head") {
      return(head(df))
    }
    else {
      return(df)
    }
  })
  
  output$contents <- renderTable({
    data()
  })
  
  p_df <- eventReactive(input$go, {
    ggplot(data(), aes_string(x = input$xcol, y = input$ycol)) + 
      geom_line() +
      geom_point()
    
  })
  
  output$df_plot <- { renderPlot({
    p_df()
  })
  }
})  

shinyApp(ui, server)