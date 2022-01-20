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
                   text = ~paste0("country: ", country, 
                                  "<br>","pos_sentiment: ", pos_sentiment, 
                                  "<br>", "neg_sentiment: ", neg_sentiment,
                                  "<br>", "pos_sentiment percentage: ", pos_percentage
                                  )) 
    
    fig
  })
  
  
  output$USmap <- renderPlotly({ 
  
  US_states_codes<-read.csv('US_states_codes.csv', header=TRUE, sep=",")
  
  US_states_codes$hover<- with (US_states_codes, paste ("state: ", subcountry, 
                                                        "<br>",
                                                        "positive sentiment: ", pos_sentiment, "<br>", 
                                                        "negative sentiment: ", neg_sentiment))
  
  g<- list(
    scope= 'usa',
    projection=list(type='albers usa'),
    showlakes= TRUE,
    lakecolor=toRGB('white')
  )
  
  fig<- plot_geo(US_states_codes, locationmode='USA-states')
  
  fig<- fig %>% add_trace(
    z=US_states_codes$pos_sentiment, 
    text= ~hover, locations=~State.codes,
    color=~pos_sentiment, 
    colors='Purples'
  )
  fig<- fig %>% colorbar(title='Positive Sentiment')
  fig<- fig %>% layout(
    title= 'COVID Sentiment in the US',
    geo=g
  )
  fig
  
  })
  
  
  
  output$UStable <- renderTable({
    
    #total_subcountries %>% 
      #total_subcountries$total_tweets<-format(total_subcountries$total_tweets, big.mark=",", trim=TRUE) %>% 
      #total_subcountries$pos_sentiment<-format(total_subcountries$pos_sentiment, big.mark=",", trim=TRUE) %>% 
      #total_subcountries$neg_sentiment<-format(total_subcountries$neg_sentiment, big.mark=",", trim=TRUE) %>% 
      
      US_sentiment<-total_subcountries%>% 
      filter(country=='United States') %>% 
      select(subcountry, neg_sentiment, pos_sentiment, total_tweets, pos_percentage) %>% 
      arrange(desc(pos_sentiment)) 
    
    US_sentiment=as.data.table(US_sentiment)
    
  })
  
  
  output$Worldtable <- renderTable({
    World_sentiment<-total_countries %>% 
      select(country, neg_sentiment, pos_sentiment, total_tweets, pos_percentage) %>% 
      arrange(desc(pos_sentiment)) 
    
    World_sentimet=as.data.table(World_sentiment)
    
  })
  
  
  output$World_city_selector <-renderUI({
    
    World_cities<- total_cities %>% 
      filter(country==input$selected_country) %>% 
      pull(city)
  
    World_cities<-c('Overall', World_cities)
    
    selectInput("selected_city2",
                label = h3("Choose City:"),
                choices = World_cities,
                selected = 1)
    
  })
  output$Worldbarplot <- renderPlot({
    if (input$selected_city2 == 'Overall'){
    plot<-total_countries %>% 
      filter (country== input$selected_country) %>% 
      pivot_longer(cols=c(pos_sentiment, neg_sentiment), names_to= 'sentiment', values_to='total_sentiment') %>% 
      ggplot(aes(x = country, fill=sentiment, y=total_sentiment))+
      geom_bar(position='dodge', stat='identity')+
      theme(axis.text.x = element_text(hjust=1))+
      ylab('Total Number of Sentiments')+
       xlab('country') 
    
    }
    
    
    if (input$selected_city2 != 'Overall'){
      plot<-total_cities %>% 
        filter(city==input$selected_city2) %>% 
        pivot_longer(cols=c(pos_sentiment, neg_sentiment), names_to= 'sentiment', values_to='total_sentiment') %>% 
        ggplot(aes(x = country, fill=sentiment, y=total_sentiment))+
        geom_bar(position='dodge', stat='identity')+
        theme(axis.text.x = element_text(hjust=1))+
        ylab('Total Number of Sentiments')+
        xlab('city') 
      
    }
    plot
    
  })
  
  
  output$US_city_selector <-renderUI({
    
    US_cities<- total_cities %>% 
      filter(country=='United States', subcountry==input$selected_subcountry) %>% 
      pull(city)
    
    US_cities<-c('Overall', US_cities)
    
    selectInput("selected_city",
                label = h3("Choose City:"),
                choices = US_cities,
                selected = 1)
    
  })
  output$USbarplot<- renderPlot({ 
    if (input$selected_city == 'Overall'){
      plot<-total_subcountries %>% 
        filter(subcountry==input$selected_subcountry) %>% 
        pivot_longer(cols=c(pos_sentiment, neg_sentiment), names_to= 'sentiment', values_to='total_sentiment') %>% 
        arrange(desc(total_sentiment)) %>% 
        filter(country=='United States') %>% 
        ggplot(aes(x = subcountry, fill=sentiment, y=total_sentiment))+
        geom_bar(position='dodge', stat='identity')+
        theme(axis.text.x = element_text(hjust=1))+
        ylab('Total Number of Sentiments') +
        xlab('US State') 
    }
    
    
    if (input$selected_city != 'Overall'){
      plot<-total_cities %>% 
        filter(city==input$selected_city) %>% 
        pivot_longer(cols=c(pos_sentiment, neg_sentiment), names_to= 'sentiment', values_to='total_sentiment') %>% 
        arrange(desc(total_sentiment)) %>% 
        filter(country=='United States') %>% 
        ggplot(aes(x = city, fill=sentiment, y=total_sentiment))+
        geom_bar(position='dodge', stat='identity')+
        theme(axis.text.x = element_text(hjust=1))+
        ylab('Total Number of Sentiments') +
        xlab('city') 
    }
    
    plot
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
  
  
  output$sentiment_selector <-renderUI({
    
    covid_wordcloud<- covid_wordcloud %>% 
    pull(sentiment)
    
   covid_wordcloud<-c('positive', 'negative')
    
    selectInput("selected_sentiment", "Select a sentiment:",
                label = h3("Choose Sentiment:"),
              choices = covid_wordcloud,
                selected = 1)

  })
  output$negwordcloud<- renderWordcloud2({
    
    wordcloud2(data=covid_wordcloud, size = 0.9, shape = 'pentagon')
  })
  
  output$poswordcloud<- renderWordcloud2({
    wordcloud2(data=covid_wordcloud, size = 0.9, shape = 'pentagon')
 
  })
}
