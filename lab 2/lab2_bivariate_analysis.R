################################################################
## Bivariate Analysis
## Author: Pablo Barbera
## Adapted by Sean Kates
## Social Media and Political Participation
## Lab 2, January 5th 2017
################################################################

## As usual, before we run anything, we make sure to change the working
## directory to where we have all our code and data stored. In my case, it is:
setwd("~/Desktop/Winter Term Course/lab 2")
## But it will different for yours! Click on the wheel on the files tab on
## the bottom right panel; then choose "set as working directory"; and paste
## here in the script what you see on the console

## We will work with the same dataset as before
dataset <- read.csv("lab2_trump_data.csv", stringsAsFactors=F)
dataset$month <- substr(dataset$created_time, 6, 7)
dataset$year <- substr(dataset$created_time, 1, 4)

## To identify posts mentioning (for example) Obama:
obama_posts = grep('obama',dataset$message,ignore.case=TRUE)

obamadf<-dataset[obama_posts,]

## Posts which use the word 'great'
great_posts = grep('great',dataset$message,ignore.case=TRUE)

####################################################
### BIVARIATE ANALYSIS: 2 CATEGORICAL VARIABLES ####
####################################################

## contingency table: relationship between month of the year and type of post
table(dataset$month, dataset$type)

########################################################
### BIVARIATE ANALYSIS: 1 CONTINUOUS, 1 CATEGORICAL ####
########################################################

## average number of likes received by posts published each month
aggregate(dataset$likes_count, 
          by=list(month=dataset$month), 
          FUN=mean)
# note that "aggregate" has 3 options:
# 1) the continuous variable that we want to aggregate
# 2) the categorical variable over which we will aggregate (inside a 'list' function)
# 3) FUN=mean indicates that we want to compute the mean

# For example, imagine that we want to compute the sum (total) number of likes by month
aggregate(dataset$likes_count, 
          by=list(month=dataset$month), 
          FUN=sum)

# what about the maximum?
aggregate(dataset$likes_count, 
          by=list(month=dataset$month), 
          FUN=max)

# now let's see how we can prepare a plot showing the average number of likes per month
# first we use the command aggregate to compute that (see above)
likes_count = aggregate(dataset$likes_count, 
          by=list(month=dataset$month), 
          FUN=mean)
# BUT: note that we now we save it as a new object, which is a data frame in itself
str(likes_count)
likes_count$x ## this is the name of the variable that contains the count per month

# finally, we can use the barplot command to display
barplot(likes_count$x, names=1:12, xlab="Month", ylab="Average likes")
# Note that we need to specify the "names" (labels on the x-axis) manually

###################################################
### BIVARIATE ANALYSIS: 2 CONTINUOUS VARIABLES ####
###################################################

# do posts that get more likes also receive more comments?
cor(dataset$likes_count, dataset$comments_count)
# a correlation coefficient of +0.86 indicates a positive association 
# (more likes = more comments)

# scatter plot comparing number of likes and number of comments
plot(x=dataset$likes_count, y=dataset$comments_count,
     xlab="Number of likes", ylab="Number of comments")

# we can modify the type of dots to make it look prettier
plot(x=dataset$likes_count, y=dataset$comments_count,
     xlab="Number of likes", ylab="Number of comments",
     pch=16, cex=0.50, main="Relationship between likes and comments")
# pch=16 means we want to use dark circles
# cex=0.50 means we want to make them 50% smaller

# Another way to look at the correlation is by running a regression
# For our purposes, you can just think about this as finding a line
# of best fit
# The function to do this in R is 'lm' (linear model)
fit = lm(comments_count~likes_count,dataset)
# We can add this to our previous plot with the following line of code
lines(x=dataset$likes_count,y=predict(fit),col='red')
# If you've taken a stats class before, you should be able to make some sense
# out of the summary information from the model
summary(fit)




