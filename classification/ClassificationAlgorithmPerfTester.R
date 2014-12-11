#to load the main package to run various classification algorithm
#http://machinelearningmastery.com/how-to-estimate-model-accuracy-in-r-using-the-caret-package/
library(caret)
library(ggplot2)

setwd("D:/Work/Python/DataMining/git/classification")

#load the dat file
file <- file("shuttle.dat")

#skip top 15 lines which give explaination and load rest of the contents
data = read.table(file, skip=14,sep=",", colClasses = c(V10 = "factor"))

#rename the output variable column name
colnames(data)[10] <- "Class"
View(data)


##Basic Analysis which didn't make any sense to me####
#as it follows prediction model
model = lm(Class~., 
            data = data)

qplot(Class ,V1+V2+V3+V4+V5+V6+V7+V8+V9, 
      data = model, geom = c("point", "smooth"),
      method = "lm")

res <- qplot(fitted(model), resid(model))
res+geom_hline(yintercept=0)


###########################

#train the model
trainCtr = trainControl(method="repeatedcv", number=10, repeats=5, selectionFunction = "oneSE")
train = createDataPartition(data$Class, p=.75, list=FALSE)

nab  = train(Class ~ ., 
            data=data, method="nb", tuneGrid = expand.grid(fL=c(0,3),usekernel=c(FALSE,TRUE)), 
            trControl = trainControl(method = "cv", number = 5), subset = train)


trf  = train(Class ~ ., 
             data=data, method="rf",
             tuneGrid = expand.grid(mtry = c(2,15,27,39,52)), 
             trControl = trainControl(method = "cv", number = 5), subset = train)


#Stats analysis of 2 different approach
test = data[-train,]
confusionnb <- confusionMatrix(predict(nab,test),test$Class)
confusionTRF <- confusionMatrix(predict(trf,test),test$Class)

summary(diff(resamples(list(RF = trf,NB = nab))))




###Test the Output
test = data[-in_train,]
dim(test)

testNAB <- predict(nab,test[1:10,-10])
testNAB
testRF <- predict(trf,test[1:10,-10])
testRF
