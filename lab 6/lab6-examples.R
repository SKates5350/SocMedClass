################################################################
## More Examples of Twitter and Facebook Data Analysis
## Author: Pablo Barbera
## Adapted by Sean Kates
## Social Media and Political Participation
## Lab 6, January 11 2017
################################################################

## As usual, before we run anything, we make sure to change the working
## directory to where we have all our code and data stored. In my case, it is:
setwd("~/Desktop/Winter Term Course/lab 6/")

## But it will different for yours! Click on the wheel on the files tab on
## the bottom right panel; then choose "set as working directory"; and paste
## here in the script what you see on the console

## Loading the libraries to work with your Twitter and Facebook data
library(streamR)
library(Rfacebook)
install.packages("Rfacebook")

## we are going to re-install the package with additional functions
## that I have prepared for the course
library(devtools)
install_github("pablobarbera/NYU-AD-160J/NYU160J")

## And now we load the package
library(NYU160J)

#### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ####
#### TWITTER
#### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ####


############################################
### LOADING YOUR DATASET OF TWEETS       ###
############################################

## The first step is to open your dataset of tweets. Here I'm using tweets
## by John McCain as an example, but feel free to change the name of the file
## to yours

tweets = parseTweets("senjohnmccain.json")

######################################################
### FINDING TWEETS THAT CONTAIN A PICTURE         ###
######################################################

# each tweet contains a variable that indicates whether it contains a picture
table(tweets$photo)

# do tweets that contain more photos receive more retweets?
mean(tweets$retweet_count[tweets$photo==TRUE])
mean(tweets$retweet_count[tweets$photo==FALSE])


######################################################
### FINDING TWEETS THAT MENTION SPECIFIC WORDS  ###
######################################################

## This line shows you the tweets that mention the word Syria
grep("syria", tweets$text, ignore.case=TRUE)
## This line computes HOW MANY tweets these are
length(grep("syria", tweets$text, ignore.case=TRUE))
## And this line shows you the text of such tweets
tweets$text[ grep("syria", tweets$text, ignore.case=TRUE) ]

tweets$syria = grepl("syria",tweets$text, ignore.case=TRUE)
mean(tweets$retweet_count[tweets$syria==TRUE])
mean(tweets$retweet_count[tweets$syria==FALSE])

# How many tweets are retweets?
length(grep("RT @", tweets$text, ignore.case=TRUE))
tweets$RT = grepl("RT @", tweets$text, ignore.case=TRUE)

tweets$obama = grepl("obama",tweets$text,ignore.case=TRUE)

# Run a simple regression
mod = lm(retweet_count~RT+photo+obama+syria,data=tweets)
summary(mod)

# This shows that while the tweet being a RT or talking about obama 
# has little effect on the number of retweets, the tweet including
# a photo or talking about syria do lead to more retweets.

# Coefficients:
#               Estimate  Std. Error t value Pr(>|t|)    
# (Intercept)   56.839      5.771   9.849   <2e-16 ***
# RTTRUE        12.448     15.657   0.795    0.427    
# photoTRUE      2.474     12.220   0.202    0.840    
# obamaTRUE     -6.962     16.367  -0.425    0.671    
# syriaTRUE     30.552     19.889   1.536    0.125    
# The first column tells you the variable for that row
# The "Estimate" column tells you the effect that variable
# has on the outcome. For instance, Syria here raises the
# average number of retweets by 37 retweets.
# The *** at the end indicate how 'confident' you can be that
# the effect is not equal to zero. The more stars or dots, the
# more obviously distinct from zero it is. The lack
# of stars next to each of these predictors indicate that noise could have easily 
# led to that sized effect.

#####################################
### SUBSETTING TWEETS BY DATE     ###
#####################################

# First, we create a new variable that saves the date and time of
# each tweet in a format that R likes

tweets$datetime = formatTwDate(tweets$created_at, format="date")

## Now imagine that we want to subset all tweets from October 2016
subset.tweets = tweets[tweets$datetime > as.Date("2016-10-01") & 
       tweets$datetime < as.Date("2016-10-31"),]

## ...and find the most retweeted tweet in October
max(subset.tweets$retweet_count)

subset.tweets[subset.tweets$retweet_count == max(subset.tweets$retweet_count),]

# Be careful to always use the name of the new data frame you just created!


#### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ####
#### FACEBOOK
#### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ####

###################################
### LOADING YOUR FACEBOOK DATA  ###
###################################

## This is how you open your Facebook data
# data<-getPage("johnmccain", token=my_oauth, n=10000) 
# save(data, file="johnmccain.Rda")
load("johnmccain.Rda")


######################################################
### VISUALIZE NUMBER OF POSTS OVER TIME      ###
######################################################

## How can you count the number of posts per month? 

## I have prepared a function that will do that for you:
months = countMonthsPosts(data$created_time)
months

## And now we can use the basic R plot command to make a decent-looking graph
plot(x=months$month, y=months$posts,
    xlab="Date", ylab="Posts per month")
lines(x=months$month, y=months$posts)

## What do we learn about McCain? 

## same for weeks
weeks = countWeeksPosts(data$created_time)

## And now we can use the basic R plot command to make a decent-looking graph
plot(x=weeks$week, y=weeks$posts,
    xlab="Date", ylab="Posts per week")
lines(x=weeks$week, y=weeks$posts)

# Now aggregate with an average:
# First, construct a month variable
data$month = as.POSIXct(strptime(paste0(substr(data$created_time,1,7),'-01'),"%Y-%m-%d"))
# Then aggregate by month
results = aggregate(data$likes_count,by=list(month=data$month),FUN=mean)
# Select only the months after 2000
results = results[results$month>as.POSIXct('2000-01-01'),]

# Plot the average likes by month
plot(x=results$month,y=results$x,xlab='Month',ylab='Mean likes')
lines(x=results$month,y=results$x)












