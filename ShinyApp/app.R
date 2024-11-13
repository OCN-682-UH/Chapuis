# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

## Load Libraries
library(shiny)
library(tidyverse)


## Create the UI
ui <- fluidPage(
  # Input functions
  
  # slider to choose number of data points
  sliderInput(inputId = "num", # ID name for the input
              label = "Choose a number:", # Label above the input
              value = 25, min = 1, max = 100 # values for the slider
  ), # make sure we use a comma here
  
  # text input to choose title of the plot
  textInput(inputId = "title", # new Id is title
            label = "Write a title:",
            value = "Histogram of Random Normal Values"), # starting title
  

  # Output functions
  plotOutput("hist"), #creates space for a plot called "hist" to appear (not creating the actual plot itself)
  
  verbatimTextOutput("stats") # create a space for stats
  
)

## Server
server <- function(input,output){
  
# function where we create the data
  data <- reactive({  # this is a function. reactive makes it so it only changes when we move the slider and not every time
    tibble(x = rnorm(input$num)) # the number we choose with our slider ("num") is what goes into this normally distributed data
  })
  
# function where we create the plot
  output$hist <- renderPlot({ # need to refer to plot called "hist" we put in the UI
    # {} allows us to put all our R code in one nice chunk

    ggplot(data(), aes(x = x)) + # make a histogram - data() because we're using the reactive created above which is a function
      geom_histogram() +
      labs(title = input$title) # add title based on user input
  })
  
# function where we display the stats
  output$stats <- renderPrint({ # refer to the stats input we put in the UI
    summary(data()) # calculate summary stats based on the number we get from the slider (reactive data() function)
  })
  
  
}

shinyApp(ui = ui, server = server)

