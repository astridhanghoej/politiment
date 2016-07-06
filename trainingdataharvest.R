#Load packages
library(twitteR)

#Setup Oauth
api_key<-"YourApiKeyHere"
api_secret<-"YourApiSecretHere"
access_token<-"YourAccessTokenHere"
access_token_secret<-"YourAccessTokenSecretHere"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

#Get twitter data
happydata<-searchTwitter("dkpol+:)+exclude:retweets+lang:da", n=10000)
unhappydata<-searchTwitter("dkpol+:(+exclude:retweets+lang:da", n=10000)

#Subset data to be used from list element
tweetsh<-as.data.frame(cbind(username=sapply(happydata,function(x) x$screenName),tweet=sapply(happydata,function(x) x$text)))
tweetsuh<-as.data.frame(cbind(username=sapply(unhappydata,function(x) x$screenName),tweet=sapply(unhappydata,function(x) x$text)))

data<-rbind(tweetsh,tweetsuh)
olddata<-read.table("trainingdata.csv")
names(olddata)<-names(data)

newdata<-unique(rbind(data,olddata))

write.table(newdata,"trainingdata.csv",col.names = F,row.names = F)
