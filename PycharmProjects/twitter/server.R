#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(sf)
library(leaflet)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    output$USmap <- renderLeaflet({

        #US
        pal1 <- colorFactor(palette = c('blue', 'red'), 
                                levels = c("pos",
                                           "neg"))
            
        popup1 <- paste("<b>City:</b>", US_covid_tweets$location,"<br>",
                            "<b>State:</b>", US_covid_tweets$subcountry,"<br>",
                            "<b>Country:</b>", US_covid_tweets$country, "<br>",
                            "<b>Population:</b>", US_covid_tweets$population, "<br>"
                            
            )
            
            leaflet() %>% 
                addProviderTiles(provider = "Esri") %>% 
                
                addCircleMarkers(data = US_covid_tweets, radius = log10(US_covid_tweets$population), opacity = .6, color = pal1(US_covid_tweets$Compound_sentiment),
                                 lng = ~Longitude, 
                                 lat = ~Latitude,
                                 popup = popup) %>% 
                addLegend(pal1= pal1, position = 'bottomright', values = US_covid_tweets$Compound_sentiment, title = 'Sentiment Value' 
                )
            
            
    }) 
    
    
    output$Worldmap <- renderLeaflet({ 
       
        pal <- colorFactor(palette = c('blue', 'red'), 
                           levels = c("pos",
                                      "neg"))
        
        
        popup <- paste("<b>City:</b>", covid_tweets$location,"<br>",
                       "<b>State:</b>", covid_tweets$subcountry,"<br>",
                       "<b>Country:</b>", covid_tweets$country, "<br>",
                       "<b>Population:</b>", covid_tweets$population, "<br>"
                       
        )
        
        leaflet() %>% 
            addProviderTiles(provider = "Esri") %>% 
            
            addCircleMarkers(data = covid_tweets, radius = log10(covid_tweets$population), opacity = .6, color = pal(covid_tweets$Compound_sentiment),
                             lng = ~Longitude, 
                             lat = ~Latitude,
                             popup = popup) %>% 
            addLegend(pal= pal, position = 'bottomright', values = covid_tweets$Compound_sentiment, title = 'Sentiment Value' 
            )
        
        
   }) 
    
    output$countries <- renderPlot({
    })
    
    output$US_states <- renderPlot({
    })
    
}
