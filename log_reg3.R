# we use this for the final thing

# logistic regression
attach(trainData) # run after partitioning

glm.fit = glm(left ~ satisfaction_level + average_montly_hours + last_evaluation 
              + time_spend_company, family = binomial)

detach(trainData)

attach(testData)

glm.probsTest = predict(glm.fit,testData,type = "response")
glm.predTest = rep(0,nrow(testData))
glm.predTest[glm.probsTest>.5]=1
table(glm.predTest,left) # confusion matrix
mean(glm.predTest == left) # accuracy %

detach(testData)
