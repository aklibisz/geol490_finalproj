### Geol 490 Fall 2019 Final Project
# Adam Klibisz
### 12 December 2019

# several parts of this code are heavily adapted from shiny.rstudio.com and stackoverflow

### https://shiny.rstudio.com/gallery/file-upload.html
# showed me the needed user inputs to use read.csv properly and showed me the code for only displaying the head of a dataframe

### https://stackoverflow.com/questions/36949769/how-to-plot-uploaded-dataset-using-shiny/36955396
# specifically big thanks to user Michal Majka for their answer
# showed me how to properly reference the column names from a user-input file to actually get a plot
# showed me the tabsetPanel style for the app because I was originally only able to tabset the main panels


library(shiny)
library(ggplot2)

ui <- fluidPage(
  
  titlePanel("Microbial Decay Analysis"),
  
  # tabset panels allow to have multiple side and main panels working with the same server
  tabsetPanel(
    tabPanel("Data", #displayed name of tab
      
             sidebarLayout(
               sidebarPanel(
                 fileInput('file1', 'Choose CSV File',
                           multiple = FALSE,
                           
                           # limit the acceptable file type to csv
                           accept=c('text/csv', 
                                    'text/comma-separated-values,text/plain', 
                                    '.csv')),

                 #user provides info about header, separator, quote, and how much data to display
                 #this is used by read.csv to read the csv properly
                 #the effect of this can be seen in real time if you pick a different option when the app is running
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
                 #output the table output$contents, created in the server, on the main panel of the data tab
                 tableOutput('contents')
               )
             )
    ),
    
    #another tab for the plot
    tabPanel("Plot",
             pageWithSidebar(
               headerPanel(' '),
               sidebarPanel(
                 
                 #getting numeric input from user to feed to the nonlinear python function
                 p("Numeric Guesses for Nonlinear Function Solution"),
                 #split layout allows the small boxes to sit horizontally together
                 #rather than getting stacked vertically and taking up too much space
                 splitLayout(
                   numericInput("num1", " ", 0),
                   numericInput("num2", " ", 0),
                   numericInput("num3", " ", 0)
                 ),
                 
                 #horizontal line to distinguish the main sections of this side panel
                 tags$hr(),
                 
                 # Empty inputs that will be updated after the data is uploaded
                 selectInput('xcol', 'X Variable', ""),
                 selectInput('ycol', 'Y Variable', "", selected = ""),
                 
                 #action button used to prevent premature plotting
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
  #using session because the function updateSelectInput requires it
  
  
  data <- reactive({ 
    req(input$file1) #data input must be available before anything else happens
    
    #not sure how this works to be honest
    #but if you try to just read.csv(input$file)
    #you get an error that input is missing
    #so this somehow avoids that issue
    inFile <- input$file1 
    
    #using the inputs from the data tab
    df <- read.csv(inFile$datapath, header = input$header, sep = input$sep,
                   quote = input$quote)
    
    #not sure precisely how this works but roughly
    #this updates the input variables on the plot tab as soon as the data is fed in
    #to have the csv header names as options for the x and y axes
    
    #this solved the most challenging part of all this code, so big thanks to Michal Majka on StackOverflow
    updateSelectInput(session, inputId = 'xcol', label = 'X Variable',
                      choices = names(df), selected = names(df))
    updateSelectInput(session, inputId = 'ycol', label = 'Y Variable',
                      choices = names(df), selected = names(df)[2])
    
    #if statement based on user input to decide how much data to display on the data tab
    if(input$disp == "head") {
      return(head(df))
    }
    else {
      return(df)
    }
  })
  
  #a separate output for the processed data so that the data can be used further in the server
  output$contents <- renderTable({
    data()
  })
  
  #creating a plot separate from the output of the plot because
  #the action button didn't work when I created the plot inside the output object for the plot
  p_df <- eventReactive(input$go, {
    #basic ggplot code that can be easily editted for a different style of plot
    ggplot(data(), aes_string(x = input$xcol, y = input$ycol)) + 
      geom_line() +
      geom_point()
    
  })
  
  #separate object for the output so that the action button works, as referenced above
  output$df_plot <- { renderPlot({
    p_df()
  })
  }
})  

shinyApp(ui, server)