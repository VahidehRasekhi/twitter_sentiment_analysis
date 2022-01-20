

library(shiny)

shinyUI(fluidPage(
    
    # Application title
    titlePanel("Sentiment Analysis of COVID and Vaccination Tweets"),
    
    sidebarLayout(
        sidebarPanel(
            
            conditionalPanel("input.tabsetPanel == 'Sentiment in the World'", 
                             selectInput("selected_country",
                                         label = h3("Choose Country:"),
                                         choices = unique(sort(total_countries$country)),
                                         selected = 1),
                             uiOutput('World_city_selector')
            ),
            
            conditionalPanel("input.tabsetPanel == 'Sentiment in the US'", 
                             selectInput("selected_subcountry",
                                         label = h3("Choose State:"),
                                         choices = US_states,
                                         selected = 1),
                             uiOutput('US_city_selector')
                     ),
            #conditionalPanel("input.tabsetPanel == 'Wordcloud'", 
             #                selectInput("Sselected_sentiment", "Choose a sentiement:",
              #                         choices= covid_wordcloud_sentiment,
               #                        selected = 1),
                #             uiOutput('sentiment_selector')
              #               actionButton("update", "Change"),
               #              hr(),
                #             sliderInput("freq",
                 #                        "Minimun Frequency:",
                  #                       min=1, max=50, value=15),
                   #          sliderInput("max",
                    #                     "Maximum Number of Words:",
                     #                    min=1, max=300, value=100)
           # ),
                                     

                    ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            tabsetPanel(
                id='tabsetPanel', 
                tabPanel("Sentiment in the US",
                          tabsetPanel(
                              tabPanel("US Data Table",tableOutput("UStable")),
                              tabPanel("US States",plotOutput("US_states_barplot")),
                              tabPanel("Graphs", plotOutput("USbarplot")),
                               tabPanel("Map of Sentiments in US", plotlyOutput("USmap")),
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
            tabPanel("Wordcloud",wordcloud2Output("wordcloud")),
            
        )#outer tabset panel
    )#mainpanel
)#sidebar layout
)#close fluidpage
)#close ui




