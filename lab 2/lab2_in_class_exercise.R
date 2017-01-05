################################################################
## Statistical analysis with R: in-class exercise
## Author: Pablo Barbera
## Social Media and Political Participation
## Lab 2, January 5th 2017
################################################################

## first, we change our working directory to where our data is stored
setwd("~/Dropbox/Teaching/j-term/lab\ 2")
## (remember that you can always just serch for the files on the bottom-right panel)

## now we use the 'read.csv' command to open the dataset
dataset <- read.csv("lab2_trump_data.csv", stringsAsFactors=F)
dataset$month <- substr(dataset$created_time, 6, 7)
dataset$year <- substr(dataset$created_time, 1, 4)

## 1) What type of post (photo, status, link, video) is the most common 
## on Trump's Facebook page?
table(dataset$type)
prop.table(table(dataset$type))

## statuses! Almost 40% of posts are status updates

## 2) Do posts that contain photos receive more likes on average than links?
aggregate(dataset$likes_count, 
          by=list(type=dataset$type), 
          FUN=mean)
## Yes! 37646 likes on average vs 24016 likes on average for links, for example

## 3) Are more liked posts also more shared?
cor(dataset$likes_count, dataset$shares_count)

plot(x=dataset$likes_count, y=dataset$shares_count,
     xlab="Number of likes", ylab="Number of shares",
     pch=16, cex=0.50)
fit = lm(shares_count~likes_count,dataset)
lines(x=dataset$likes_count,y=predict(fit),col='red')

# Yes! But on the plot we find one "outlier" (an observation with unusual values)
# Why? Let's find out...
which(dataset$shares_count>4e5)

dataset[which(dataset$shares_count>4e5),]
# an image basically designed to 'go viral'
# https://www.facebook.com/DonaldTrump/photos/a.488852220724.393301.153080620724/10153087641065725/?type=3

## 4) Create a plot that displays the total number of likes on the page each month.
likes_by_month = aggregate(dataset$likes_count, 
                        by=list(month=dataset$month), 
                        FUN=sum)
barplot(likes_by_month$x, names=1:12, xlab="Month", ylab="Total likes")

## Why are February to May lower?
## Maybe because there were fewer posts those months?
table(dataset$month)
# Maybe a little bit, but not enough to explain the difference

likes_time_series = aggregate(dataset$likes_count, 
                        by=list(month=dataset$month,year=dataset$year), 
                        FUN=sum)
barplot(likes_time_series$x, 
	names=paste(likes_time_series$month,likes_time_series$year,sep='/'), 
	las=2,
	cex.names=.4,
	xlab='Time',
	ylab='Total Likes')
# Aha! Donald Trump announced his candidacy on June 16.



