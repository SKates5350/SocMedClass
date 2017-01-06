################################################################
## Analyzing Twitter Data
## Author: Pablo Barbera
## Adapted by Sean Kates
## Social Media and Political Participation
## Lab 3, January 6th 2017
################################################################

## As usual, before we run anything, we make sure to change the working
## directory to where we have all our code and data stored. In my case, it is:
setwd("~/Desktop/Winter Term Course/lab 3")
## But it will different for yours! Click on the wheel on the files tab on
## the bottom right panel; then choose "set as working directory"; and paste
## here in the script what you see on the console

## First, we are going to install additional packages that will allow
## us to analyze the tweets more efficiently
install.packages("wordcloud")
install.packages("lazyeval")
install.packages("ggplot2")
install.packages("tm")

## and we now load them
library(streamR)
library(NYU160J)
library(wordcloud)
library(ggplot2)
library(maps)
library(tm)
library(lazyeval)


############################################
### ANALYZING KEY VARIABLES ABOUT TWEETS ###
############################################

## Now that we have download our own collection of tweets, we're going to
## learn how to analyze them.

## Starting with the the random sample of tweets, let's first open them again.
tweets = parseTweets("tweets_random.json")

## 1) In what language are these tweets written?
table(tweets$lang)

## Now let's switch to Trump
tweets = parseTweets("tweets_trump.json")

## 2) Which of these tweets has received more retweets?
max(tweets$retweet_count)
which(tweets$retweet_count == max(tweets$retweet_count))
tweets$text[which(tweets$retweet_count == max(tweets$retweet_count))]

## 3) What devices were used to send these tweets?
sort(table(tweets$source))

## Switch back to the random sample
tweets = parseTweets("tweets_random.json")

## 4) Which of these tweets was sent by the person with the most followers?
max(tweets$followers_count)
which(tweets$followers_count == max(tweets$followers_count))
tweets$text[which(tweets$followers_count == max(tweets$followers_count))]

## 5) From which countries where these tweets sent?
table(tweets$country)
sort(table(tweets$country))

## 6) How many of these tweets mention Donald Trump?
## This line shows you the tweets that mention Donald Trump
grep("trump", tweets$text, ignore.case=TRUE)
## This line computes HOW MANY tweets these are
length(grep("trump", tweets$text, ignore.case=TRUE))
## And this line shows you the text of such tweets
tweets$text[grep("trump", tweets$text, ignore.case=TRUE)]

##############################
### VISUALIZING TWEET TEXT ### 
##############################

## Now let's try opening tweets sent by the Donald
tweets = parseTweets("tweets_trump.json")

## Here we are creating a frequency tables with the most frequently used
## words. "Stopwords" indicates words that we are excluding (since Trump
## makes a habit of manually retweeting people who are talking about him 
## a lot, we want to remove that word so it doesn't look YUGE in our
## eventual wordcloud)
wordFreq = word.frequencies(tweets$text, stopwords=c("@realdonaldtrump", "trump"))

## Now we load the library that contains the function to visualize the text
library(wordcloud)

## And time to get the graphic! Don't worry too much about the options
wordcloud(words=names(wordFreq), freq=wordFreq, max.words=50, 
    random.order=F, colors="black", scale=c(2.5,.5), rot.per=0)

###################################
### ANALYZING GEOLOCATED TWEETS ###
###################################

## Our final example shows you how to map geolocated tweets
## As usual, we open the file with the tweets...
tweets = parseTweets("tweets_geo.json")

## Load the library that contains the graphics function we will use
library(ggplot2)

## First step is to create a data frame with the data -- in this case,
## a map of the world
map.data = map_data("world")

## And we can now plot the tweets on the map. Don't worry too much about the
## code here, as long as it works. I will help you work with this when you
## need to get a map like this.
ggplot(map.data) + geom_map(aes(map_id = region), map = map.data, fill = "grey90", 
    color = "grey50", size = 0.25) + expand_limits(x = map.data$long, y = map.data$lat) + 
    scale_x_continuous("Longitude", limits=c(38,58)) + 
    scale_y_continuous("Latitude", limits=c(11,35)) +
    theme_minimal() + geom_point(data = tweets, 
    aes(x = lon, y = lat), size = 1, alpha = 1/5, color = "darkred")



