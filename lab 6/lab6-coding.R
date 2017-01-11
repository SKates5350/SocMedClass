################################################################
## Example of Analysis of Coded Data
## Author: Sean Kates
## Social Media and Political Participation
## Lab 6, January 11 2017
################################################################

# Set the working directory
setwd("~/Desktop/Winter Term Course/lab 6/")

## Loading coding results
codings = read.csv("crowdflower.csv", stringsAsFactors=F, colClasses="character")

## Set up some variables for the different message types
codings$msg_media = grepl('media',codings$message)
codings$msg_attack = grepl('attack',codings$message)
codings$msg_constit= grepl('constituency',codings$message)
codings$msg_personal = grepl('personal',codings$message)
codings$msg_support = grepl('support',codings$message)
codings$msg_mobilization = grepl('mobilization',codings$message)
codings$msg_policy = grepl('policy',codings$message)
codings$msg_info = grepl('information',codings$message)
codings$msg_other = grepl('other',codings$message)

############################################
### DESCRIPTIVE ANALYSIS     			 ###
############################################

## How many tweets aimed at the constituency vs nationally?
table(codings$audience)

## How many tweets exhibit partisan bias?
table(codings$bias)

## How many tweets fall in each type of message?
summary(codings[,grep('msg',names(codings))])

library(NYU160J)
## Which words signify a national audience? Constituency?
wordFreq_const = word.frequencies(codings$text[codings$audience=="constituency"],stopwords='today')
head(wordFreq_const, n=20)

wordFreq_nation = word.frequencies(codings$text[codings$audience=="national"],stopwords='today')
head(wordFreq_nation, n=20)

# Display it in a wordcloud
library(wordcloud)
par(mfrow=c(1,2))
wordcloud(words=names(wordFreq_const), freq=wordFreq_const, max.words=50, 
    random.order=F, colors="black", scale=c(2.5,.5), rot.per=0)
title(main='Constituency')

wordcloud(words=names(wordFreq_nation), freq=wordFreq_nation, max.words=50, 
    random.order=F, colors="black", scale=c(2.5,.5), rot.per=0)
title(main='National')

# Look at bivariate correlations
round(cor(codings[,grep('msg',names(codings))]),digits=2)

####################################################
### BASIC EXAMPLE OF MACHINE LEARNING CLASSIFIER ###
####################################################

## converting text into a data matrix
doc_matrix <- t(as.matrix(create_matrix(codings$text)))
doc_matrix <- doc_matrix[,colSums(doc_matrix)>1]
values <- (codings$audience=="national")*1

## training machine learning classifier
install.packages("e1071")
library(e1071)
classifier <- naiveBayes(doc_matrix, factor(values))

# looking at new examples
text <- paste0("Today I stood with the President in the Senate to pass a new budget.")
words <- unlist(strsplit(tolower(text), "\\s+"))
text <- (dimnames(doc_matrix)[[2]] %in% words)*1

predict(classifier, matrix(text, nrow=1), type="raw")

##########################################################
### ADVANCED MACHINE LEARNING FOR EXPLORATORY ANALYSIS ###
##########################################################

library(stm)
processed <- textProcessor(codings$text, metadata=codings, language="english", stem=FALSE)
processed <- prepDocuments(processed$documents, processed$vocab, processed$meta, lower.thresh=10)

# This is slow!
model <- stm(processed$documents,processed$vocab,K=25,init.type="LDA",prevalence=~audience,max.em.its=500, data=processed$meta)

# Find the largest and smallest topics:
plot.STM(model, type="summary")
big = c(8,24,7)
small = c(3,19,18)

# Look at the words used in them
labelTopics(model,topics=big)
labelTopics(model,topics=small)


