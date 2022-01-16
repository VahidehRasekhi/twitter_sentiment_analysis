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
    
    
    output$Worldmap <- renderLeaflet({ 
        #total_countries<-total_countries %>% 
         #filter(country==input$selected_country, location==input$selected_location) 
      
       
        pal <- colorFactor(palette = c('blue', 'red'), 
                           levels = c("pos",
                                      "neg"))
        
        popup <- paste("<b>City:</b>", covid_tweets$location,"<br>",
                       "<b>State:</b>", covid_tweets$subcountry,"<br>",
                       "<b>Country:</b>", covid_tweets$country, "<br>",
                       "<b>Population:</b>", covid_tweets$population, "<br>",
                       "<b>sentiment:</b>", covid_tweets$Compound_sentiment, "<br>"
                       
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
        total_countries %>% 
            arrange(desc(pos_sentiment)) %>% 
            head(10) %>% 
            ggplot(aes(x ='country')) +
            geom_bar()
        
    })
    
    output$US_states <- renderTable({
        US_sentiment<-total_subcountries %>% 
          filter(country=='United States') %>% 
          select(subcountry, neg_sentiment, pos_sentiment, total_tweets) %>% 
          arrange(desc(pos_sentiment)) 

        
        US_sentiment=as.data.table(US_sentiment)
           
            
    })
    
    output$world_countries <- renderTable({
        World_sentiment<-total_countries %>% 
            select(country, neg_sentiment, pos_sentiment, total_tweets) %>% 
            arrange(desc(pos_sentiment)) 
          
        
        World_sentimet=as.data.table(World_sentiment)
        
        
    })
    
    
    output$Globalmap <- renderPlotly({
        
      fig <- plot_ly(total_countries, type='choropleth', 
                     locations=total_countries$country_code, 
                     z=total_countries$pos_sentiment, 
                     colorscale="Blues", 
                     hoverinfo = 'text',
                     text = ~paste0("country: ", country, "<br>","positive sentiment: ", pos_sentiment, "<br>", 
                                    "negative sentiment: ", neg_sentiment)) 
              
      
      fig
    })
    
    output$countrybarchart <- renderPlot({

      total_countries %>%
        #filter(country==input$selected_country, subcountry==input$selected_subcountry, city==input$selected_city) %>% 
        pivot_longer(cols=c(pos_sentiment, neg_sentiment), names_to= 'sentiment', values_to='total_sentiment') %>% 
        arrange(desc(total_sentiment)) %>% 
        head(10) %>% 
        ggplot(aes(x = reorder(country, desc(total_sentiment)), fill=sentiment, y=total_sentiment))+
        geom_bar(position='stack', stat='identity')+
        theme(axis.text.x = element_text(angle = 45, hjust=1))
      
    })
    
}
