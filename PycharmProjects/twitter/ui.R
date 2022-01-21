
library(shiny)

shinyUI(fluidPage(
    
    # Application title
    titlePanel("Sentiment Analysis of COVID Tweets"),
    
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
           
                    ), #sidebar panel
        
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
                        ), #tabpanel
            tabPanel("Wordcloud",
                     tabsetPanel(
                         tabPanel("Negative Sentiment Wordcloud", wordcloud2Output("negwordcloud"),height = "800px", width="100%" ),
                         tabPanel("Positive Sentiment Wordcloud",wordcloud2Output("poswordcloud"), height = "800px", width="100%")
             )#tabsetpanel
            )#tabpanel
        )#outer tabset panel
    )#mainpanel
)#sidebar layout
)#close fluidpage
)#close ui




