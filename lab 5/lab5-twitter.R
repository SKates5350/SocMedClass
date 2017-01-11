################################################################
## Advanced Examples of Twitter Data Analysis
## Author: Pablo Barbera
## Adapted by Sean Kates
## Social Media and Political Participation
## Lab 5, January 10th 2017
################################################################

## As usual, before we run anything, we make sure to change the working
## directory to where we have all our code and data stored. In my case, it is:
setwd("~/Desktop/Winter Term Course/lab 5")
## But it will different for yours! Click on the wheel on the files tab on
## the bottom right panel; then choose "set as working directory"; and paste
## here in the script what you see on the console

install.packages("streamR")
## Loading the library to load your twitter data
library(streamR)

## we are going to re-install the package with additional functions
## that I have prepared for the course
library(devtools)
install_github("pablobarbera/NYU-AD-160J/NYU160J")

## And now we load the package and add the OAuth token
library(NYU160J)

## LOAD THOSE TOKENS - WHERE ARE THEY? Look in Lab 3 Folder
load("oauth_token.Rdata")

############################################
### COLLECTING YOUR DATASET OF TWEETS    ###
############################################

## You need to collect the full set of tweets from your politician. Here, 
## I am going to collect John McCain's as an example, but you should alter 
## code if you want to get yours out of way. Either way is fine with me

getTimeline(filename="tweets_mccain.json", screen_name="SenJohnMcCain", 
    n=3200, oauth=my_oauth, trim_user="false", sleep = 0.5)

############################################
### LOADING YOUR DATASET OF TWEETS       ###
############################################

## The next step is to open your dataset of tweets. Here I'm using tweets
## by John McCain as an example, but feel free to change the name of the file
## to yours

tweets = parseTweets("tweets_mccain.json")
save(tweets, file="mccaintweets.Rda")

############################################
### PRELIMINARY DESCRIPTIVE ANALYSIS     ###
############################################

## Let's review how to answer a few quick descriptive questions...

## 1) How many tweets are there in the dataset?
length(tweets$text)

## 2) In what language are they written?
table(tweets$lang)

tweets$text[which(tweets$lang=='fr')]

## 3) What devices were used to send these tweets?
sort(table(tweets$source))

## 4) What are the first and last tweet included in the dataset?
head(tweets, n=1)
tail(tweets, n=1)

## 5) How many followers/friends/statuses does the user currently have
tweets$followers_count[1]
tweets$friends_count[1]
tweets$statuses_count[1]


############################################
### FINDING MOST COMMON HASHTAGS         ###
############################################

## To find the N most common hashtags, you can use the following function
getCommonHashtags(tweets$text, n=20)
## It will display that N hashtags that were used more often in a dataset of
## tweets, as well as the number of times they were used.

## For example, for McCain 137 tweets mentioned #Syria
## Since he has sent 3,200 tweets, that means around 4% of his tweets
## used this hashtag


############################################
### WORDCLOUDS                           ###
############################################

## How can you make a word cloud with the most common hashtags, where the
## size of each hashtag depends on how often it was used?

## first step is to find most common hashtags again
ht = getCommonHashtags(tweets$text, n=50)
ht
install.packages('wordcloud')
## Now we load the library that contains the function to visualize the text
library(wordcloud)

## And time to get the graphic! Don't worry too much about the options
wordcloud(words=names(ht), freq=ht, max.words=250, 
    random.order=FALSE, colors="black", scale=c(2.5,.5), rot.per=0)

## That's a word cloud of hashtags, but how can you do a word cloud
## of the most common words? (not only hashtags)

## First we are creating a frequency tables with the most frequently used
## words. "Stopwords" indicates words that we are excluding (since 'mccain' is
## very common, we just remove that to make the plot easier to read)
wordFreq = word.frequencies(tweets$text, stopwords=c("mccain", "john","@senjohnmccain"))

## And get the wordcloud again...
wordcloud(words=names(wordFreq), freq=wordFreq, max.words=250, 
    random.order=F, colors="black", scale=c(2.5,.5), rot.per=0)

## What do we learn?


############################################
### NUMBER OF TWEETS OVER TIME           ###
############################################

## How can you count the number of tweets per month? This is important to
## understand how social media strategies are constant over time or if
## there are periods of more activity

## I have prepared a function that will do that for you:
months = countMonthsTweets(tweets$created_at)
months


## And now we can use the basic R plot command to make a decent-looking graph
plot(x=months$month, y=months$tweets, xlab="Date", ylab="Tweets per month", xlim=c(as.Date("2016-01-01"),as.Date("2016-12-01")), main="Tweet Volume for John McCain in 2016")
lines(x=months$month, y=months$tweets)

## What do we learn about McCain? 


############################################
### FINDING TOP TWEETS ###
############################################

## As with Facebook, it's very informative to look at the tweets that went
## more viral. On Twitter, that's going to be the tweets that were retweeted
## more often.

## First, let's look at how many retweets McCain usually gets...
summary(tweets$retweet_count)
## not a lot of retweets

## Graphically, this is the distribution
hist(tweets$retweet_count[tweets$retweet_count<500], breaks=100)

## So tweets usually get very few retweets, and there are a few tweets that
## get a lot. Let's look at those
df<-tweets[tweets$retweet_count>2500,]

## Another dimension that measures popularity is the number of times each
## tweet got favorited (now 'liked')
## Don't worry about this for now





