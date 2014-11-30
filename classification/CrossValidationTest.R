#http://www.uni-kiel.de/psychologie/rexrepos/posts/crossvalidation.html
#http://gerardnico.com/wiki/r/cross_validation

require(boot)
require(ggplot2)
require(caret)

wants <- c("boot","ggplot2","caret","e1071")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

if(Sys.info()["user"] == 'achoudhary'){
  path = "D:/Work/Python/DataMining/git/movies.csv"
  movies <- read.csv(path)
}else{
  path = "/Users/abhishekchoudhary/Work/python/recommend/movies.csv"
  movies <- read.csv("/Users/abhishekchoudhary/Work/python/recommend/updated1.csv",header=TRUE, stringsAsFactors=FALSE,fileEncoding="latin1")
}

## 10-fold CV
# A vector for collecting the errors.
cv.error10=rep(0,5)
# The polynomial degree
degree=1:5
# A fit for each degree
for(d in degree){
  glm.fit=glm(imdbVotes ~ imdbRating + genre1 +genre2+genre3+tomatoRating+tomatoUserReviews, data=movies)
  cv.error10[d]=cv.glm(movies,glm.fit,K=10)$delta[1]
}
qplot(degree,cv.error10, geom = "line", colour=degree)+geom_point()

fit=glm(imdbVotes ~ imdbRating + genre1 +genre2+genre3+tomatoRating+tomatoUserReviews, data=movies)
kfCV <- cv.glm(data=movies, glmfit=fit, K=3)


confusionMatrix(movies$imdbVotes, sample(movies$imdbVotes))
