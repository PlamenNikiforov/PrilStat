# partition data in 2 sets

hrdata <- HR_comma_sep # save dataset copy

trainIndex <- createDataPartition(hrdata$left, p = .7,list = FALSE,times = 1) # 70%-30% split
trainData <- hrdata[ trainIndex,]
testData  <- hrdata[-trainIndex,]