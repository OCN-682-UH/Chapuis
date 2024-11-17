# Week 12 Assignment - Make a Shiny app

# Using TidyTuesday data from February 2024:
# https://github.com/rfordatascience/tidytuesday/blob/master/data/2024/2024-02-13/readme.md


library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Valentine's Day Consumer Data"), # adds a title at the top
    
    
    # First set of sidebar + main panel
    sidebarLayout( # type of layout
        sidebarPanel( # panel in the sidebar
          selectInput("select1", # input ID
                      label = h3("Select Item to Plot by Year"), # title of the dropdown box
                      choices = list("Candy", "Flowers", "Jewelry", "GreetingCards", "EveningOut", "Clothing", "GiftCards") # things to choose from (matches data column names)
                      ),
                    ),

        # Plot chosen data by year in main panel
        mainPanel(
           plotOutput("linePlot")
        )
    ),
    
    # Second set of sidebar + main panel
    sidebarLayout( # type of layout
      sidebarPanel( # panel in the sidebar
        selectInput("select2", # input ID
                    label = h3("Select Item to Plot by Gender"), # title of dropdown box
                    choices = list("Candy", "Flowers", "Jewelry", "GreetingCards", "EveningOut", "Clothing", "GiftCards") # things to choose from (matches data column names)
                    )
                  ),
      
      # Plot chosen data by gender in main panel
      mainPanel(
        plotOutput("barPlot")
      )
    )
)


# Define server
server <- function(input, output) {
  
  ## Dynamic Figure
  yearly_data <- reactive(readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-02-13/historical_spending.csv') %>%
                     select(Year, Candy, Flowers, Jewelry, GreetingCards, EveningOut, Clothing, GiftCards) %>% # select columns I want to keep
                     pivot_longer(!Year, names_to = "Item", values_to = "Value") %>% # pivot to long
                     filter(Item %in% input$select1)) # filter to only keep the selected item (from the dropdown)
  
  ### NOTE: all data cleaning/manipulation has to happen inside reactive() parentheses
  
  output$linePlot <- renderPlot({ # make plot
        ggplot(yearly_data(), aes(x = Year, y = Value)) + # remember data is now a function so needs ()
          geom_line() + # lines to connect the points
          geom_point() + # the points
          theme_minimal() + # do I still need to comment this
          labs(y = "Average Amount Spent (USD)") + # y axis title
          theme(axis.text = element_text(size = 12), # text sizes
                axis.title = element_text(size = 14)) +
      scale_x_continuous(breaks = seq(2010, 2022, by = 1)) # specify x axis labels (every 1 year)
    })
  
  
  ## Additional Output
  gender_data <- reactive(readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-02-13/gifts_gender.csv') %>%
                          select(!SpendingCelebrating) %>% # remove extra column
                          pivot_longer(!Gender, names_to = "Item", values_to = "Value") %>% # pivot long
                          filter(Item %in% input$select2)) # choose item to plot from drop down
  
  
  output$barPlot <- renderPlot({ # make plot 
    ggplot(gender_data(), aes(x = Gender, y = Value, fill = Gender)) + # remember data is now a function so needs ()
      geom_bar(stat = "identity") + # stat identity means I provide the y values from the data
      theme_minimal() + 
      labs(y = "Average Amount Spent (USD)") + # y axis title
      theme(axis.text = element_text(size = 12), # text sizes
            axis.title = element_text(size = 14)) + 
      scale_fill_manual(values = c("#95b8d1", "#eac4d5"), guide = "none") # set colors for bars and remove legend
    })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
