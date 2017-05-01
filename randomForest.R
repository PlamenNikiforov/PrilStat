# random forest
# first run classing.R

library(randomForest)
library(dplyr)

#hrdata <- HR_comma_sep # HR_comma_sep is the dataset
hrdata[] <- lapply(hrdata, factor) # factorize everything
trainIndex <- createDataPartition(hrdata$left, p = .7,list = FALSE,times = 1) # 70%-30% split
trainData <- hrdata[ trainIndex,]
testData  <- hrdata[-trainIndex,]

rfModel <- randomForest(left~.,trainData,ntree=50) # random forest model using all variables
testData$pred <- predict(rfModel,testData) # predictions
testData = testData %>% mutate(accurate = 1*(left == pred))  
table(testData$pred,testData$left) # confusion matrix
sum(testData$accurate)/nrow(testData) # accuracy %