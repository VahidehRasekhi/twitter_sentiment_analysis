

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
                        choices = unique(sort(total_cities$location)),
                        selected = 1),
                    ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            tabsetPanel(
                tabPanel("Sentiment in the US",
                          tabsetPanel(
                              tabPanel("US Data Table",tableOutput("UStable")),
                              tabPanel("US States",plotOutput("US_states_barplot")),
                              tabPanel("Graphs", plotOutput("USbarplot")),
                               tabPanel("Map of Sentiments in US", leafletOutput("USmap")),
                                  )#inner tabset panel
                                 ), #tab panel
                
            tabPanel("Sentiment in the World", 
                     tabsetPanel(
                         tabPanel("World Data Table",tableOutput("Worldtable")),
                         tabPanel("Graphs", plotOutput("Worldbarplot")),
                        tabPanel("Map with Numbers", plotlyOutput("choro_Worldmap")),
                        tabPanel("Map with Colors", leafletOutput("Globalmap")),
                        )#inner tabset panel
                        ),
            tabPanel("Wordcloud",plotOutput("cloud")),
            
        )#outer tabset panel
    )#mainpanel
)#sidebar layout
)#close fluidpage
)#close ui


#tabsetPanel(type = "tabs",
#tabPanel("Sentiment in the US", tableOutput("US_states")),
#tabPanel("Sentiment in the World", tableOutput("world_countries")),
#tabPanel("Map of Sentiments in US", leafletOutput("USmap")),
#tabPanel("Map of Sentiments in the World", leafletOutput("Worldmap")),
#tabPanel("Global choropleth map", plotlyOutput("Globalmap")),
#tabPanel("Barchart", plotOutput("countrybarchart"))

#)                     
#)
#)
#)
#)


