#############################More On naive Bayes##################################
#http://rforwork.info/2014/12/09/predictive-modelling-fun-with-the-caret-package/
#details writing of training and different ways
#https://rstudio-pubs-static.s3.amazonaws.com/29863_ff15ecc9f97d4c3e9d66cc9aa8ae24f4.html
#Improvise the performance
#http://www.johnverostek.com/wp-content/uploads/2014/06/Chapter-11.pdf


library(caret)
library(e1071)
library(utils)
value <- unzip(leaf.zip)
data <- read.table(unz("leaf.zip", "leaf.csv"))
data <- zip.file.extract(file, zipname = "leaft.zip",
                 unzip = getOption("unzip"), dir = getwd())


#http://stackoverflow.com/questions/3053833/using-r-to-download-zipped-data-file-extract-and-import-data
##read the content from internet and get the csv from zip file
temp <- tempfile()
download.file("http://archive.ics.uci.edu/ml/machine-learning-databases/00288/leaf.zip",temp)
data <- read.table(unz(temp, "leaf.csv"),sep=",")

# This way once I split the data into a test set, 
#I won't get any complaints about missing outcome values if
#the sampling doesn't pick up one of those values!
df.factor <- as.data.frame(lapply(data,factor))
View(df.factor)

leaf = read.csv("C:/Users/achoudhary/Downloads/leaf/leaf.csv", colClasses = c(Class = "factor"))
View(leaf)
#This hurts more even naive Bayes needed factor but its not working properly
#either I need to skip this column and test or keep it as it is
#leaf[,'Stochastic_Convexity'] <- as.factor(leaf$Stochastic_Convexity)


ctrl = trainControl(method="repeatedcv", number=10, repeats=5, selectionFunction = "oneSE")
in_train = createDataPartition(leaf$Class, p=.75, list=FALSE)

####to find all the available method
names(getModelInfo())
#http://www.johnverostek.com/wp-content/uploads/2014/06/Chapter-11.pdf
#read above ti know more about different training packages


nb  = train(Class ~ Eccentricity+Aspect_Ratio+Elongation+Solidity+Stochastic_Convexity+
              Isoperimetric_Factor+Maximal_Indentation_Depth+Lobedness+Average_Intensity+
              Average_Contrast+Smoothness+Third_moment+Uniformity+Entropy, 
            data=leaf, method="nb",metric="Kappa", tuneGrid = expand.grid(fL=c(0,3),usekernel=c(FALSE,TRUE)), 
            trControl = ctrl, subset = in_train)


trf  = train(Class ~ Eccentricity+Aspect_Ratio+Elongation+Solidity+Stochastic_Convexity+
                      Isoperimetric_Factor+Maximal_Indentation_Depth+Lobedness+Average_Intensity+
                      Average_Contrast+Smoothness+Third_moment+Uniformity+Entropy, 
                    data=leaf, method="rf", metric="Kappa",
                    trControl=ctrl, subset = in_train)

#Stats analysis of 2 different approach
test = leaf[-in_train,]
confusionnb <- confusionMatrix(predict(nb,test),test$Class)
confusionTRF <- confusionMatrix(predict(trf,test),test$Class)

#Find absolute difference between 2 models
#http://rforwork.info/2014/12/09/predictive-modelling-fun-with-the-caret-package/
#naturally Random forest won the race
summary(diff(resamples(list(RF = trf,NB = nb))))


#caret has a function to calculate variable importance so that you can see which variables 
#were the most informative in making distinctions between classes
varImp(trf, scale=FALSE)
#varImp(nb, scale=FALSE)
