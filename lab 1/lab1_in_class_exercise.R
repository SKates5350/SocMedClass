################################################################
## Introduction to data analysis with R: in-class exercise
## Author: Pablo Barbera
## Adapted by Sean Kates
## Social Media and Political Participation
## Lab 1, January 4th 2017
################################################################

## first, we change our working directory to where our data is stored
setwd("~/Dropbox/Teaching/j-term/lab\ 1")
## (remember that you can always just serch for the files on the bottom-right panel)

## now we use the 'read.csv' command to open the dataset
dataset = read.csv("lab1_nyu_data.csv", stringsAsFactors=F)

## we can look at the top right panel to see that it contains 874 observations
## and 10 variables. There we have the answer to question 1:

## 1) How many status updates has NYU Abu Dhabi posted on its page?
length(dataset$message)
nrow(dataset)

## 2) What is the average number of likes AND comments that its posts receive?
mean(dataset$likes_count)
mean(dataset$comments_count)

## 3) What is the maximum number of likes AND comments that its posts receive?
max(dataset$likes_count)
max(dataset$comments_count)

## 4) What was the content of the last status update of 2015?
dataset[872,]

## Bonus: how can we see the last 'n' rows of a data frame?
tail(dataset, n=5)

## How can we see the first 'n' rows of a data frame?
head(dataset, n=1)

