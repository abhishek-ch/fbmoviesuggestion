#http://www.omdbapi.com/
#http://www.r-bloggers.com/top-250-movies-at-imdb/
# Install the Rstem and sentiment packages if not installed.
#https://www.linkedin.com/pulse/article/20141116012757-34768479-9k-tweets-re-12-financial-groups-polarity-and-emotion
#https://gist.github.com/Inpirical-Coder/aa8a93566f9e7404e4fe
#http://docs.ggplot2.org/0.9.3.1/geom_bar.html


# Define the dependency packages we need.
required.packs = c("twitteR",
                   "sentiment",          # Sentiment analysis.
                   "tm",                 # Text mining.
                   "plyr",               # Splitting, plotting, combining data.
                   "ggplot2",            # Plotting.
                   "wordcloud",          # Create wordclouds.
                   "data.table",         # Data tables.
                   "RColorBrewer",      # Palettes for visualisation.      
                   "dplyr",
                   "corrplot"
)
install.packages("corrplot")

# Install the required packages if missing, then load them.
sapply(required.packs, function(pack) {
  if(!(pack %in% installed.packages())) {install.packages(pack)}
  require(pack, character.only=TRUE)
})
library(car)
library(RJSONIO)
source("/Users/abhishekchoudhary/MachineLearning/Graphmultiplot.R")
#tt <- htmlParse('http://www.omdbapi.com/?t=The+dark+knight&y=&plot=short&r=xml&tomatoes=true')
#document <- fromJSON('http://www.omdbapi.com/?t=The+dark+knight&y=&plot=short&r=json&tomatoes=true')
#View(document)
#http://www.omdbapi.com/?t=Romance+of+Astrea+and+Celadon&y=&r=xml&tomatoes=true



value <- read.csv("C:/Users/achoudhary/Google Drive/BIG/Python/output.csv")
View(value)
View(unique(value))

#Filter With Any Movie
filter(value,User =="Akshi*")

movie_table = as.data.frame(table(value$Movie))
updated <- movie_table[movie_table$Freq>25,]

#Plot the Most Popular Movies among Friends
gmovie <- ggplot(updated, aes(x = factor(Var1), y = Freq,fill=Var1)) +
  geom_bar(stat = "identity") +
  labs(x="Most Popular Movies Among FB friends", y="Movie Occurances")+
  ggtitle(" Popular Movies Amongs Friends in facebook")


#####Top Movie Likers
name_table = as.data.frame(table(value$User))
updated_name <- name_table[name_table$Freq > 24,]
View(updated_name)
#Plot the Most Popular Movies among Friends
gname <- ggplot(updated_name, aes(x = factor(Var1), y = Freq,fill=Var1)) +
  geom_bar(stat = "identity") +
  labs(x="Movies Like by fb Friends", y="Movie Occurances")+
  ggtitle(" Popular Movies Amongs Friends in facebook")

auto <- c(name_table$Var1,name_table$Freq)
multiplot(gmovie,gname)

##Populate the graph for range , the number of people falls in a range or
#count of movie likes within range
updated_name$group <- cut(updated_name$Freq, breaks = seq(0, max(updated_name$Freq) + 4, by = 3), include.lowest = T)

ggplot(updated_name, aes(x = group,fill=group)) + geom_bar()

#http://stackoverflow.com/questions/14363085/invalid-multibyte-string-in-read-csv

#The sequence of column in CSV does matter the smoot_spline method to work properly
if(Sys.info()["user"] == 'achoudhary'){
  path = "D:/Work/Python/DataMining/git/updated1.csv"
  movies <- read.csv(path)
}else{
  path = "/Users/abhishekchoudhary/Work/python/recommend/updated1.csv"
  movies <- read.csv("/Users/abhishekchoudhary/Work/python/recommend/updated1.csv",header=TRUE, stringsAsFactors=FALSE,fileEncoding="latin1")
}




#http://www.r-bloggers.com/model-validation-interpreting-residual-plots/
#http://rtutorialseries.blogspot.ie/2009/12/r-tutorial-series-graphic-analysis-of.html
tableMov <- read.table(movies$imdbRating)
year_table = as.data.frame(table(movies$imdbRating))
year_table[year_table$Freq > 300,]

