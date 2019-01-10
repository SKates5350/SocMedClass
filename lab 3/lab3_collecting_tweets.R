################################################################
## Collecting Twitter Data
## Author: Pablo Barbera
## Adapted by Sean Kates
## Social Media and Political Participation
## Lab 3, January 8th 2018
################################################################

## As usual, before we run anything, we make sure to change the working
## directory to where we have all our code and data stored. In my case, it is:
setwd("~/Desktop/Winter Term Course/2019/lab 3")
## But it will different for yours! Click on the wheel on the files tab on
## the bottom right panel; then choose "set as working directory"; and paste
## here in the script what you see on the console

###################################################
### INSTALLING PACKAGES AND LOADING OAUTH TOKEN ###
###################################################

## The first step is to install "streamR" and "ROAuth, the R packages that 
## allow you to collect tweets
install.packages("streamR")
install.packages("ROAuth")
## Note that you will need to do this only once.

## we will also install another package with additional functions
## that I have prepared for the course
install.packages("devtools")
library(devtools)
install_github("pablobarbera/NYU-AD-160J/NYU160J")

## Now we load the packages
library(streamR)
library(ROAuth)
library(NYU160J)

## To download the tweets, you need to have an OAuth token -- a file that 
## allows you to connect to the API. I have prepared these files for you
## so that you can start collecting tweets right away, but see the end of this
## R script for instructions on how to create your own in the future.

## Navigate to http://bit.ly/2017tokens and find the folder with your NetID
## Download the oauth_token.Rdata file to your current working directory 
## (where your other R scripts and data files are located)

## Now, run the following line:
load("oauth_token.Rdata")

###############################################
### COLLECTING TWEETS FILTERING BY KEYWORDS ###
###############################################

## The first example shows how to collect tweets that mention a given keyword
## in real time, as they are being published, with the 'filterStream' command

filterStream(file.name="trumptweets.json", track="trump", 
    timeout=75, oauth=my_oauth)

## Note the options:
## FILE.NAME indicates the file in your disk where the tweets will be downloaded
## TRACK is the keyword(s) mentioned in the tweets we want to capture.
## TWEETS is the number of tweets we want to capture.
## OAUTH is the OAuth token we are using (you don't need to change this)

## Once it has finished, we can open it in R as a data frame with the
## "parseTweets" function
tweets <- parseTweets("trumptweets.json")

## Click on the top right panel in "tweets" to see the structure of this
## data frame.

###############################################
### COLLECTING TWEETS FILTERING BY LOCATION ###
###############################################

## This second example shows how to collect tweets filtering by location
## instead. In other words, we can set a geographical box and collect
## only the tweets that are coming from that area.

## For example, imagine we want to collect tweets from the Arabian Peninsula.
## The way to do it is to find two pairs of coordinates (longitude and latitude)
## that indicate the southwest corner AND the northeast corner.
## In the case of the Arabian Peninsula, it would be approx. (38,11) and (58,35)
## How to find the coordinates? I use: http://itouchmap.com/latlong.html

filterStream(file.name="tweets_geo.json", locations=c(38, 11, 58, 35), 
    timeout=60, oauth=my_oauth)


## We can do as before and open the tweets in R
tweets <- parseTweets("tweets_geo.json")

############################################
### COLLECTING A RANDOM SAMPLE OF TWEETS ###
############################################

## It's also possible to collect a random sample of tweets. That's what
## the "sampleStream" function does:

sampleStream(file.name="tweets_random.json", timeout=30, oauth=my_oauth)

## Here I'm collecting 30 seconds of tweets
## And once again, to open the tweets in R...
tweets <- parseTweets("tweets_random.json")

#############################################
### DOWNLOADING RECENT TWEETS FROM A USER ###
#############################################

## Finally, here's how you can capture the most recent tweets (up to 3,200)
## of any given user (in this case, @nytimes)

getTimeline(filename="tweets_nytimes.json", screen_name="nytimes", 
    n=1000, oauth=my_oauth, trim_user="false", sleep = 0.5)

## Now you know how it goes...
tweets = parseTweets("tweets_nytimes.json")

## Let's also grab the Donald's latest tweets

getTimeline(filename="tweets_trump.json", screen_name="realDonaldTrump", 
    n=1000, oauth=my_oauth, sleep = 0.5)

## Now you know how it goes...
tweets = parseTweets("tweets_trump.json")


#####################################
### CREATING YOUR OWN OAUTH TOKEN ###
#####################################

## I will not discuss this in the lab session, but I add it here in case you
## want to create your own token in the future

## Step 1: go to apps.twitter.com and sign in
## Step 2: click on "Create New App"
## Step 3: fill name, description, and website (it can be anything, even google.com)
##			(make sure you leave 'Callback URL' empty)
## Step 4: Agree to user conditions
## Step 5: replace the strings in the call to saveToken 
##   (the last line of this file) and run it
## Step 6: Follow the instructions you are shown
##   (it will open your web browser, have you "Authorize" the app, and then 
##	  you will need to copy a key back into R)

saveToken <- function(consumerKey,consumerSecret,fn='oauth_token.Rdata') {
	library(ROAuth)
	requestURL <- "https://api.twitter.com/oauth/request_token"
	accessURL <- "https://api.twitter.com/oauth/access_token"
	authURL <- "https://api.twitter.com/oauth/authorize"
	my_oauth <- OAuthFactory$new(consumerKey=consumerKey,
	  consumerSecret=consumerSecret, requestURL=requestURL,
	  accessURL=accessURL, authURL=authURL)
	## run this line and go to the URL that appears on screen
	my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
	## now you can save oauth token for use in future sessions with twitteR or streamR
	save(my_oauth, file=fn)
}
saveToken("CONSUMER_KEY_GOES_HERE","CONSUMER_SECRET_GOES_HERE")

