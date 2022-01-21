
library(shiny)
library(sf)
library(leaflet)
library(wordcloud2)
library(tm)
library(wordcloud)
library(RColorBrewer)
library(data.table)
library (SnowballC)


server <- function(input, output, session) {
  
#global leaflet map
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
  

#Choropleth worldmap
  
  output$choro_Worldmap <- renderPlotly({ 
    
    fig <- plot_ly(total_countries, type='choropleth', 
                   locations=total_countries$country_code, 
                   z=100*as.numeric(total_countries$pos_percentage),
                   zmin=100*0.6,
                   zmax=100*0.85,
                   color=100*as.numeric(total_countries$pos_percentage), 
                   colorscale="Blues",
                   reversescale=TRUE,
                   hoverinfo = 'text',
                   text = ~paste0("country: ", country, "<br>","positive sentiment: ", pos_sentiment, "<br>", 
                                  "negative sentiment: ", neg_sentiment,
                                  "<br>", "positive sentiment percentage: ", percent(as.numeric(pos_percentage), 
                                                                                     accuracy = 0.1)
                                  )
                                 )
      fig<-fig %>% colorbar(
        ticksuffix='%'
        )
        #legend=percent(as.numeric(pos_percentage), accuracy = 0.1)

      
      
    fig
    
    
  
  })
  
  
  
  
  
  
  
 
  
  
#US states plotly map
  output$USmap <- renderPlotly({ 
  
  # US_states_codes$hover<- with (US_states_codes, paste ("state: ", subcountry, 
  #                                                       "<br>",
  #                                                       "positive sentiment: ", pos_sentiment, "<br>", 
  #                                                       "negative sentiment: ", neg_sentiment))
  # 
  g<- list(
    scope= 'usa',
    projection=list(type='albers usa'),
    #showlakes= TRUE,
    lakecolor=toRGB('white')
  )
  
  fig<- plot_geo(US_states_codes, locationmode='USA-states')
  
  fig<- fig %>% add_trace(
    z=US_states_codes$pos_percentage, 
    text= ~hover, locations=~`State codes`,
    color=~pos_percentage, 
    colors='Purples'
  )
  fig<- fig %>% colorbar(title='Positive Percentage')
  fig<- fig %>% layout(
    title= 'COVID Sentiment in the US',
    geo=g
  )
  fig
  
  })
  
  
#US states data table
  output$UStable <- renderTable({
    
      US_sentiment<-total_subcountries%>% 
      filter(country=='United States') %>% 
      select(state, neg_sentiment, pos_sentiment,total_tweets, pos_percentage) %>% 
      arrange(desc(pos_percentage)) %>% 
        mutate(total_tweets=prettyNum(total_tweets, big.mark=",")) %>% 
        mutate(pos_sentiment=prettyNum(pos_sentiment, big.mark=",")) %>% 
        mutate(neg_sentiment=prettyNum(neg_sentiment, big.mark=",")) 
    
    US_sentiment=as.data.table(US_sentiment)
    
  })
  
#World countries data table
  output$Worldtable <- renderTable({
    World_sentiment<-total_countries %>% 
      select(country, neg_sentiment, pos_sentiment,total_tweets, pos_percentage) %>% 
      arrange(desc(pos_percentage)) %>%  
     mutate(total_tweets=prettyNum(total_tweets, big.mark=",")) %>% 
      mutate(pos_sentiment=prettyNum(pos_sentiment, big.mark=",")) %>% 
      mutate(neg_sentiment=prettyNum(neg_sentiment, big.mark=",")) #%>% 
      #mutate(positive_percentage= pos_percentage )
    
     # total_countries$pos_percentage<-percent(total_countries$pos_percentage, accuracy = 0.1)
    
    World_sentimet=as.data.table(World_sentiment)
    
  })
  
#World citites bar plot
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
      ylab('Total Tweets')+
       xlab('country') 
    
    }
    
    
    if (input$selected_city2 != 'Overall'){
      plot<-total_cities %>% 
        filter(city==input$selected_city2) %>% 
        pivot_longer(cols=c(pos_sentiment, neg_sentiment), names_to= 'sentiment', values_to='total_sentiment') %>% 
        ggplot(aes(x = country, fill=sentiment, y=total_sentiment))+
        geom_bar(position='dodge', stat='identity')+
        theme(axis.text.x = element_text(hjust=1))+
        ylab('Total Tweets')+
        xlab('city') 
      
    }
    plot
    
  })
  
#US cities barplot
  output$US_city_selector <-renderUI({
    
    US_cities<- total_cities %>% 
      filter(country=='United States', state==input$selected_state) %>% 
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
        filter(state==input$selected_state) %>% 
        pivot_longer(cols=c(pos_sentiment, neg_sentiment), names_to= 'sentiment', values_to='total_sentiment') %>% 
        arrange(desc(total_sentiment)) %>% 
        mutate(total_sentiment=prettyNum(total_sentiment, big.mark=",")) %>%  
        filter(country=='United States') %>% 
        ggplot(aes(x = state, fill=sentiment, y=total_sentiment))+
        geom_bar(position='dodge', stat='identity')+
        theme(axis.text.x = element_text(hjust=1))+
        ylab('Total Tweets') +
        xlab('US State') 
    }
    
    
    if (input$selected_city != 'Overall'){
      plot<-total_cities %>% 
        filter(city==input$selected_city) %>% 
        pivot_longer(cols=c(pos_sentiment, neg_sentiment), names_to= 'sentiment', values_to='total_sentiment') %>% 
        arrange(desc(total_sentiment)) %>% 
        mutate(total_sentiment=prettyNum(total_sentiment, big.mark=",")) %>%  
        filter(country=='United States') %>% 
        mutate(total_sentiment=prettyNum(total_sentiment, big.mark=",")) %>%  
        ggplot(aes(x = city, fill=sentiment, y=total_sentiment))+
        geom_bar(position='dodge', stat='identity')+
        theme(axis.text.x = element_text(hjust=1))+
        ylab('Total Tweets') +
        xlab('city') 
    }
    
    plot
  })  
  
#US states barplot  
  output$US_states_barplot<- renderPlot({ 
    total_subcountries %>% 
      pivot_longer(cols=c(pos_sentiment, neg_sentiment), names_to= 'sentiment', values_to='total_sentiment') %>% 
      arrange(desc(total_sentiment)) %>% 
      filter(country=='United States') %>% 
      ggplot(aes(x = reorder(state, desc(total_sentiment)), fill=sentiment, y=total_sentiment))+
      geom_bar(position='dodge', stat='identity')+
      theme(axis.text.x = element_text(angle= 45, hjust=1))+
      xlab('US States') +
      ylab('Total Tweets') 
    
  })
  
#wordclouds  
  output$negwordcloud<- renderWordcloud2({

    wordcloud2(data=neg_wordcloud, size = 0.9, shape = 'pentagon')
    
  })
  
  output$poswordcloud<- renderWordcloud2({
    wordcloud2(data=pos_wordcloud, size = 0.9, shape = 'pentagon')
 
  })
}
