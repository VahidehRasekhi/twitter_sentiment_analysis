

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Sentiment Analysis of COVID and Vaccination Tweets"),

    sidebarLayout(
        
        sidebarPanel(
            selectInput("selected_location",
                        label = h3("Choose City:"),
                        choices = unique(sort(covid_tweets$location)),
                        selected = 1),
            #h3("Select Location"),
            selectInput("selected_location",
                        label = h3("Choose Country:"),
                        choices = unique(sort(covid_tweets$country)),
                        selected = 1),
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            
            # Output: Tabset w/ plot, summary, and table ----
            tabsetPanel(type = "tabs",
                        tabPanel("Countries in Datatset", plotOutput("countries")),
                        tabPanel("States in the US", plotOutput("US_states")),
                        tabPanel("Map of Sentiments in US", leafletOutput("USmap")),
                        tabPanel("Map of Sentiments in the World", plotOutput("Worldmap")),
                        
            )
            
        )
    )
)

)