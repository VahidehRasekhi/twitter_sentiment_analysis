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
library(wordcloud2)
library(tm)
library(wordcloud)
library(RColorBrewer)
library(data.table)
library (SnowballC)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    
    output$Globalmap <- renderLeaflet({ 
        #total_countries<-total_countries %>% 
         #filter(country==input$selected_country, location==input$selected_location) 
       
      pal <- colorFactor(palette = c('blue', 'red'), 
                         levels = c("pos",
                                    "neg"))
      
      
      popup <- paste("<b>City:</b>", compound_sentiment$location,"<br>",
                     #"<b>State:</b>", pivot$subcountry,"<br>",
                     "<b>Country:</b>", compound_sentiment$country, "<br>",
                     "<b>Population:</b>", compound_sentiment$population, "<br>",
                     "<b>Sentiment:</b>", compound_sentiment$Compound_sentiment, "<br>"
                     
      )
      
      leaflet() %>% 
        addProviderTiles(provider = "Esri") %>% 
        
        addCircleMarkers(data =  compound_sentiment, 
                         radius = log10(compound_sentiment$population), 
                         opacity= .6, color= pal(compound_sentiment$Compound_sentiment),
                         lng = ~city_longitude, 
                         lat = ~city_latitude,
                         popup = popup) %>% 
        addLegend(pal= pal, position = 'bottomright', values = compound_sentiment$Compound_sentiment, title = 'Sentiment Value' 
        )
      
   }) 
    
    
    output$choro_Worldmap <- renderPlotly({
      
      fig <- plot_ly(total_countries, type='choropleth', 
                     locations=total_countries$country_code, 
                     z=total_countries$pos_sentiment, 
                     colorscale="Blues", 
                     hoverinfo = 'text',
                     text = ~paste0("country: ", country, "<br>","positive sentiment: ", pos_sentiment, "<br>", 
                                    "negative sentiment: ", neg_sentiment)) 
      
      fig
    })
    
    
    
    output$UStable <- renderTable({
        US_sentiment<-total_subcountries %>% 
          filter(country=='United States') %>% 
          select(subcountry, neg_sentiment, pos_sentiment, total_tweets) %>% 
          arrange(desc(pos_sentiment)) 

        US_sentiment=as.data.table(US_sentiment)
           
    })
    
    
    output$Worldtable <- renderTable({
        World_sentiment<-total_countries %>% 
            select(country, neg_sentiment, pos_sentiment, total_tweets) %>% 
            arrange(desc(pos_sentiment)) 
        
        World_sentimet=as.data.table(World_sentiment)
        
    })
    
    
    
    output$Worldbarplot <- renderPlot({

        total_countries %>% 
        filter(country==input$selected_country) %>% 
               #, subcountry==input$selected_subcountry, city==input$selected_city) %>% 
      
        pivot_longer(cols=c(pos_sentiment, neg_sentiment), names_to= 'sentiment', values_to='total_sentiment') %>% 
        ggplot(aes(x = country, fill=sentiment, y=total_sentiment))+
        geom_bar(position='dodge', stat='identity')+
        theme(axis.text.x = element_text(hjust=1))+
        ylab('Total Number of Sentiments')
      
    })
    
    
    output$USbarplot<- renderPlot({ 

      total_subcountries %>% 
        filter(subcountry==input$selected_subcountry) %>% 
        pivot_longer(cols=c(pos_sentiment, neg_sentiment), names_to= 'sentiment', values_to='total_sentiment') %>% 
        arrange(desc(total_sentiment)) %>% 
        filter(country=='United States') %>% 
        ggplot(aes(x = subcountry, fill=sentiment, y=total_sentiment))+
        geom_bar(position='dodge', stat='identity')+
        theme(axis.text.x = element_text(hjust=1))+
        ylab('Total Number of Sentiments') +
        xlab('US State') 
    })  
    
    
    output$US_states_barplot<- renderPlot({ 
    total_subcountries %>% 
      pivot_longer(cols=c(pos_sentiment, neg_sentiment), names_to= 'sentiment', values_to='total_sentiment') %>% 
      arrange(desc(total_sentiment)) %>% 
      filter(country=='United States') %>% 
      ggplot(aes(x = reorder(subcountry, desc(total_sentiment)), fill=sentiment, y=total_sentiment))+
      geom_bar(position='dodge', stat='identity')+
      theme(axis.text.x = element_text(angle= 45, hjust=1))+
      xlab('US States') +
      ylab('Total Number of Sentiments') 
      
})
    
    
}
