# Decision Tree

library(caret) # for decision tree
library(dplyr)
library(rattle) # for plot
library(rpart) # for plot

#hrdata <- HR_comma_sep # HR_comma_sep is the dataset

hrdata$left = as.factor(hrdata$left) # factorize

trainIndex <- createDataPartition(hrdata$left, p = .7,list = FALSE,times = 1) # 70%-30% split
trainData <- hrdata[ trainIndex,]
testData  <- hrdata[-trainIndex,]

decisionTreeModel <- train(left~.,method="rpart",data=trainData) # model with all variables on the training subset

fancyRpartPlot(decisionTreeModel$finalModel) # fancy plot

testData$pred <- predict(decisionTreeModel,testData) # get predictions
testData = testData %>% mutate(accurate = 1*(left == pred))
table(testData$pred,testData$left) # confusion matrix
sum(testData$accurate)/nrow(testData) # accuracy %
