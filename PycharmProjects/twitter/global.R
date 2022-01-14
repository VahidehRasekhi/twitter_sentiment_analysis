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


covid_tweets <- read.csv('covid_tweets_lat_lng.csv') 
US_covid_tweets <- read.csv('US_geo_data2.csv') 