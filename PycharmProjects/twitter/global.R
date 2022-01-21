library(dplyr)
library (plotly)
library (ggplot2)
library (dplyr)
library(scales)
library(sf)
library(leaflet)
library(tidyverse)
library(shiny)
library(choroplethr)
library(data.table)
library(wordcloud)
library(RColorBrewer)
library(wordcloud2)
library(tm)
library(data.table)
library (SnowballC)


#reading data
total_countries <- read_csv('total_country.csv') 
total_cities <- read_csv('total_city.csv') 
total_subcountries <- read_csv('total_subcountry.csv')
compound_sentiment<- read_csv('compound_sentiment.csv')
US_states_codes<-read_csv('US_states_codes.csv')#, header=TRUE, sep=",")




neg_wordcloud<-read_csv('combined_neg.csv')
pos_wordcloud<- read_csv('combined_pos.csv')


#for US_states barplot
US_states<- total_subcountries %>% 
  filter (country=='United States') %>% 
  pull(state)
US_states


#changeing values from float to int
total_subcountries$neg_sentiment<-as.integer(total_subcountries$neg_sentiment)
total_subcountries$pos_sentiment<-as.integer(total_subcountries$pos_sentiment)
total_subcountries$total_tweets<-as.integer(total_subcountries$total_tweets)
total_countries$neg_sentiment<-as.integer(total_countries$neg_sentiment)
total_countries$pos_sentiment<-as.integer(total_countries$pos_sentiment)
total_countries$total_tweets<-as.integer(total_countries$total_tweets)


#changing column names 
colnames(total_subcountries)[which(names(total_subcountries) == "pos_ratio")] <- "pos_percentage"
colnames(total_countries)[which(names(total_countries) == "pos_ratio")] <- "pos_percentage"
colnames(total_cities)[which(names(total_cities) == "pos_ratio")] <- "pos_percentage"

total_countries$pos_percentage<-as.numeric(total_countries$pos_percentage)
total_subcountries$pos_percentage<-as.numeric(total_subcountries$pos_percentage)
total_cities$pos_percentage<-as.numeric(total_cities$pos_percentage)
#US_states_codes$pos_percentage<-as.numeric(US_states_codes$pos_percentage)


#total_countries$pos_percentage<-percent(total_countries$pos_percentage, accuracy = 0.1)
total_subcountries$pos_percentage<-percent(total_subcountries$pos_percentage, accuracy = 0.1)
total_cities$pos_percentage<-percent(total_cities$pos_percentage, accuracy = 0.1)
#US_states_codes$pos_percentage<-percent(US_states_codes$pos_percentage, accuracy = 0.1)


#keeping 2 decimal points 
total_countries$pos_percentage<-round(total_countries$pos_percentage, digits=3)
#total_subcountries$pos_percentage<-round(total_subcountries$pos_percentage, digits=3)
#total_cities$pos_percentage<-round(total_cities$pos_percentage, digits=3)

US_states_codes$hover<- with (US_states_codes, paste ("state: ", subcountry, 
                                                      "<br>",
                                                      "positive sentiment: ", pos_sentiment, "<br>", 
                                                      "negative sentiment: ", neg_sentiment))