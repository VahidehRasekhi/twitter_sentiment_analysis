library(dplyr)
library(stringr)
library(glue)
library(rlist)
library (plotly)
library (ggplot2)
library (dplyr)
library(scales)
library(sf)
library(leaflet)
library(tidyverse)
library(shiny)
library(choroplethr)
library(ggplot2)
library(data.table)



total_countries <- read_csv('total_country.csv') 
total_cities <- read_csv('total_city.csv') 
total_subcountries <- read_csv('total_subcountry.csv')


##old dataset
covid_tweets <- read_csv('covid_tweets_lat_lng.csv') 
#US_covid_tweets <- read_csv('data/US_geo_data2.csv') 


