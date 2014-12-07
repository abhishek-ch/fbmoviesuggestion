#http://www.cs.uu.nl/docs/vakken/b3dar/dar-lecture-1.pdf
#http://rdatamining.wordpress.com/2011/11/09/using-text-mining-to-find-out-what-rdatamining-tweets-are-about/
#https://www.linkedin.com/pulse/article/20141205003839-34768479-1-6m-emoticon-stripped-tweets-44k-entry-sentiment-lexicon
#http://www.rdatamining.com/examples/twitter-follower-map

library(devtools)
#install_github is package of devtools
install_github("geoffjentry/twitteR", username="geoffjentry")
library(RCurl)
library(twitteR)
library(tm)
source("TwitterData.R")
library(SnowballC)

setup_twitter_oauth(apiKey,apiSecret,access_token,access_token_secret)
mach_tweets = searchTwitter("#MufflerMan", n=5000)
traindata <- sapply(mach_tweets, function(x) x$getText())


###cleaning dataset
#http://stackoverflow.com/questions/3056146/how-to-convert-searchtwitter-results-from-librarytwitter-into-a-data-frame
#check above to know more about unclass and slots inside twitter return data
##traindata <- do.call("rbind", lapply(mach_tweets, as.data.frame))
##View(traindata)

trendword <- traindata
# remove retweet entities
trendword = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", trendword)
# remove at people
trendword = gsub("@\\w+", "", trendword)
trendword = gsub("ur", "", trendword)
# remove punctuation
trendword = gsub("[[:punct:]]", "", trendword)
# remove numbers
trendword = gsub("[[:digit:]]", "", trendword)
# remove html links
trendword = gsub("http\\w+", "", trendword)
trendword = gsub("\n", "", trendword)
#cleaning the special charaters which mostly comes from twitter data
trendword = gsub("U+[a-zA-Z0-9]{0,10}", "", trendword)
#replace all non-english text from Corpus
trendword = str_replace_all(trendword, '[^(a-zA-Z0-9!@#$%&*(_) ]+', "")


corpus <- Corpus(VectorSource(trendword))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, function(x) removeWords(x, stopwords("english")))

inspect(corpus)
#http://stackoverflow.com/questions/25638503/tm-loses-the-metadata-when-applying-tm-map
#since tm doesnt work properly in this version so added this
corpus <- tm_map(corpus, PlainTextDocument)

corpus <- tm_map(corpus, stemDocument)
corpus <- tm_map(corpus, stripWhitespace)


corpus1 <-DocumentTermMatrix(corpus,control = list(minWordLength = 3))

inspect(corpus[1:10])


#https://heuristically.wordpress.com/2011/04/08/text-data-mining-twitter-r/
#work with all these data
findFreqTerms(corpus1, lowfreq=80)
findAssocs(corpus1, 'give', 0.30)

##########################Word cloud#########################
library(wordcloud)
library(RColorBrewer)
library(stringr)


m <- as.matrix(corpus1)
v <- sort(colSums(m), decreasing=TRUE)
myNames <- names(v)

d <- data.frame(word=myNames, freq=v)
 wordcloud(d$word, d$freq, min.freq=20,random.color=TRUE)

pal2 <- brewer.pal(8,"Dark2")
wordcloud(corpus,min.freq=2,max.words=300, random.order=T, colors=pal2)

dev.off()





###############################Plotting####################

mydata.df <- as.data.frame(inspect(corpus1))


mydata.df.scale <- scale(mydata.df)
d <- dist(mydata.df.scale, method = "euclidean") # distance matrix
fit <- hclust(d)
plot(fit) # display dendogram?

groups <- cutree(fit, k=5) # cut tree into 5 clusters
# draw dendogram with red borders around the 5 clusters
rect.hclust(fit, k=5, border="red")

