## Project Title 
Sentiment Analysis of COVID and Vaccination Tweets


## Description
Sentiment analysis is the use of natural language processing, text analysis, computational linguistics, programming languages, and statistics to systematically extract, identify,  quantify, and study people’s attitudes and opinions towards a topic.

In this project, I analyze Covid and vaccination tweets to determine whether people have positive or negative sentiment about this new virus and being vaccinated. I assume that there is a direct correlation between tweets that are considered as having positive sentiment and being willing to receive vaccination. 


## Motivation
Covid has caused a significant worldwide public health crisis, mental health crisis, economic crisis, job cuts, and unemployment. Since there is no cure yet and vaccination is the only way to slow the spread of the virus, people’s sentiments and opinions play a significant role in achieving herd immunity and controlling the spread of the virus.Given that during the pandemic, people have expressed their opinions and feelings via twitter, determining people’s emotional tone behind the words they used in their tweets provides us with an opportunity to gain an understanding of their attitudes and sentiment. Analyzing people’s sentiment is important because their emotions have an impact on their decision to comply with the CDC guidelines to receive covid vaccine and wear a mask.


## Questions 
*	What are people’s attitude towards Covid and vaccination? Do they  have mostly positive or negative feelings?
*	Are there any emotional trends that can be clustered based on geographical regions?
*	What words do people mostly use to express their feelings and opinions?


## Data
Tweets in English language were downloaded from Twitter. 

The following websites were used to download datasets which include information on world citites, countries, and their latitude/longitude. 
https://simplemaps.com/data/world-cities

https://gadm.org/data.html

The latitude and longitude information for the states in the United States was downloaded from the following website. 
https://www.latlong.net/category/states-236-14.html


## Data Analysis
Data cleaning was done in Python and analysis in RStudio. 

The VADER sentiment analysis model was used to classify tweets as having positive or negative sentiment. Some examples of tweets with negative and positive sentiment are given below: 

### Negative sentiment:
* “Year of corruption: Fauci-COVID-China Pelosi Jan-6 committee, Joe Biden, border crisis.”
* Ron DeSantis has been missing for 13 days while Covid kills thousands of Floridians and Ted Cruz fled to Cancun amid a power outage.”
* “My uncle died 12hrs after his 2nd Pfizer shot.”
* “Joe Biden is ignoring the states demands for more monoclonal antibody treatments and he made testing kits unavailable.”

### Positive sentiment:
* “Finally managed to get an appointment for covid booster.”
* “This needs to be shouted from the rooftops: If you get a positive rapid test, you should still get official PCR test.
* “When your coworker comes back to work after 5 days of quarantine.”  


## Conclusion
* The results of this study indicate that there is indeed a direct correlation between having positive/negative sentiment towards vaccination and being willing to receive the covid vaccine. 

* The results show that more than 60% of people in the world have positive attitude towards vaccination and as of now about 61% of world population is fully vaccinated. 

* In addition, the results indicate that 66% of people in the United States have positive feelings and opinions about vaccination and in fact about 63% of US population is fully vaccinated.    


## Shiny app
The interactive app is available at: 

The app has 3 tabs: 
* First and second tab provide the result of sentiment analysis for the United States and world countries, respectively. 
* Third tab includes two words clouds, representing frequent words used in tweets with negative and positive sentiments. 


## Limitations of the Study
* Only the tweets in English language were collected. 
* Tweets were downloaded just for 3 days, during Christmas holiday. 
* Not everyone is on Twitter. 


## Decencies and Installing
* To run the PyCharm and Python files, Anaconda-Navigator needs to be installed: 
* https://www.anaconda.com/products/individual 

* To run the app, RStudio and R need to be installed: 
* https://www.rstudio.com/products/rstudio/
* https://www.r-project.org/
  
* The codes used to analyze the data and create the app are available on this GitHub repository: 
* https://github.com/VahidehRasekhi/twitter_sentiment_analysis


## Author
Vahideh Rasekhi

Email: vrasekhi@gmail.com

LinkedIn: https://www.linkedin.com/in/vahideh-rasekhi-phd/


## Acknowledgments
I would like to thank the instructor of the Data Science bootcamp at Nashville Software School, Michael Holloway, and the teaching assistants, Veronica Ikeshoji-Orlati and Alvin Wendt. 


