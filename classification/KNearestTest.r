#http://blog.webagesolutions.com/archives/1164

require(class)
require(ggplot2)
wants <- c("class","ggplot2")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


if(Sys.info()["user"] == 'achoudhary'){
  path = "D:/Work/Python/DataMining/git/updated_1.csv"
  movies <- read.csv(path)
}else{
  path = "/Users/abhishekchoudhary/Work/python/recommend/movies.csv"
  movies <- read.csv("/Users/abhishekchoudhary/Work/python/recommend/updated1.csv",header=TRUE, stringsAsFactors=FALSE,fileEncoding="latin1")
}

#classfication is almost always yes or no, so it will either this or that

select <- scale(movies[,c("imdbRating",  "imdbVotes",  "tomatoRating",	"tomatoUserReviews",	"genre1",	"genre2")])
train <- select[sample(nrow(select), 20), ]
test <- select[4,c("imdbRating",  "imdbVotes",  "tomatoRating",    "tomatoUserReviews",  "genre1",	"genre2")]
#classification labels are the categories you are expecting values
#like if we think based on user base and points is it classified of genre1 or genre2 , but
#this is a very crap case and genre can't be decided based on user votes and rating
#
#
### But a user choice can be distinguished that what kind of genre he likes more
cl <- factor(c(rep("imdbRating",10),  rep("tomatoRating",10) ))
nn <- knn(train,test,cl,k=3,prob = TRUE)
summary(nn)
qplot(nn)


