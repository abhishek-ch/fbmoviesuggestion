#http://www.cs.uu.nl/docs/vakken/b3dar/dar-lecture-1.pdf
#http://rdatamining.wordpress.com/2011/11/09/using-text-mining-to-find-out-what-rdatamining-tweets-are-about/
#https://www.linkedin.com/pulse/article/20141205003839-34768479-1-6m-emoticon-stripped-tweets-44k-entry-sentiment-lexicon
#http://www.rdatamining.com/examples/twitter-follower-map

install_github("geoffjentry/twitteR", username="geoffjentry")
library(devtools)
#install_github is package of devtools
library(RCurl)
library(twitteR)
library(tm)
source("TwitterData.R")
library(SnowballC)
library(stringr)

setup_twitter_oauth(apiKey,apiSecret,access_token,access_token_secret)
mach_tweets = searchTwitter("#movies", n=5000)
traindata <- sapply(mach_tweets, function(x) x$getText())


###cleaning dataset
#http://stackoverflow.com/questions/3056146/how-to-convert-searchtwitter-results-from-librarytwitter-into-a-data-frame
#check above to know more about unclass and slots inside twitter return data
tweetsDF <- do.call("rbind", lapply(mach_tweets, as.data.frame))
##View(traindata)

trendword <- tweetsDF$text
# remove retweet entities
trendword = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", trendword)
# remove at people
trendword = gsub("#movies", "", trendword)
trendword = gsub("#Movies", "", trendword)
trendword = gsub("@\\w+", "", trendword)
trendword = gsub("ur", "", trendword)
# remove punctuation
trendword = gsub("[[:punct:]]", "", trendword)
# remove numbers
trendword = gsub("[[:digit:]]", "", trendword)
# remove html links
trendword = gsub("http:.+", "", trendword)
trendword = gsub("http\\w+", "", trendword)
trendword = gsub("\n", "", trendword)
trendword = gsub(":", "", trendword)
#cleaning the special charaters which mostly comes from twitter data
trendword = gsub("U+[a-zA-Z0-9]{0,10}", "", trendword)
#replace all non-english text from Corpus
trendword = str_replace_all(trendword, '[^(a-zA-Z0-9!@#$%&*(_) ]+', "")


##Clean the data more
distinct <- unique(trendword)
Encoding(distinct) <- "UTF-8"
distinct <- iconv(distinct, "UTF-8", "UTF-8",sub='') ## replace any non UTF-8 by ''

distinct=str_replace_all(distinct,"[^[:graph:]]", " ") 
write.table(distinct, file = "movies1.csv",sep = ",", col.names = NA,
            qmethod = "double")


corpus <- Corpus(VectorSource(trendword))
#This is important because of new version and to use stem in new version of R
#http://stackoverflow.com/questions/24191728/documenttermmatrix-error-on-corpus-argument
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, function(x) removeWords(x, stopwords("english")))

inspect(corpus)
#http://stackoverflow.com/questions/25638503/tm-loses-the-metadata-when-applying-tm-map
#since tm doesnt work properly in this version so added this

copycorpus <- corpus

corpus <- tm_map(corpus, PlainTextDocument)

copycorpus <- tm_map(copycorpus, stemDocument)
copycorpus <- tm_map(copycorpus, stripWhitespace)


tdm <-TermDocumentMatrix(copycorpus,control = list(minWordLength = c(1,Inf)))

inspect(corpus[1:10])
inspect(tdm[idx + (0:5),100:110])

#https://heuristically.wordpress.com/2011/04/08/text-data-mining-twitter-r/
#work with all these data
idx <- which(dimnames(corpus1)$Terms == "bjp")
inspect(tdm[idx + (0.5), 101:110])


########################Word & Assocoaition##########################
#http://www.slideshare.net/rdatamining/text-mining-with-r-an-analysis-of-twitter-data
library(ggplot2)
library(graph)

source("http://bioconductor.org/biocLite.R")
biocLite("Rgraphviz")
library(Rgraphviz)

freq.terms <- findFreqTerms(tdm, lowfreq=150)
term.freq <- rowSums(as.matrix(tdm))
term.freq <- subset(term.freq,term.freq >= 250)
df <- data.frame(term = names(term.freq),freq = term.freq)
ggplot(df,aes(x = term , y = freq))+ geom_bar(stat = "identity",fill = df$freq)+xlab("Terms")+
  ylab("Count") + coord_flip()

findAssocs(corpus1, 'rape', 0.30)

#replace term with term.freq
plot(tdm, term = freq.terms, corThreshold = 0.12 , weighting = T)



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


####################Exploring Distances######################
#http://www.cs.uu.nl/docs/vakken/b3dar/dar-lecture-1.pdf

library(e1071)
library(fpc)

tdm2 <- removeSparseTerms(tdm , sparse = 0.95)
dim(tdm2)



matrix2 <- as.matrix(tdm2)
#cluster terms
distMatrix <- dist(scale(matrix2))
fit <- hclust(distMatrix,method="ward.D")
plot(fit)
#cut tree into 5 clusters
rect.hclust(fit,k=6)

####K-Mean
m3 <- t(matrix2)
k <- 6  #number of clusters
kmeansResult <- kmeans(m3,k)
round(kmeansResult$centers , digits = 3)


###Cluster of words
#picket 10 cluster as 6 were not resulting better
for(i in 1:k){
  
  cat(paste("cluster ",i,": ",sep=""))
  s <- sort(kmeansResult$centers[i,],decreasing = T)
  cat(names(s)[1:5],"\n")
}


#Manhattan Distance

manhatResult <- pamk(m3,metric = "manhattan")
k <- manhatResult$nc
pamResult <- manhatResult$pamobject

for (i in 1:k) {
  cat("cluster", i, ": ",
      colnames(pamResult$medoids)[which(pamResult$medoids[i,]==1)], "\n")
}

# plot clustering result
layout(matrix(c(1, 2), 1, 2)) # set to two graphs per page
plot(pamResult, col.p = pamResult$clustering)
layout(matrix(1)) 










####################################Using Naive Bayes#############################
#Convert to Bernoulli NB model
matrixBB <- matrix2 > 0
#convert matrix to dataframe
matrixBB.df <- as.data.frame(matrixBB)
View(matrixBB.df)

train <- matrixBB.df[,1:4000]
test <- matrixBB.df[,4001:5000]




##Extract Class labels
train.class <- as.vector(unlist(lapply(train,meta,tag="genre")))
classlab <- as.factor(names(train))


twitternaive <- naiveBayes(train,classlab[train],laplace = 1)
predict <- predict(twitternaive,test[,1:10])
table(predict,test)



###############################Naive Bayes Examples####################

library(e1071)
df = read.table("C:/Users/achoudhary/Downloads/iHealth/iHealth/i-01", 
               sep="\t", 
               col.names=c("interest", "currlevel","motivated","tectcomfort","model"), 
               fill=FALSE, 
               strip.white=TRUE)
View(df)
prop.table(table(df$motivated))
trainIndex <- sample(nrow(df), 10)
train <- df[trainIndex, ]
test <- df[-trainIndex,]


naiveModel <- naiveBayes(model~.,data=train,laplace=2.0)
table(predict(naiveModel,test[1:4]))

#DF <- as.data.frame(unclass(df))
#model1 = lm(model~., data = DF)

#to find how many variables suit the best
#step(model1, direction="backward")


te <- data.frame(interest="both",currlevel="sedentary",motivated="moderate",tectcomfort="yes")
table(predict(naiveModel,te))




