data<-read.table("trainingdata.csv")

#Get twitter data
data<-searchTwitter("dkpol+exclude:retweets", n=13805)
names(data)<-c("username","tweet")

#Classify happy and unhappy tweets
happy<-"((?::|;|=)(?:-)?(?:\\)|D))"
unhappy<-"((?::|;|=)(?:-)?(?:\\())"
data$happy <- grepl(happy,data$tweet)
data$unhappy <- grepl(unhappy,data$tweet)

#Make final dataset
finaldata<-data[-which(data$happy==TRUE & data$unhappy==TRUE),]
finaldata$sentiment_label[finaldata$happy==TRUE]<-4
finaldata$sentiment_label[finaldata$unhappy==TRUE]<-0
finaldata<-finaldata[,c(1,2,5)]

#Clean up
##Remove smileys
finaldata$tweet<-gsub(happy, "", finaldata$tweet)
finaldata$tweet<-gsub(unhappy, "", finaldata$tweet)

##Replace multiple occurances of same character
finaldata$tweet<-gsub("([[:alpha:]])\\1{2,}", "\\1\\1", finaldata$tweet)

##Replace URLS
finaldata$tweet<-gsub("(https?://[^/\\s]+)[^\\s]*", "URL", finaldata$tweet, perl=TRUE)

##Replace tweet-at-usernames
finaldata$tweet<-gsub("(?=\\@)(.*?)(?=(\\s|$))","USERNAME", finaldata$tweet, perl = TRUE)

##Remove dkpol hashtag
finaldata$tweet<-gsub("\\#dkpol","", finaldata$tweet, perl = TRUE)


##Clean up linebreaks
finaldata$tweet<-gsub("[\r\n]", "", finaldata$tweet)


#write csv file
write.csv(finaldata,"trainingdataclean.csv")