model <- lm(imdbVotes ~ imdbRating + tomatoRating + tomatoUserReviews+ I(genre1 ** 3.0) +I(genre2 ** 2.0)+I(genre3 ** 1.0), data = movies)
res <- qplot(fitted(model), resid(model))
res+geom_hline(yintercept=0)
#"imdbVotes ~ imdbRating + tomatoRating + tomatoUserReviews+ I(genre1 ** 1.0) +I(genre2 ** 1.0)+I(genre3 ** 4.0)", data=df2)
#method = "lm")
#############################################General Plots##################################
residualPlots(model, ~ 1, fitted=TRUE) #Residuals vs fitted
qqnorm(resid(model))
qqline(resid(model))
avPlots(model, id.n=2, id.cex=0.7)



hist(resid(model), freq = FALSE)
curve(dnorm, add = TRUE)


probDist <- pnorm(resid(model))
plot(ppoints(length(resid(model))), sort(probDist), main = "PP Plot", xlab = "Observed Probability", ylab = "Expected Probability")
abline(0,1)

#######################Plot with each variable and output##################################

qplot(imdbRating, imdbVotes,color=factor(genre1), data=movies, geom=c("smooth", "point"))
qplot(tomatoRating, imdbVotes,color=factor(genre1), data=movies, geom=c("smooth", "point"))


################################Residual Plot with item and Model##########################

##wel we can surely derive a pattern , so naturally its not that good data
res <- qplot(movies$imdbVotes, resid(lm(imdbVotes ~ genre1,data=movies)))
res+geom_hline(yintercept=0)

#Entire model didn't derive good data
res1 <- qplot(movies$imdbVotes, resid(model))
res1+geom_hline(yintercept=0)




confint(model,level=0.95)
##############################Regression#######################################
library(ggplot2)
library(xtable)

df <- read.csv("C:/Users/achoudhary/Google Drive/BIG/Python/Movies.csv")
df = df[!(is.na(df$imdbVotes) | df$imdbVotes =="N/A" | df$imdbVotes =='N/A'), ]


model <- lm(data = df,formula = tomatoRating ~ imdbRating  + imdbVotes)

sample_table <- xtable(df)
print(xtable(sample_table), type="html", file="example.html")



##########################################Smoothing in-built########################

###########Plotting the smooth graph##########################
#check NonLinearRegression.R

#other example

model2 <- lm(imdbVotes ~ imdbRating + I(genre1 ** 3.0) +I(genre2 ** 2.0), data = movies)
residualPlots(model2, ~ 1, fitted=TRUE) #Residuals vs fitted



##to find how good is the model or fit or validity of the model, run the residual plot
res <- qplot(fitted(model2), resid(model2))
res+geom_hline(yintercept=0)


##to find how good is the model or fit or validity of the model, run the residual plot
res1 <- qplot(fitted(model), resid(model))
res1+geom_hline(yintercept=0)

#Not much difference found in Model and Model2 so better to use model2 as it has less
##input variable to take care

confint(model2,level=0.99)
confint(model,level=0.99)

qplot(imdbVotes , imdbRating +genre1+genre2, 
      data = model, geom = c("point", "smooth"),
      method = "lm")


######################################Poisson Regression and Output Regression Plot######################
#Poisson is better choice 
#http://stats.stackexchange.com/questions/125561/what-does-added-variable-plot-explain-while-working-on-multiple-regression?noredirect=1#comment239411_125561
#http://www.ats.ucla.edu/stat/r/dae/poissonreg.htm

m1 <- glm(imdbVotes ~ imdbRating + I(genre1 ** 3.0) +I(genre2 ** 2.0), family="poisson", data=movies)
###This plot didn't push any data beyind 0 , so naturally its better choice than  lm
res2 <- qplot(fitted(m1), resid(m1))

#This showed that poisson model is much better than lm
hist(resid(m1), freq = FALSE)
curve(dnorm,add=TRUE)


s1 <- data.frame(imdbRating=7.5,genre1=21,genre2=12)
predict(m1,s1,type="response",se.fit=TRUE)

predict(model2,s1,type="response",se.fit=TRUE)
movies$phat <-predict(m1,type="response")
movies$phat1 <-predict(model,type="response")

chunk2 <- function(x,n) split(x, cut(seq_along(x), n, labels = FALSE)) 

## create the plot
ggplot(movies, aes(x = imdbRating, y = phat, colour = factor( genre1+genre2+genre3 ))) +
  geom_point(aes(y = imdbVotes), alpha=.5, position=position_jitter(h=.2)) +
  geom_line(size = 1) +
  labs(x = "Math Score", y = "Expected number of awards")


################################CORRELATION-MATRIX##########################
pairs(movies[,8:ncol(movies)])
pairs(movies[,8:12])

x <- movies[8:9]
y <- movies[11:12]
cor(x,y, use="complete.obs", method="kendall")


