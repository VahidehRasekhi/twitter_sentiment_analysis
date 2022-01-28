
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
                             selectInput("selected_state",
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
                             tabPanel("US States Graph",plotOutput("US_states_barplot")),
                             tabPanel("US States Interactive Graph", plotOutput("USbarplot")),
                             tabPanel("US Map of Sentiments", plotlyOutput("USmap")),
                         )#inner tabset panel
                ), #tab panel
                
                tabPanel("Sentiment in the World", 
                         tabsetPanel(
                             tabPanel("World Data Table",tableOutput("Worldtable")),
                             tabPanel("World Interactive Graph", plotOutput("Worldbarplot")),
                             tabPanel("World Map of Sentiments", plotlyOutput("choro_Worldmap")),
                             #tabPanel("Map with Colors", leafletOutput("Globalmap")),
                         )#inner tabset panel
                ), #tabpanel
                tabPanel("Wordcloud", 
                         fluidRow(
                             HTML('<h5> Negative Sentiment Word Frequency </h5>'),
                             wordcloud2Output("negwordcloud"),height = "1000px", width="100%"),
                         fluidRow(
                             HTML('<h5> Positive Sentiment Word Frequency </h5>'),
                             wordcloud2Output("poswordcloud"), height = "1000px", width="100%")
                )
            )#outer tabset panel
        )#mainpanel
    )#sidebar layout
)#close fluidpage
)#close ui



