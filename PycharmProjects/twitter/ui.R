

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Sentiment Analysis of COVID and Vaccination Tweets"),

    sidebarLayout(
        sidebarPanel(
            selectInput("selected_country",
                        label = h3("Choose Country:"),
                        choices = unique(sort(total_countries$country)),
                        selected = 1),
            selectInput("selected_subcountry",
                        label = h3("Choose State:"),
                        choices = unique(sort(total_subcountries$subcountry)),
                        selected = 1),
            selectInput("selected_city",
                        label = h3("Choose City:"),
                        choices = unique(sort(covid_tweets$location)),
                        selected = 1),
            #h3("Select Location"),
            
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            
            # Output: Tabset w/ plot, summary, and table ----
            tabsetPanel(type = "tabs",
                        
                        tabPanel("Sentiment in the US", tableOutput("US_states")),
                        tabPanel("Sentiment in the World", tableOutput("world_countries")),
                        tabPanel("Map of Sentiments in US", leafletOutput("USmap")),
                        tabPanel("Map of Sentiments in the World", leafletOutput("Worldmap")),
                        tabPanel("Global choropleth map", plotlyOutput("Globalmap")),
                        tabPanel("Barchart", plotOutput("countrybarchart"))
   
                )                     
            )
            
        )
    )
)


