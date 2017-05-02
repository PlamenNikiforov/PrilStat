# Decision Tree

library(caret) # for decision tree
library(dplyr)
library(rattle) # for plot
library(rpart) # for plot

#HR <- HR_comma_sep # HR_comma_sep is the dataset

HR$left = as.factor(HR$left) # factorize

trainIndex <- createDataPartition(HR$left, p = .7,list = FALSE,times = 1) # 70%-30% split
trainData <- HR[ trainIndex,]
testData  <- HR[-trainIndex,]

decisionTreeModel <- train(left~.,method="rpart",data=trainData) # model with all variables on the training subset

fancyRpartPlot(decisionTreeModel$finalModel) # fancy plot

testData$pred <- predict(decisionTreeModel,testData) # get predictions
testData = testData %>% mutate(accurate = 1*(left == pred))
table(testData$pred,testData$left) # confusion matrix
sum(testData$accurate)/nrow(testData) # accuracy %
