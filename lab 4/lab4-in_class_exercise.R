################################################################
## Facebook Data: in-class exercise
## Author: Sean Kates
## Social Media and Political Participation
## Lab 4, January 9th 2017
################################################################

## first, we change our working directory to where our data is stored
setwd("~/Desktop/Winter Term Course/lab 4
## (remember that you can always just serch for the files on the bottom-right panel)

# loading the package
library(Rfacebook)
my_oauth = 'XXXXXXXYYYYYYZZZZZZ11111'

## Question 1
page = getPage("barackobama", token=my_oauth, n=1000) 

## Question 2
## 1) 
## most likes
page[which.max(page$likes_count),]
## most comments
page[which.max(page$comments_count),]
## most shares
page[which.max(page$shares_count),]

## 2)
## plot with evolution over time
page$datetime = formatFbDate(page$created_time)
results = aggregateMetric(page, metric="likes")
plot(x=results$month, y=results$x, type="l", ylim=c(0, max(results$x)),
     xlab="Month", 
     ylab="Total likes received", 
     main="Evolution in number of likes on a Facebook page")

## 3)
post = getPost(page$id[1], token=my_oauth, n.likes=500)
likes = post$likes
users = getUsers(likes$from_id, token=my_oauth)
head(sort(table(users$first_name), decreasing=TRUE), n=10)

## 4)
post = getPost(page$id[1], token=my_oauth, likes=FALSE, n.comments=1000)
comments = post$comments

wordFreq = word.frequencies(comments$message, stopwords=c("humans"))
library(wordcloud)
wordcloud(words=names(wordFreq), freq=wordFreq, max.words=50, 
          random.order=F, colors="black", scale=c(2.5,.5), rot.per=0)








