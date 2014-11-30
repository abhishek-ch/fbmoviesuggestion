require(class)
wants <- c("class","ggplot2")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


if(Sys.info()["user"] == 'achoudhary'){
  path = "D:/Work/Python/DataMining/git/movies.csv"
  movies <- read.csv(path)
}else{
  path = "/Users/abhishekchoudhary/Work/python/recommend/movies.csv"
  movies <- read.csv("/Users/abhishekchoudhary/Work/python/recommend/updated1.csv",header=TRUE, stringsAsFactors=FALSE,fileEncoding="latin1")
}

select <- movies[,c("imdbRating","tomatoRating")]
train <- select[sample(nrow(select), 20), ]
test <- select[sample(nrow(select), 20), ]
cl <- train[,1]
nn <- knn(train,test,cl,k=3,prob = TRUE)
summary(nn)

