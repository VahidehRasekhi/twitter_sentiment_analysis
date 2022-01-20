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


##old dataset
#covid_tweets <- read_csv('covid_tweets_lat_lng.csv') 

#covid_wordcloud<- read_csv('covid_wordcloud.csv')
neg_wordcloud<-read_csv('combined_neg.csv')
pos_wordcloud<- read_csv('combined_pos.csv')


#for US_states barplot
US_states<- total_subcountries %>% 
  filter (country=='United States') %>% 
  pull(subcountry)
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

#keeping 2 decimal points 
total_countries$pos_percentage<-round(total_countries$pos_percentage, digits=2)
total_subcountries$pos_percentage<-round(total_subcountries$pos_percentage, digits=2)
total_cities$pos_percentage<-round(total_cities$pos_percentage, digits=2)

